import fs from 'fs';
import path from 'path';

const brainDir = 'C:\\Users\\Sugumaran\\.gemini\\antigravity-ide\\brain\\86629f96-723b-425d-95db-9b2924e09108';
const destDir = 'd:\\Grozzby\\mobile\\assets\\images';

const files = fs.readdirSync(brainDir);

function copyLatest(prefix, destName) {
  const matching = files.filter(f => f.startsWith(prefix) && f.endsWith('.jpg'));
  if (matching.length > 0) {
    matching.sort();
    const src = path.join(brainDir, matching[matching.length - 1]);
    const dest = path.join(destDir, destName);
    fs.copyFileSync(src, dest);
    console.log(`Copied ${matching[matching.length - 1]} -> ${destName} (${fs.statSync(dest).size} bytes)`);
  }
}

copyLatest('summer_collection_', 'summer_collection.jpg');
copyLatest('category_fashion_', 'category_fashion.jpg');
copyLatest('category_electronics_', 'category_electronics.jpg');
copyLatest('category_beauty_', 'category_beauty.jpg');
copyLatest('category_home_', 'category_home.jpg');
copyLatest('category_accessories_', 'category_accessories.jpg');
copyLatest('category_shoes_', 'category_shoes.jpg');
