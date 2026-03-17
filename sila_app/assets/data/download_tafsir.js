const https = require('https');
const fs = require('fs');

const url = 'https://api.alquran.cloud/v1/quran/ar.jalalayn';
let body = '';

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
            fs.writeFileSync('tafseer.json', JSON.stringify(result));
            console.log('Tafsir successfully downloaded and parsed!');
        } catch(e) {
            console.error('Error parsing JSON:', e.message);
        }
    });
}).on('error', (e) => {
    console.error('Error downloading:', e.message);
});
