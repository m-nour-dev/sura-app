const fs = require('fs');
const path = require('path');

const banksDir = 'sila_app/assets/banks';
const files = fs.readdirSync(banksDir).filter(f => f.endsWith('.json') && !f.endsWith('_tr.json'));

const uniqueValues = {
  source: new Set(),
  grade: new Set(),
  short_explanation: new Set(),
  category: new Set(),
  subcategory: new Set()
};

files.forEach(file => {
  const content = JSON.parse(fs.readFileSync(path.join(banksDir, file), 'utf8'));
  content.forEach(item => {
    if (item.source) uniqueValues.source.add(item.source);
    if (item.grade) uniqueValues.grade.add(item.grade);
    if (item.short_explanation) uniqueValues.short_explanation.add(item.short_explanation);
    if (item.category) uniqueValues.category.add(item.category);
    if (item.subcategory) uniqueValues.subcategory.add(item.subcategory);
  });
});

console.log('SOURCES:', [...uniqueValues.source]);
console.log('GRADES:', [...uniqueValues.grade]);
console.log('EXPLANATIONS:', [...uniqueValues.short_explanation]);
