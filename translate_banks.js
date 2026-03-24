const fs = require('fs');
const path = require('path');

const banksDir = 'sila_app/assets/banks';
const files = fs.readdirSync(banksDir).filter(f => f.endsWith('.json') && !f.endsWith('_tr.json'));

const translations = {
  grades: {
    'صحيح': 'Sahih',
    'قرآن كريم': 'Kur\'an-ı Kerim',
    'حكمة': 'Hikmet'
  },
  sources: {
    'حصن المسلم': 'Hisnul Müslim',
    'صحيح البخاري': 'Sahih-i Buhari'
  },
  explanations: {
    'من قالها حين يصبح أجير من الجن حتى يمسي ومن قالها حين يمسي أجير من الجن حتى يصبح.': 'Kim bunu sabahladığında söylerse akşama kadar cinlerden korunur, kim de akşamladığında söylerse sabaha kadar cinlerden korunur.',
    'من قرأها ثلاث مرات تكفيه من كل شيء.': 'Kim bunu üç kez okursa, ona her şeyden koruyucu olur.',
    'ذكر ثابت يعين على الطمأنينة وبداية يوم متوازن.': 'Huzur ve dengeli bir gün başlangıcı için sabit bir zikir.',
    'سيد الاستغفار، من قاله موقناً به حين يصبح فمات من يومه دخل الجنة.': 'Seyyidü\'l İstiğfar: Kim buna tam inanarak sabahladığında söyler ve o gün ölürse cennete girer.',
    'من قالها حين يصبح أو يمسي أربع مرات أعتقه الله من النار.': 'Kim bunu sabahladığında veya akşamladığında dört kez söylerse Allah onu ateşten azat eder.',
    'من قالها حين يصبح فقد أدى شكر يومه.': 'Kim bunu sabahladığında söylerse o günün şükrünü eda etmiş olur.',
    'من قالها سبع مرات كفاه الله ما أهمه.': 'Kim bunu yedi kez söylerse, Allah ona dert ettiği konularda yeter.',
    'من قالها ثلاثاً لم يضره شيء.': 'Kim bunu üç kez söylerse ona hiçbir şey zarar veremez.',
    'من قالها ثلاثاً حين يصبح وحين يمسي كان حقاً على الله أن يرضيه يوم القيامة.': 'Kim bunu sabahladığında ve akşamladığında üç kez söylerse, kıyamet günü Allah\'ın onu razı etmesi üzerine bir hak olur.',
    'من قالها ثلاث مرات إذا أمسى لم تضره حمة تلك الليلة.': 'Kim bunu akşamladığında üç kez söylerse, o gece ona hiçbir zehirli hayvan zarar veremez.',
    'من قالها أول نهاره لم تصبه مصيبة حتى يمسي، ومن قالها آخر نهاره لم تصبه مصيبة حتى يصبح.': 'Kim bunu günün başında söylerse akşama kadar ona bir musibet isabet etmez, kim de günün sonunda söylerse sabaha kadar.',
    'من صلى عليّ حين يصبح عشراً وحين يمسي عشراً أدركته شفاعتي يوم القيامة.': 'Kim sabah ve akşam bana onar defa salavat getirirse, kıyamet günü şefaatime nail olur.',
    'حطت خطاياه وإن كانت مثل زبد البحر.': 'Deniz köpüğü kadar olsa bile günahları dökülür.',
    'كانت له عدل عشر رقاب، وكتبت له مائة حسنة، ومحيت عنه مائة سيئة، وكانت له حرزاً من الشيطان يومه ذلك حتى يمسي.': 'On köle azat etmiş gibi olur, yüz sevap yazılır, yüz günah silinir ve akşama kadar şeytandan korunur.',
    'من قالها حي يمسى فقد أدى شكر ليلته.': 'Kim bunu akşamladığında söylerse o gecenin şükrünü eda etmiş olur.',
    'دعاء دخول المسجد': 'Camiye Giriş Duası',
    'دعاء الخروج من المسجد': 'Camiden Çıkış Duası',
    'الذكر المستمر يحفظ القلب من الغفلة.': 'Sürekli zikir, kalbi gafletten korur.',
    'تذكير تعبدي مختصر يعينك على الثبات والاستمرارية.': 'İstikrar ve devamlılık için kısa ibadet hatırlatması.',
    'الاستغفار اليومي سبب للرزق والطمأنينة.': 'Günlük istiğfar, rızık ve huzur sebebidir.',
    'التسبيح الخفيف على اللسان ثقيل في الميزان.': 'Dilde hafif, mizanda ağır tesbih.',
    'الحفظ المنتظم يرفع المنزلة ويقوي الصلة بالقرآن.': 'Düzenli hafızlık, mertebeyi yükseltir ve Kur\'an ile bağı güçlendirir.',
    'القراءة المتكررة طريق ثابت للإتقان.': 'Tekrarlı okuma, sağlam bir ezberin yoludur.',
    'الاستمرار في القراءة يصنع تراكمًا عظيمًا في الأجر.': 'Okumaya devam etmek, büyük bir sevap birikimi sağlar.',
    'الورد القرآني اليومي يثبت القلب ويزيد الإيمان.': 'Günlük Kur\'an virdi kalbi sabit kılar ve imanı artırır.',
    'كل حرف من القرآن مضاعف الأجر فلا تستقل القليل.': 'Kur\'an\'ın her harfi kat kat sevaptır, azı küçümseme.',
    'إتقان الوضوء يعين على حضور القلب في الصلاة.': 'Abdesti güzel almak, namazda kalp huzuruna yardımcı olur.',
    'توازن القلب بين الرجاء والخوف أصل الثبات.': 'Kalbin ümit ve korku dengesi, istikrarın aslıdır.',
    'التعظيم الحقيقي يظهر في العمل لا في الكلام.': 'Gerçek tazim sözde değil, amelde görülür.',
    'العلم بلا تطبيق يفقد أثره سريعاً.': 'Uygulanmayan ilim etkisini çabuk kaybeder.',
    'الإخلاص يطهر القصد في كل عبادة.': 'İhlas, her ibadette niyeti temizler.',
    'الباطن الصالح يثمر ظاهرًا مستقيمًا.': 'Salih bir iç dünya, istikametli bir dış görünüş verir.',
    'خذ العبرة قبل أن تصبح أنت العبرة.': 'İbret olmadan önce ibret al.',
    'برنامج عملي لإحياء القلب يومياً.': 'Kalbi günlük ihya etmek için pratik bir program.',
    'املأ يومك بطاعة قبل أن يملأه الفراغ.': 'Gününüzü boşluk doldurmadan önce itaatle doldurun.',
    'الدعاء توفيق عظيم لا يُحرم منه إلا غافل.': 'Dua büyük bir muvaffakiyettir, ancak gafil olan mahrum kalır.',
    'مكانة الطاعة في قلبك مرآة لحالك.': 'Kalbindeki itaat yeri, halinin aynasıdır.',
    'أحسن عبادتك يعلُ قدرك عند الله.': 'İbadetini güzelleştir, Allah katındaki değerin artsın.',
    'توازن العلم والعمل هو طريق الثبات.': 'İlim ve amel dengesi, sebatın yoludur.',
    'الصدق مع الله يجلب المعونة والتيسير.': 'Allah ile sadakat, yardım ve kolaylık getirir.',
    'محاسبة النفس اليومية تحمي من الغفلة.': 'Günlük nefis muhasebesi gafletten korur.',
    'الصغيرة مع الإصرار تفسد القلب.': 'Israrla işlenen küçük günah kalbi bozar.',
    'الاستمرارية اليومية أعظم من الاندفاع المؤقت.': 'Günlük devamlılık, geçici hevesten daha büyüktür.',
    'الذكر اليومي يحفظ القلب حيًّا.': 'Günlük zikir kalbi diri tutur.',
    'إدارة الوقت عبادة تعين على الإنجاز.': 'Zaman yönetimi, başarıya yardımcı bir ibadettir.',
    'رجاء بلا عمل أمانٍ، والعمل بلا رجاء قسوة.': 'Amelsiz ümit kuruntu, ümitsiz amel ise kasvet verir.',
    'توحيد الهدف يخفف تشتت القلب.': 'Hedefi birlemek, kalbin dağınıklığını giderir.',
    'الصبر العملي وقود الطريق إلى الله.': 'Pratik sabır, Allah\'a giden yolun yakıtıdır.',
    'فتش عن سبب القسوة وعالجه بالتوبة.': 'Kalp katılığının sebebini ara ve tövbe ile tedavi et.',
    'بداية اليوم بطاعة تصنع فرقاً كبيراً.': 'Güne itaatle başlamak büyük fark yaratır.',
    'الصلاة ملجأ القلب عند الشدائد.': 'Namaz, zorluklarda kalbin sığınağıdır.',
    'الورد القرآني اليومي غذاء القلب.': 'Günlük Kur\'an virdi kalbin gıdasıdır.',
    'الاستغفار مفتاح تفريج الكروب.': 'İstiğfar, sıkıntıları gidermenin anahtarıdır.',
    'الدعاء يقوي اليقين ويربط القلب بالله.': 'Dua yakini güçlendirir ve kalbi Allah\'a bağlar.',
    'حياتك لا تخرج عن شكر أو توبة.': 'Hayatın şükür veya tövbeden ibarettir.',
    'العادات الصالحة تُبنى بالتدرج والثبات.': 'Salih alışkanlıklar tedricilik ve sebatla inşa edilir.',
    'أعظم أسباب الثبات كثرة الالتجاء لله.': 'Sebatın en büyük sebebi Allah\'a çokça sığınmaktır.',
    'الاستمرار الصادق يفتح أبواب الخير.': 'Sadık devamlılık hayır kapılarını açar.',
    'حضور القرآن يحصن القلب من الزلل.': 'Kur\'an ile beraberlik kalbi hatalardan korur.',
    'استحضار الآخرة يعين على ضبط النفس.': 'Ahireti hatırlamak nefsi kontrol etmeye yardımcı olur.',
    'الهداية طلب يومي لا يتوقف.': 'Hidayet, durmayan günlük bir taleptir.',
    'ابدأ بإصلاح الداخل يصلح الخارج تلقائياً.': 'İçini düzeltmeye başla, dışın kendiliğinden düzelir.',
    'التواضع بعد العمل علامة إخلاص.': 'Amelden sonra tevazu, ihlasın alametidir.',
    'اجعل لك وردًا لا يسقط مهما ازدحم يومك.': 'Günün ne kadar yoğun olursa olsun düşmeyen bir virdin olsun.',
    'الليل يصنع علاقة خاصة بين العبد وربه.': 'Gece, kul ile Rabbi arasında özel bir bağ kurar.',
    'المعرفة بالله تثمر مراقبة صادقة.': 'Allah\'ı tanımak, sadık bir murakabe meyvesi verir.',
    'حسن الخلق باب عظيم للدعوة والتأثير.': 'Güzel ahlak, davet ve etki için büyük bir kapıdır.',
    'الذكر علامة لطف من الله بالعبد.': 'Zikir, Allah\'ın kuluna lütfunun bir işaretidir.',
    'العلم الصحيح يقود للتقوى لا للكبر.': 'Doğru ilim kibre değil takvaya götürür.',
    'لا تترك باب الدعاء في كل حال.': 'Hiçbir durumda dua kapısını bırakma.',
    'إصلاح الذات مقدم على نقد الآخرين.': 'Kendini düzeltmek, başkalarını eleştirmekten öncedir.',
    'الاستمرار في الطاعة يفتح لك أبوابًا جديدة.': 'İtaatte devamlılık sana yeni kapılar açar.',
    'الثبات على الطاعة أعظم من طلب الخوارق.': 'İtaatte sebat, olağanüstülük aramaktan daha büyüktür.',
    'وقت الفتور يحتاج ثباتًا لا انسحابًا.': 'Fetret zamanı geri çekilmeyi değil, sebatı gerektirir.',
    'إصلاح العلاقة مع الله ينعكس على كل حياتك.': 'Allah ile ilişkiyi düzeltmek tüm hayatına yansır.',
    'مجاهدة النفس اليومية أصل النجاح.': 'Günlük nefis mücadelesi başarının aslıdır.',
    'لا تؤخر الرجوع إلى الله مهما كان تقصيرك.': 'Kusurun ne olursa olsun Allah\'a dönüşü geciktirme.',
    'القرآن يصنع الشخصية قبل المعلومات.': 'Kur\'an, bilgiden önce şahsiyeti inşa eder.',
    'التقدم اليومي ولو قليلًا هو النجاح الحقيقي.': 'Az da olsa günlük ilerleme gerçek başarıdır.',
    'البيئة الصالحة تعينك على الاستمرار.': 'Salih çevre devamlılığa yardımcı olur.',
    'القرآن أنفع علاج لقسوة القلب.': 'Kur\'an, kalp katılığının en faydalı ilacıdır.',
    'المداومة أهم من الكثرة المؤقتة.': 'Devamlılık, geçici çokluktan daha önemlidir.',
    'اشغل لسانك بالذكر قبل أن يشغلك باللغو.': 'Dilini boş sözle meşgul etmeden zikirle meşgul et.',
    'الصدق يبارك العمل القليل فيعظمه.': 'Sadakat az ameli bereketlendirir ve büyütür.',
    'الثبات يجلب السكينة والبركة يومًا بعد يوم.': 'Sebat, günden güne sekine ve bereket getirir.',
    'اغتنم قوتك وصحتك قبل الفوات.': 'Fırsat geçmeden gücünü ve sağlığını değerlendir.',
    'كل طاعة منحة تستحق الشكر والاستمرار.': 'Her itaat, şükrü ve devamı hak eden bir lütuftur.',
    'الحمد يجدد الشكر ويشرح الصدر في يومك.': 'Hamd, şükrü yeniler ve gününde göğsü genişletir.'
  }
};

