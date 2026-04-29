CREATE DATABASE IF NOT EXISTS braveline_db;
USE braveline_db;

-- Settings & Hero
CREATE TABLE IF NOT EXISTS brv_rev_site_settings (
    `key` VARCHAR(100) PRIMARY KEY,
    `value` TEXT
);

CREATE TABLE IF NOT EXISTS brv_rev_hero (
    `key` VARCHAR(100) PRIMARY KEY,
    `value` TEXT
);

-- Features & USP
CREATE TABLE IF NOT EXISTS brv_rev_trust_bar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(50),
    highlight_text VARCHAR(255),
    description_text VARCHAR(255),
    urutan INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS brv_rev_usp_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    icon VARCHAR(50),
    title VARCHAR(255),
    description TEXT,
    urutan INT DEFAULT 0,
    aktif BOOLEAN DEFAULT TRUE
);

-- Pricing
CREATE TABLE IF NOT EXISTS brv_rev_harga_paket (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_paket VARCHAR(255),
    badge_text VARCHAR(100),
    harga_ecer DECIMAL(15,2),
    satuan_ecer VARCHAR(50),
    harga_lusin DECIMAL(15,2),
    satuan_lusin VARCHAR(50),
    fitur_list JSON,
    is_featured BOOLEAN DEFAULT FALSE,
    urutan INT DEFAULT 0,
    aktif BOOLEAN DEFAULT TRUE
);

-- Catalog & Category
CREATE TABLE IF NOT EXISTS brv_rev_kategori (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100),
    emoji VARCHAR(50),
    kode_filter VARCHAR(100) UNIQUE,
    urutan INT DEFAULT 0,
    aktif BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS brv_rev_katalog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(255),
    kategori VARCHAR(100),
    tag_promo VARCHAR(100),
    marketplace_link VARCHAR(255),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content
CREATE TABLE IF NOT EXISTS brv_rev_carousel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_url VARCHAR(255),
    urutan INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS brv_rev_testimonials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255),
    jabatan_perusahaan VARCHAR(255),
    pesan TEXT,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS brv_rev_faq (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pertanyaan TEXT,
    jawaban TEXT,
    urutan INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS brv_rev_proses_order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nomor INT,
    ikon VARCHAR(50),
    judul VARCHAR(255),
    deskripsi TEXT,
    aktif BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS brv_rev_countdown (
    id VARCHAR(50) PRIMARY KEY,
    label VARCHAR(255),
    end_date DATETIME,
    `show` BOOLEAN DEFAULT TRUE
);

-- Admin & Auth
CREATE TABLE IF NOT EXISTS brv_rev_admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255)
);

-- Default Admin (Password: admin123)
-- In a real app, use password_hash(). For this simple migration, we'll handle it in api.php
INSERT INTO brv_rev_admin (username, password_hash) VALUES ('admin', 'admin123');

-- Default Settings
INSERT INTO brv_rev_site_settings (`key`, `value`) VALUES 
('site_title', 'Braveline Apparel'),
('wa_number', '6285199227070'),
('trust_bar_speed', '20');

INSERT INTO brv_rev_hero (`key`, `value`) VALUES 
('hero_badge', 'OFFICIAL MANUFAKTUR'),
('hero_title1', 'MANUFAKTUR JERSEY'),
('hero_title2', 'MUTU TINGGI &'),
('hero_title3', 'EKONOMIS'),
('hero_subtitle', 'Sentra produksi kaos olahraga cetakan personal bermutu.');
