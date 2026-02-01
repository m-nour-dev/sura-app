class SunnahItem {
  final String text;
  final String source;
  final String explanation;

  const SunnahItem({
    required this.text, 
    required this.source,
    this.explanation = "",
  });
}

final List<SunnahItem> sunanMahjouraList = [
   SunnahItem(
    text: "المضمضة والاستنشاق من غرفة واحدة",
    source: "متفق عليه",
    explanation: "أن يأخذ غرفة واحدة من الماء، فيتمضمض ببعضها، ويستنشق بالباقي، ويفعل ذلك ثلاث مرات.",
  ),
  SunnahItem(
    text: "الدعاء بعد الوضوء",
    source: "رواه الترمذي",
    explanation: "يقول بعد الفراغ من الوضوء: 'أشهد أن لا إله إلا الله وحده لا شريك له، وأشهد أن محمدًا عبده ورسوله..'.",
  ),
  SunnahItem(
    text: "صلاة ركعتين بعد الوضوء",
    source: "متفق عليه",
    explanation: "يستحب لمن توضأ أن يصلي ركعتين لا يحدث فيهما نفسه بشيء من أمور الدنيا، وهي سبب لمغفرة الذنوب.",
  ),
  SunnahItem(
    text: "التنويع في دعاء الاستفتاح",
    source: "رواه البخاري ومسلم",
    explanation: "يستحب أن ينوع المصلي في دعاء الاستفتاح، فتارة يقول: 'اللهم باعد بيني وبين خطاياي..' وتارة: 'سبحانك اللهم وبحمدك..'.",
  ),
  SunnahItem(
    text: "السواك عند كل صلاة",
    source: "متفق عليه",
    explanation: "يستحب استخدام السواك عند القيام للصلاة، وهو مطهرة للفم ومرضاة للرب.",
  ),
  SunnahItem(
    text: "الصلاة إلى سترة",
    source: "متفق عليه",
    explanation: "أن يضع المصلي شيئًا أمامه (جدار، عمود، أو شيء مرتفع) ليمنع المارة من المرور بين يديه، وهذا سنة مؤكدة.",
  ),
  SunnahItem(
    text: "جلسة الاستراحة",
    source: "رواه البخاري",
    explanation: "هي جلسة خفيفة جداً يسيرة يجلسها المصلي بعد السجدة الثانية من الركعة الأولى والركعة الثالثة قبل أن يقوم.",
  ),
  SunnahItem(
    text: "الإقعاء بين السجدتين",
    source: "رواه مسلم",
    explanation: "هو أن ينصب قدميه ويجلس على عقبيه بين السجدتين، وهي سنة تفعل أحياناً.",
  ),
  SunnahItem(
    text: "سجود الشكر",
    source: "رواه أبو داود والترمذي",
    explanation: "يسجد المسلم سجدة واحدة يحمد الله فيها ويشكره عند حصول نعمة جديدة أو اندفاع نقمة.",
  ),
   SunnahItem(
    text: "نفض الفراش قبل النوم",
    source: "متفق عليه",
    explanation: "ينفض فراشه بداخل إزاره ثلاث مرات، لأنه لا يدري ما خلفه عليه في فراشه.",
  ),
  SunnahItem(
    text: "النوم على طهارة",
    source: "متفق عليه",
    explanation: "يستحب للمسلم أن يتوضأ وضوءه للصلاة قبل أن ينام.",
  ),
  SunnahItem(
    text: "قراءة سورة الملك قبل النوم",
    source: "رواه أبو داود والترمذي",
    explanation: "هي المانعة من عذاب القبر، ويستحب قراءتها كل ليلة.",
  ),
   SunnahItem(
    text: "لعق الأصابع بعد الطعام",
    source: "رواه مسلم",
    explanation: "السنة لعق الأصابع قبل مسحها أو غسلها، فإن فيها بركة لا يدري في أي طعامه هي.",
  ),
  SunnahItem(
    text: "حمد الله بعد الأكل والشرب",
    source: "رواه مسلم",
    explanation: "يقول: الحمد لله الذي أطعمنا وسقانا وجعلنا مسلمين، أو غيرها من صيغ الحمد.",
  ),
  SunnahItem(
    text: "التنفس خارج الإناء عند الشرب",
    source: "متفق عليه",
    explanation: "يشرب الماء على ثلاث دفعات، ويتنفس خارج الإناء بين كل رشفة وأخرى.",
  ),
  SunnahItem(
    text: "مبادرة من لقيت بالسلام",
    source: "رواه أبو داود",
    explanation: "أن يكون هو البادئ بالسلام عند اللقاء، وخيرهما الذي يبدأ بالسلام.",
  ),
  SunnahItem(
    text: "إفشاء السلام",
    source: "متفق عليه",
    explanation: "نشر السلام وإلقاؤه على من عرفت ومن لم تعرف من المسلمين.",
  ),
  SunnahItem(
    text: "التبسم في وجه أخيك",
    source: "رواه الترمذي",
    explanation: "إظهار البشر والابتسامة عند لقاء المسلم، فهو عمل صالح يؤجر عليه.",
  ),
  SunnahItem(
    text: "المصافحة عند اللقاء",
    source: "رواه أبو داود والترمذي",
    explanation: "تصافح المسلمين يوجب تساقط الذنوب كما تتساقط أوراق الشجر.",
  ),
   SunnahItem(
    text: "زيارة المقابر",
    source: "رواه مسلم",
    explanation: "تسن زيارة المقابر للرجال لتذكر الآخرة والدعاء للموتى.",
  ),
  SunnahItem(
    text: "صلاة الضحى",
    source: "رواه مسلم",
    explanation: "أقلها ركعتان، ووقتها من ارتفاع الشمس قيد رمح إلى قبيل الزوال، وهي صلاة الأوابين.",
  ),
   SunnahItem(
    text: "صلاة الوتر",
    source: "متفق عليه",
    explanation: "أن يختم صلاته بالليل بركعة واحدة، وهي سنة مؤكدة.",
  ),
  SunnahItem(
    text: "المشي حافياً أحياناً",
    source: "رواه أحمد وأبو داود",
    explanation: "يستحب المشي بدون نعلين أحياناً تواضعاً لله وتدريباً للنفس، في أماكن مناسبة.",
  ),
  SunnahItem(
    text: "كتابة الوصية",
    source: "متفق عليه",
    explanation: "من كان له شيء يريد أن يوصي فيه، فلا يبيت ليلتين إلا ووصيته مكتوبة عند رأسه.",
  ),
  SunnahItem(
    text: "الدعاء عند نزول المطر",
    source: "رواه البخاري",
    explanation: "يستحب كشف جزء من البدن ليصيبه المطر والقول: اللهم صيباً نافعاً.",
  ),
  SunnahItem(
    text: "كف الصبيان عند الغروب",
    source: "متفق عليه",
    explanation: "منع الأطفال من الخروج وقت غروب الشمس (بداية انتشار الشياطين) ثم تركهم بعد ذهاب ساعة من الليل.",
  ),
];

SunnahItem getTodaySunnah() {
  final now = DateTime.now();
  // Using day of year to rotate through the list
  final dayOfYear = int.parse("${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");
  
  // Simple hashing or index calculation
  final index = dayOfYear % sunanMahjouraList.length;
  return sunanMahjouraList[index];
}
