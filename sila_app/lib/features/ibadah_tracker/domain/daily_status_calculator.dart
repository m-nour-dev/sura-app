import 'dart:math';

import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';

class DailyStatusCalculator {
  static final Random _random = Random();
  static final Map<int, String> _dailyTextCache = {};

  static int totalCount({required bool isMale}) => isMale ? 15 : 10;

  static int completedCount(IbadahRecord record, {required bool isMale}) {
    var done = 0;
    final prayerStatuses = [
      record.fajrStatus,
      record.dhuhrStatus,
      record.asrStatus,
      record.maghribStatus,
      record.ishaStatus,
    ];
    done += prayerStatuses.where((status) => status == 1 || status == 2).length;

    if (isMale) {
      final masjidStatuses = [
        record.fajrInMasjid,
        record.dhuhrInMasjid,
        record.asrInMasjid,
        record.maghribInMasjid,
        record.ishaInMasjid,
      ];
      done += masjidStatuses.where((v) => v == true).length;
    }

    final bools = [
      record.readWird,
      record.readAzkarSabah,
      record.readAzkarMasa,
      record.didTasbih,
      (record.didHifz || record.didTasmi),
      // record.rememberedAllah, // Removed as per request
      !isMale,
    ];

    done += bools.where((v) => v).length - (!isMale ? 1 : 0);
    return done;
  }

  static double completionRatio(IbadahRecord record, {required bool isMale}) {
    final total = totalCount(isMale: isMale);
    if (total == 0) return 0;
    return min(1, completedCount(record, isMale: isMale) / total);
  }

