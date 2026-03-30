const https = require('https');
const fs = require('fs');

const url = 'https://api.alquran.cloud/v1/quran/tr.diyanet';
let body = '';

console.log('Downloading Turkish Tafsir (Diyanet)...');

https.get(url, (res) => {
    res.on('data', (chunk) => { body += chunk; });
    
    res.on('end', () => {
        try {
            const data = JSON.parse(body).data;
            const result = {};
            data.surahs.forEach(s => {
                s.ayahs.forEach(a => {
                    result[s.number + '_' + a.numberInSurah] = a.text;
                });
            });
            fs.writeFileSync('assets/data/tafseer_tr.json', JSON.stringify(result));
            console.log('Turkish Tafsir successfully downloaded and parsed to assets/data/tafseer_tr.json!');
        } catch(e) {
            console.error('Error parsing JSON:', e.message);
        }
    });
}).on('error', (e) => {
    console.error('Error downloading:', e.message);
});
