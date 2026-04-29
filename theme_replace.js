const fs = require('fs');
let html = fs.readFileSync('index.html', 'utf8');

// Colors
html = html.replace(/--merah:/g, '--biru:');
html = html.replace(/--merah-gelap:/g, '--biru-gelap:');
html = html.replace(/var\(--merah\)/g, 'var(--biru)');
html = html.replace(/var\(--merah-gelap\)/g, 'var(--biru-gelap)');
html = html.replace(/#E8001D/g, '#007BFF');
html = html.replace(/#B8001A/g, '#0056b3');
html = html.replace(/rgba\(232,0,29/g, 'rgba(0,123,255');
html = html.replace(/#1a0000/g, '#0a1f3a');
html = html.replace(/#2a0000/g, '#041122');

html = html.replace(
`    background: linear-gradient(135deg, #0D0D0D 0%, #0a1f3a 50%, #0D0D0D 100%);`,
`    background: radial-gradient(circle at top, #0a1f3a, #010611);`
);

// We made a replace on the literal #1a0000 earlier, so let's use the replaced version above
html = html.replace(
`    background: linear-gradient(180deg, #0D0D0D 0%, #0a1f3a 50%, #0D0D0D 100%);`,
`    background: linear-gradient(180deg, #0D0D0D 0%, #0a1f3a 100%);`
);

// Fix the giant wa SVG that might exist
html = html.replace(
`.btn-wa svg { width: 26px; height: 26px; fill: white; flex-shrink: 0; }`,
`.btn-wa svg, .btn-cta-wa svg { width: 24px; height: 24px; fill: white; flex-shrink: 0; }`
);

// The Final CTA section: "Siap Pesan Jersey Custom?" - background in image is solid cyan/blue
html = html.replace(
`  .final-cta {
    background: var(--biru);
    padding: 80px 20px;
    text-align: center;
    position: relative;
    overflow: hidden;
  }`,
`  .final-cta {
    background: #007BFF;
    padding: 80px 20px;
    text-align: center;
    position: relative;
    overflow: hidden;
  }`
);

// Replace hero background explicitly if the above replace didn't work because of indents
html = html.replace(
  /background: linear-gradient\(135deg, #0D0D0D 0%, #0a1f3a 50%, #0D0D0D 100%\);/g,
  'background: radial-gradient(circle at top, #0a1f3a, #010611);'
);

fs.writeFileSync('index.html', html);
console.log('Done');