files.forEach(file => {
  const filePath = path.join(banksDir, file);
  const content = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  
  const translatedContent = content.map(item => {
    // Clone item
    const newItem = { ...item };
    
    // Translate Grade
    if (newItem.grade && translations.grades[newItem.grade]) {
      newItem.grade = translations.grades[newItem.grade];
    }
    
    // Translate Source
    if (newItem.source) {
      let translatedSource = newItem.source;
      if (translations.sources[newItem.source]) {
        translatedSource = translations.sources[newItem.source];
      } else if (newItem.source.includes('صحيح البخاري')) {
        translatedSource = newItem.source.replace('صحيح البخاري', 'Sahih-i Buhari').replace('حديث', 'Hadis');
      } else if (newItem.source.includes('سورة')) {
         // Keep Surah names mostly as is but transliterate "Ayah"
         translatedSource = newItem.source.replace('آية', 'Ayet').replace('سورة', 'Sure');
      }
      newItem.source = translatedSource;
    }
    
    // Translate Explanation
    if (newItem.short_explanation && translations.explanations[newItem.short_explanation]) {
      newItem.short_explanation = translations.explanations[newItem.short_explanation];
    }
    
    return newItem;
  });
  
  const newFileName = file.replace('.json', '_tr.json');
  fs.writeFileSync(path.join(banksDir, newFileName), JSON.stringify(translatedContent, null, 2));
  console.log(`Generated ${newFileName}`);
});
