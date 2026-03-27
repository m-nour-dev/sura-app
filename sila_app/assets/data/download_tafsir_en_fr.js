const fs = require('fs');
const https = require('https');
const path = require('path');

const editions = [
    { id: 'en.sahih', filename: 'translation_en.json' },
    { id: 'en.maududi', filename: 'tafseer_en.json' },
    { id: 'fr.hamidullah', filename: 'translation_fr.json' },
    { id: 'fr.hamidullah', filename: 'tafseer_fr.json' } // Using Hamidullah for both if no specific French tafsir
];

async function downloadEdition(edition) {
    console.log(`Downloading ${edition.id}...`);
    return new Promise((resolve, reject) => {
        https.get(`https://api.alquran.cloud/v1/quran/${edition.id}`, (res) => {
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });
            res.on('end', () => {
                try {
                    const json = JSON.parse(data);
                    if (json.code !== 200) {
                        reject(new Error(`Failed to download ${edition.id}: ${json.data}`));
                        return;
                    }
                    
                    const transformed = {};
                    json.data.surahs.forEach(surah => {
                        surah.ayahs.forEach(ayah => {
                            // Extract surah and ayah number from the surah object or the ayah reference
                            // In this API, ayah.number is the absolute number, so we use surah.number and index+1
                            const key = `${surah.number}_${ayah.numberInSurah}`;
                            transformed[key] = ayah.text;
                        });
                    });
                    
                    const outputPath = path.join(__dirname, edition.filename);
                    fs.writeFileSync(outputPath, JSON.stringify(transformed, null, 2));
                    console.log(`Saved to ${outputPath}`);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            });
        }).on('error', (e) => {
            reject(e);
        });
    });
}

async function run() {
    for (const edition of editions) {
        try {
            await downloadEdition(edition);
        } catch (e) {
            console.error(`Error downloading ${edition.id}:`, e.message);
        }
    }
}

run();
