<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Database Configuration
$host = 'localhost';
$db   = 'alilogis_braveline';
$user = 'alilogis__FeEg2xDiwlSISzIJmopoCV_8I3QlB-FE';
$pass = 'eGQG2xvzNsDKbXYFamVT';
$charset = 'utf8mb4';

try {
    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (\PDOException $e) {
    header("Content-Type: text/html");
    die("<h2 style='color:red'>Koneksi Database Gagal!</h2>
         <p>Error: " . $e->getMessage() . "</p>
         <p><b>Saran:</b> Pastikan Docker sudah running dan jalankan <code>docker-compose up -d</code> di terminal.</p>");
}

// AUTO-REPAIR: Ensure Admin Table exists
try {
    $pdo->exec("CREATE TABLE IF NOT EXISTS brv_rev_admin (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(100) UNIQUE,
        password_hash VARCHAR(255)
    )");
    
    // Check if any admin exists, if not, create default
    $count = $pdo->query("SELECT COUNT(*) FROM brv_rev_admin")->fetchColumn();
    if ($count == 0) {
        $pdo->prepare("INSERT INTO brv_rev_admin (username, password_hash) VALUES ('admin', 'admin123')")->execute();
    }
} catch (Exception $e) {
    // Silently ignore or log if table already exists or other issues
}

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';
$table  = $_GET['table'] ?? '';

// 1. AUTHENTICATION RPC EMULATION
if ($action === 'rpc') {
    $input = json_decode(file_get_contents('php://input'), true);
    $fn = $_GET['fn'] ?? '';

    if ($fn === 'verify_admin_password') {
        $pass_check = $input['password_to_check'] ?? '';
        
        try {
            $stmt = $pdo->prepare("SELECT * FROM brv_rev_admin WHERE username = 'admin' LIMIT 1");
            $stmt->execute();
            $admin = $stmt->fetch();
            
            if ($admin && $pass_check === $admin['password_hash']) {
                echo json_encode(true);
            } else {
                echo json_encode(false);
            }
        } catch (Exception $e) {
            echo json_encode(['error' => $e->getMessage()]);
        }
        exit;
    }

    if ($fn === 'update_admin_password') {
        $new_pass = $input['new_password'] ?? '';
        $stmt = $pdo->prepare("UPDATE brv_rev_admin SET password_hash = ? WHERE username = 'admin'");
        $stmt->execute([$new_pass]);
        echo json_encode(['data' => 'success']);
        exit;
    }
}

// 2. IMAGE UPLOAD HANDLING
if ($action === 'upload') {
    if (!isset($_FILES['file'])) {
        echo json_encode(['error' => 'No file uploaded']);
        exit;
    }
    
    $target_dir = "uploads/";
    if (!file_exists($target_dir)) {
        mkdir($target_dir, 0777, true);
    }
    
    $file_ext = pathinfo($_FILES["file"]["name"], PATHINFO_EXTENSION);
    $file_name = time() . "_" . uniqid() . "." . $file_ext;
    $target_file = $target_dir . $file_name;
    
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
        $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
        $url = $protocol . "://" . $_SERVER['HTTP_HOST'] . "/" . $target_file;
        echo json_encode(['publicUrl' => $url]);
    } else {
        echo json_encode(['error' => 'Failed to move uploaded file']);
    }
    exit;
}

// 3. CRUD OPERATIONS
if ($method === 'GET') {
    if (!$table) {
        echo json_encode(['error' => 'Table name required']);
        exit;
    }
    
    $query = "SELECT * FROM `$table`";
    $where_clauses = [];
    $params = [];
    
    if (isset($_GET['key'])) {
        $where_clauses[] = "`key` = ?";
        $params[] = $_GET['key'];
    }
    if (isset($_GET['id'])) {
        $where_clauses[] = "`id` = ?";
        $params[] = $_GET['id'];
    }
    if (isset($_GET['aktif'])) {
        $where_clauses[] = "`aktif` = 1";
    }
    
    if (!empty($where_clauses)) {
        $query .= " WHERE " . implode(" AND ", $where_clauses);
    }
    
    if (isset($_GET['order'])) {
        $order = preg_replace('/[^a-zA-Z0-9_]/', '', $_GET['order']);
        $dir = (strtoupper($_GET['dir'] ?? 'ASC') === 'DESC') ? 'DESC' : 'ASC';
        $query .= " ORDER BY `$order` $dir";
    }
    
    try {
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $data = $stmt->fetchAll();
        
        foreach ($data as $i => $row) {
            foreach ($row as $k => $v) {
                if (is_string($v) && strlen($v) > 1 && (($v[0] == '[' && $v[strlen($v)-1] == ']') || ($v[0] == '{' && $v[strlen($v)-1] == '}'))) {
                    $decoded = json_decode($v, true);
                    if (json_last_error() == JSON_ERROR_NONE) $data[$i][$k] = $decoded;
                }
            }
        }

        if (isset($_GET['single']) && count($data) > 0) {
            echo json_encode($data[0]);
        } else {
            echo json_encode($data);
        }
    } catch (Exception $e) {
        echo json_encode(['error' => $e->getMessage()]);
    }
} 
elseif ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$table || !$input) exit;
    
    $rows = isset($input[0]) ? $input : [$input];
    
    try {
        foreach ($rows as $data) {
            $keys = array_keys($data);
            $fields = implode("`, `", $keys);
            $placeholders = implode(", ", array_fill(0, count($keys), "?"));
            
            foreach ($data as $k => $v) {
                if (is_array($v)) $data[$k] = json_encode($v);
            }
            
            $sql = "INSERT INTO `$table` (`$fields`) VALUES ($placeholders) ON DUPLICATE KEY UPDATE ";
            $updates = [];
            foreach ($keys as $k) {
                $updates[] = "`$k` = VALUES(`$k`)";
            }
            $sql .= implode(", ", $updates);
            
            $stmt = $pdo->prepare($sql);
            $stmt->execute(array_values($data));
        }
        echo json_encode(['data' => 'success']);
    } catch (Exception $e) {
        echo json_encode(['error' => $e->getMessage()]);
    }
}
elseif ($method === 'DELETE') {
    if (!$table || !isset($_GET['id'])) exit;
    try {
        $stmt = $pdo->prepare("DELETE FROM `$table` WHERE id = ?");
        $stmt->execute([$_GET['id']]);
        echo json_encode(['data' => 'success']);
    } catch (Exception $e) {
        echo json_encode(['error' => $e->getMessage()]);
    }
}