  static String getDailyStatusText(IbadahRecord record,
      {required bool isMale, String languageCode = 'ar'}) {
    final ratio = completionRatio(record, isMale: isMale);
    final missedPrayers = [
      record.fajrStatus,
      record.dhuhrStatus,
      record.asrStatus,
      record.maghribStatus,
      record.ishaStatus,
    ].where((s) => s == 0).length;
    final missedDhikr = !record.rememberedAllah;
    final missedWird = !record.readWird;
    final missedAzkar = !record.readAzkarSabah || !record.readAzkarMasa;
    final missedHifz = !(record.didHifz || record.didTasmi);

    List<String> texts;

    if (languageCode == 'tr') {
       if (missedPrayers >= 2) {
        texts = const [
          'Namaz kurtuluştur, bugün ilk dönülecek kapı olsun.',
          'Namaz nefse ağır geliyorsa, bil ki kalp yakınlık istiyordur.',
          'Namazını kıl, günün dolsun, ruhun huzur bulsun.',
          'Rahmet kapısını erteleme, namaz vakti açık bir kapıdır.',
          'Her samimi secde, kalpten uzun bir yorgunluğu siler.',
          'Seninle huzur arasında samimi bir tekbir vardır.',
          'Namazın dönüşü, sonrasının düzelmesinin başlangıcıdır.',
          'Allah seni beş kez çağırıyor, bu çağrıya hazır bir kalple icabet et.',
          'Göğsün daraldığında, ferahlık secdededir.',
          'Namazı, dünya ile pazarlık edilmeyen bir randevu yap.',
        ];
      } else if (missedDhikr || missedAzkar) {
        texts = const [
          'Allah’ı an, O da seni ansın; bu kalbe en büyük yetinmedir.',
          'Zikir kalbin hayatıdır, kendini bu hayattan mahrum etme.',
          'Bir dakikalık zikir, tam bir günün huzurunu inşa eder.',
          'Zikirle ıslanan dil ve huzur bulan kalp.',
          'Sabahını ve akşamını Allah ile başlat, Allah ile bitir.',
          'Allah’ı zikretmek en yakın, en kolay ve en kalıcı kaledir.',
          'Kalp huzursuzsa, onu istiğfar ve tesbih ile sabitle.',
          'Zikredenler, amel hafifliği ve etki büyüklüğü ile öne geçerler.',
          'Zikrini artır, Allah’ın izniyle kalbinin nuru artsın.',
          'Subhanallah, paslanmayan bir rahatlık anahtarıdır.',
        ];
      } else if (missedWird || missedHifz) {
        texts = const [
          'Kuran gününün yoldaşıdır, ondan nasibini terk etme.',
          'Her gün az ayet, büyük bir sebat inşa eder.',
          'Kuran’a devam edenin, Allah gizlisini ve açığını ıslah eder.',
          'Kalbini tilavetin bereketinden, dakikalarca da olsa mahrum etme.',
          'Hıfz adım adımdır, bereket devamlılıktadır.',
          'Günün için en güzel yatırım, ihlasla ezberlediğin bir ayettir.',
          'Her Kuran virdi, yoluna eklenen bir nurdur.',
          'Gününü Mushaf’a bağla, Allah seni fitnelerden korur.',
          'Kuran’ın azı bile, devamlı olursa Allah katında çoktur.',
          'Bugünün ayeti, yarının kurtuluşu olabilir.',
        ];
      } else if (ratio == 1.0) {
        texts = const [
          'Gününe güzellikle başlayıp güzellikle bitirene ne mutlu.',
          'Müminler kurtuluşa ermiştir.',
          'Allah’ım kabul et, hayır dolu bir gün.',
          'Şüphesiz iyiler nimet içindedir.',
          'Maşallah, bugünkü sebatın sadakat alametidir.',
          'Devamlılığın büyük bir nimettir, buna şükret.',
          'Bu güzel bir gün, Allah’tan kabul ve devamlılık iste.',
          'Allah’tan bu güzel sebatı bereketlendirmesini dileriz.',
          'Hayır tamamlanınca, Allah’a şükür onu süsler.',
          'İtaatte devamlılık, yakınlığın en güzel kapılarındandır.',
        ];
      } else if (ratio >= 0.7) {
        texts = const [
          'Rabbinizden bir mağfirete koşun.',
          'Allah’ım, zikrine, şükrüne ve güzel ibadetine bize yardım et.',
          'Yarın Allah’ın izniyle başka bir fırsat, durma.',
          'Az kaldı, gününü Allah’a yakınlıkla tamamla.',
          'Gününün bereketi tamamlanmak üzere, basit adımlar kaldı.',
          'Güzel sebat, biraz daha ekle, Allah sana çokça açar.',
          'Bugün iyiydin, iyiliğin devamı daha büyüktür.',
          'Günün geri kalanını sadık bir niyetle değerlendir.',
          'Tamamlanmaya çok yakın, durmadan devam et.',
          'Kalan az, Allah sana kolaylıkla açar.',
        ];
      } else if (ratio >= 0.4) {
        texts = const [
          'Allah’ın rahmetinden ümidinizi kesmeyin, Allah bütün günahları bağışlar.',
          'Her saat, Allah’a dönüş için bir fırsattır.',
          'Allah kulunun tövbesiyle sevinir, şimdi başla.',
          'Yapabildiğinle başla, Allah kendisine yönelen kulu sever.',
          'Yol bir adımla başlar, bugünkü adımın bereketlidir.',
          'Telafi kapısı, günde zaman kaldığı sürece açıktır.',
          'Günün geri kalanını, geçenden daha sadık kıl.',
          'Modunu bekleme, başla ve yardım sana gelir.',
          'Şu an güzel bir başlangıç, sürekli ertelemekten hayırlıdır.',
          'Gelecek her dakika, kaçanı telafi etmek için bir fırsattır.',
        ];
      } else {
        texts = const [
          'Şüphesiz Allah çok bağışlayan, çok esirgeyendir, ümitsizliğe kapılma.',
          'Rahmetim her şeyi kuşatmıştır.',
          'Günahtan tövbe eden, hiç günahı olmayan gibidir, Allah’a dön.',
          'Şimdi başla, küçük bir amelle bile olsa, Allah kalbini açar.',
          'Allah’a en yakın yol, dönüşün sadakatidir.',
          'Başlaman yeterli, hayrı tamamlamak Allah’ın lütfundadır.',
          'Zayıflık, Allah’tan çokça yardım istemekle kaybolur.',
          'Ne kadar geç kalsak da bugün yeni bir başlangıçtır.',
          'Kendini bir günle yargılama, yeniden başla.',
          'Rahmet kapısı geniştir, onu tövbe ve amelle aç.',
        ];
      }
    } else {
      // Default Arabic texts
    if (missedPrayers >= 2) {
      texts = const [
        'الصلاة نجاة، فاجعلها أول ما تعود إليه اليوم',
        'إذا ثقلت الصلاة على النفس فاعلم أن القلب يحتاج قربا',
        'أقم صلاتك يستقم يومك وتطمئن روحك',
        'لا تؤخر باب الرحمة، فموعد الصلاة باب مفتوح',
        'كل سجدة صادقة تمسح عن القلب تعبا طويلا',
        'بينك وبين الطمأنينة تكبيرة صادقة',
        'عودة الصلاة بداية صلاح ما بعدها',
        'الله يناديك خمس مرات، فلب النداء بقلب حاضر',
        'إذا ضاق صدرك فموضع الانشراح في السجود',
        'اجعل الصلاة موعدا لا تفاوض فيه مع الدنيا',
        'إذا حفظت صلاتك حفظ الله بقية يومك',
        'الصلاة أول إصلاح النفس وأعظم أسباب الثبات',
        'من صدق في صلاته وجد أثرها في يومه كله',
        'بداية العودة الصحيحة تكون من محراب الصلاة',
        'لا تحمل هم الغد، أقم صلاتك اليوم بإحسان',
        'عند السجود تتساقط أثقال القلب',
        'حين تتعب الروح فدواؤها صلاة خاشعة',
        'الموفق من جعل الصلاة خطًا أحمر في يومه',
        'اجعل كل أذان رسالة رحمة لك لا تُفوّت',
        'صلاتك هي المعيار الحقيقي لثباتك',
        'إذا نادى المنادي فدع الدنيا وأقبل على الله',
        'الصلاة جسر النجاة في يوم مزدحم',
        'حافظ على الصلاة يفتح الله لك أبواب التيسير',
        'المؤمن القوي يبدأ يومه وينهيه بالصلاة',
        'السكينة تسكن قلب من حافظ على الفريضة',
        'لا تنشغل عن أصل نجاتك: الصلاة',
        'كل صلاة في وقتها خطوة إلى رضا الله',
        'أدِّ الصلاة كما لو كانت آخر عهدك بالدنيا',
        'في الصلاة صلاح القلب وسلامة الطريق',
      ];
    } else if (missedDhikr || missedAzkar) {
      texts = const [
        'اذكر الله يذكرك الله، وهذه أعظم كفاية للقلب',
        'الذكر حياة للقلب فلا تحرم نفسك هذه الحياة',
        'دقيقة ذكر تصنع سكينة يوم كامل',
        'لسان يلهج بالذكر، وقلب يجد برد الطمأنينة',
        'اجعل صباحك ومسائك بالله يبدأ وبالله يختم',
        'ذكر الله هو الحصن الأقرب والأسهل والأبقى',
        'إذا اضطرب القلب فأثبته بالاستغفار والتسبيح',
        'الذاكرون يسبقون بخفة العمل وعظم الأثر',
        'زد ذكرك يزد نور قلبك بإذن الله',
        'سبحان الله مفتاح راحة لا يصدأ',
        'أذكارك حصنك اليومي فلا تتركه',
        'ما أعظم قلبًا يأنس بذكر الله',
        'استكثر من الذكر تجد بركة الوقت',
        'بذكر الله تطيب ساعاتك مهما كثرت الأشغال',
        'الاستغفار يمحو العثرات ويشرح الصدر',
        'اجعل لسانك حيًا بالذكر في كل أحوالك',
        'كل تسبيحة تكتب لك نورًا وأجرًا',
        'من لزم الذكر عاش مطمئنًا',
        'قلبك يحتاج الذكر كما يحتاج الجسد الماء',
        'أذكار الصباح والمساء سياج الإيمان اليومي',
        'لا تدع يومك يمر دون ورد من التسبيح',
        'الذاكر قريب من الله في كل لحظة',
        'إذا ضاقت الدنيا فافزع إلى الذكر',
        'ذكر الله يحيي القلب بعد الغفلة',
      ];
    } else if (missedWird || missedHifz) {
      texts = const [
        'القرآن رفيق يومك، فلا تترك نصيبك منه',
        'آيات قليلة كل يوم تبني ثباتا عظيما',
        'من لازم القرآن أصلح الله سره وعلانيته',
        'لا تحرم قلبك بركة التلاوة ولو دقائق',
        'الحفظ خطوة خطوة، والبركة في الدوام',
        'أجمل استثمار ليومك آية تحفظها بإخلاص',
        'كل ورد قرآن نور يضاف إلى طريقك',
        'اربط يومك بالمصحف يثبتك الله عند الفتن',
        'حتى القليل من القرآن كثير عند الله إذا دام',
        'آية اليوم قد تكون نجاة الغد',
        'القرآن ربيع القلوب فلا تهجره',
        'كل يوم مع القرآن زيادة في النور',
        'الحفظ يبدأ من آية ويكبر بالثبات',
        'لا تترك القرآن يشتكي منك يومًا',
        'المصحف صاحب وفيّ لمن لازمه',
        'عود نفسك وردًا لا يقطع مهما كان قليلًا',
        'القرآن يزكي النفس ويهدي الطريق',
        'لا نجاح في الحفظ بلا مداومة',
        'آية محفوظة اليوم خير من أمنيات بلا عمل',
        'التلاوة اليومية تزرع طمأنينة طويلة',
        'اربط صباحك بالقرآن يثبتك الله',
        'حافظ على وقت ثابت للورد كل يوم',
        'من أحب القرآن لازمه ولم يهجره',
        'اجعل للقرآن موعدًا لا يسقط من جدولك',
      ];
    } else if (ratio == 1.0) {
      texts = const [
        'طوبى لمن أحسن في يومه وأحسن في ختامه',
        'قد أفلح المؤمنون',
        'اللهم تقبل، يوم مليء بالخير',
        'إن الأبرار لفي نعيم',
        'ما شاء الله، ثباتك اليوم علامة صدق',
        'استمرارك نعمة عظيمة فاحمد الله عليها',
        'هذا يوم طيب، فاسأل الله القبول والدوام',
        'نسأل الله أن يبارك في هذا الثبات الجميل',
        'الخير إذا اكتمل زانه شكر الله',
        'دوام الطاعة من أجمل أبواب القرب',
        'ما أجمل يومًا اجتمعت فيه الطاعة والنية الصادقة',
        'نسأل الله أن يديم عليك هذا الثبات الجميل',
        'ثباتك اليوم علامة توفيق، فاحمد الله',
        'إذا أحسنت اليوم فاستمر يكتب لك الأجر مضاعفًا',
        'كل يوم كامل طاعة هو رصيد للآخرة',
        'حسن الختام اليومي نعمة تستحق الشكر',
        'هنيئًا لمن ختم يومه بالقرب من الله',
        'اجعل هذا الثبات عادة عمر لا حالة يوم',
        'العبد الموفق من داوم على الطاعة وإن قلّت',
      ];
    } else if (ratio >= 0.7) {
      texts = const [
        'وسارعوا إلى مغفرة من ربكم',
        'اللهم أعنا على ذكرك وشكرك وحسن عبادتك',
        'غدا فرصة أخرى بإذن الله، لا تتوقف',
        'ما بقي قليل، فأتم يومك بالقرب من الله',
        'بقيت خطوات يسيرة لتكتمل بركة يومك',
        'ثبات جميل، زد عليه يسيرا يفتح الله لك كثيرا',
        'أحسنت اليوم، ودوام الإحسان أعظم',
        'اغتنم ما بقي من اليوم بنية صادقة',
        'قريب جدًا من الاكتمال، فواصل بلا توقف',
        'ما بقي يسير، والله يفتح لك بالتيسير',
        'خطوات قليلة وتصل إلى يوم مميز',
        'ثبت ما بدأت به، فالنهاية الجميلة قريبة',
        'اجمع بقية يومك على الطاعة تنل القبول',
        'هكذا تكون الأيام الطيبة: جهد وثبات',
        'اجعل آخر ساعات اليوم أفضلها',
        'بقي القليل فلا تتراجع',
        'إذا أحسنت معظم اليوم فأتمه بإحسان',
      ];
    } else if (ratio >= 0.4) {
      texts = const [
        'لا تقنطوا من رحمة الله، إن الله يغفر الذنوب جميعا',
        'كل ساعة فرصة للعودة إلى الله',
        'الله يفرح بتوبة عبده، ابدأ الآن',
        'ابدأ بما تستطيع، فإن الله يحب العبد المقبل عليه',
        'الطريق يبدأ بخطوة، وخطوتك اليوم مباركة',
        'باب التدارك مفتوح ما دام في اليوم بقية',
        'اجعل ما بقي من اليومك أصدق مما مضى',
        'لا تنتظر المزاج، ابدأ وتأتيك المعونة',
        'حسن البداية الآن خير من تأجيل دائم',
        'كل دقيقة مقبلة فرصة لتعويض ما فات',
        'أقبل على الله كما أنت، يعينك الله',
        'لو بدأت الآن تغيّر شكل يومك كله',
        'الطاعة تُستأنف دائمًا ولا تُغلق أبوابها',
        'الأفضل لم يفت، الأفضل يبدأ الآن',
        'استعن بالله ولا تعجز عن الخطوة الأولى',
        'كل رجوع لله محسوب ومحبوب',
        'ابدأ من المتاح اليوم، والله يبارك فيه',
      ];
    } else {
      texts = const [
        'إن الله غفور رحيم، لا تيأس',
        'رحمتي وسعت كل شيء',
        'التائب من الذنب كمن لا ذنب له، عد إلى الله',
        'ابدأ الآن ولو بعمل صغير يفتح الله به قلبك',
        'أقرب الطريق إلى الله صدق الرجوع',
        'يكفيك أن تبدأ، والله يتولى إتمام الخير لك',
        'الضعف يزول مع كثرة الاستعانة بالله',
        'اليوم بداية جديدة مهما تأخرنا',
        'لا تحكم على نفسك بيوم واحد، ابدأ من جديد',
        'باب الرحمة واسع، فافتحه بالتوبة والعمل',
        'الرجوع إلى الله لا يحتاج إلا صدق نية',
        'لو كثرت العثرات فالله أرحم الراحمين',
        'ابدأ بالقليل ولا تحتقر أي طاعة',
        'التغيير الحقيقي يبدأ من قرار اليوم',
        'لا تجعل الشيطان يحرمك من بداية صادقة',
        'الموفق من عاد سريعًا كلما فتر',
        'تفاءل، فالله يقبل التوبة ويحب التوابين',
      ];
    }
    }
    final dayKey =
        record.date.year * 10000 + record.date.month * 100 + record.date.day;
    final cached = _dailyTextCache[dayKey];
    if (cached != null && texts.contains(cached)) return cached;

    final baseSeed =
        record.date.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final idx = (baseSeed + _random.nextInt(texts.length)) % texts.length;
    final selected = texts[idx];
    _dailyTextCache[dayKey] = selected;
    return selected;
  }
}
