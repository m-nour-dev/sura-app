# تقرير تفصيلي: ميزة الحفظ (Hifz Feature) - تطبيق SILA

تم فحص الـ 18 ملفاً المطلوبة بعناية، وإليك التقرير الشامل بناءً على الكود الفعلي الموجود:

---

### قسم ١ — Onboarding
- **عدد الشاشات:** ٥ شاشات موجودة فعلاً في [hifz_onboarding_page.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart):
  1. شاشة الترحيب ([_WelcomeScreen](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart#189-245)).
  2. شاشة العمر ([_AgeScreen](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart#269-343)).
  3. شاشة وقت الحفظ والهدف ([_TimeGoalScreen](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart#344-493)).
  4. شاشة أسلوب التعلم ([_LearningStyleScreen](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart#494-558)).
  5. شاشة الخطة الذكية ([_SmartPlanScreen](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_onboarding_page.dart#559-701)).
- **البيانات المحفوظة في HifzUserProfile:**
  - `ageGroup` (العمر).
  - `dailyMinutes` (الدقائق اليومية).
  - [goal](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/domain/plan_generator.dart#51-60) (الهدف).
  - `learningStyle` (أسلوب التعلم).
  - `autoAdapt` (التكيف التلقائي).
  - `createdAt` (تاريخ الإنشاء).
- **SharedPreferences key:** موجود واسمه `hifz_onboarding_done`.
- **الـ navigation بعد الـ onboarding:** يتم التوجه إلى [HifzHomePage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/hifz_home_page.dart#26-32) عبر `MaterialPageRoute`.
- **Validation:** موجود في ميثود [finishOnboarding](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/hifz_onboarding_controller.dart#133-170) داخل الكنترولر للتأكد من اختيار كل الحقول قبل الحفظ.

---

### قسم ٢ — Hifz Home Page
- **الـ sections الموجودة فعلاً:**
  1. Header (StreakBadge + الإشعارات).
  2. Daily Plan Card (شريط التقدم لآيات اليوم).
  3. Tasmi3 Main Hero Card (رابط سريع للتسميع بالذكاء الاصطناعي).
  4. Hasanat Card (عداد الحسنات اليومي).
  5. Methods Grid (الظل التفاعلي، المراجعة الذكية، التلقي، التكرار).
  6. Moments Section (لحظاتي مع القرآن).
  7. Active Session (زر إكمال الجلسة النشطة).
- **البيانات المحملة من Isar:** الـ Profile، الـ Plan المولدة، الجلسات السابقة (Session)، اللحظات (Moments)، وعدد المراجعات المستحقة (`dueReviews`).
- **الطرق المتاحة للطرق الأربعة:**
  - **الظل التفاعلي:** موجود ومكتمل بنسبة كبيرة ([InteractiveShadowPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/methods/interactive_shadow_page.dart#14-29)).
  - **المراجعة الذكية:** ناقص (موجود كـ Navigation stub في الكنترولر ولكن لا توجد صفحة خاصة به).
  - **التلقي:** ناقص (موجود كـ Navigation stub).
  - **التكرار:** ناقص (موجود كـ Navigation stub).
- **Surah Selection:** الكود يفتح [TasmiSurahSelectionPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/tasmi/presentation/pages/tasmi_surah_selection_page.dart#25-31) عند الضغط على كرت التسميع، لكن في "الظل التفاعلي" يظهر افتراضياً سورة الفاتحة إذا لم يتم تمرير باراميترز.
- **Streak:** موجود (`StreakBadge` ومحسوب في الكنترولر).
- **Hasanat counter:** موجود ويستخدم [HasanatCalculator](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/domain/hasanat_calculator.dart#1-43) لعرض الحسنات المكتسبة اليوم.

---

### قسم ٣ — Surah/Ayah Selection
- **صفحة اختيار السور:** يتم استخدام [TasmiSurahSelectionPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/tasmi/presentation/pages/tasmi_surah_selection_page.dart#25-31).
- **هل تستخدم للحفظ؟** نعم، مربوطة بكرت التسميع الرئيسي في صفحة الحفظ.
- **طريقة اختيار الآيات:** يتم عبر `AyahRangeBottomSheet` (الذي يفتح عند اختيار سورة).
- **الفرق بين "سورة كاملة" و"نطاق آيات":** في الـ BottomSheet يحدد المستخدم البداية والنهاية.
- **السورة الافتراضية:** سورة الفاتحة (Surah 1) من الآية 1 إلى 5 تظهر كقيم افتراضية في الـ Constructor الخاص بـ [InteractiveShadowPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/methods/interactive_shadow_page.dart#14-29).
- **حفظ اختيار المستخدم:** يتم تمرير القيم للصفحة، ويتم حفظ الجلسة في [HifzSession](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/data/models/hifz_session.dart#5-18) بعد الانتهاء.

---

### قسم ٤ — الظل التفاعلي (الأهم)
- **عدد المراحل:** ٥ مراحل موجودة فعلاً.
- **الترتيب والوصف:**
  1. (الاستماع): الشيخ يقرأ والطالب يستمع.
  2. (التظليل): الشيخ يقرأ والطالب يردد معه.
  3. (٣٠٪ مخفي): إخفاء بعض الكلمات والمطالبة بإكمالها.
  4. (٦٠٪ مخفي): زيادة صعوبة الإخفاء.
  5. (كامل من الذاكرة): إخفاء الآية كاملة والتسميع غيباً.
- **حالة الاكتمال:** المراحل برمجياً موجودة، لكن الـ Voice Interaction يعتمد على `Future.delayed` (تأخير ثابت) وليس على انتهاء الصوت فعلاً أو انتهاء الكلام.
- **آلية إخفاء الكلمات:**
  - **الخوارزمية:** ميثود [selectWordsToHide](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/interactive_shadow_controller.dart#335-375).
  - **الكلمات المخفية أولاً:** تبدأ بحروف الجر والأدوات (`particles`) ثم اللواحق (`suffixes`) ثم الكلمات الرئيسية (`root`).
- **الميكروفون:**
  - `TasmiSpeechService` موصول فعلاً.
  - التحقق عبر `TajweedNormalizer.compareWord`.
- **الصوت:**
  - `audioControllerProvider` موصول.
  - رابط الحصري: `https://everyayah.com/data/Husary_128kbps/` مبرمج فعلاً.
- **ShadowWordEntry:** الحقول (`word`, `isAyahMarker`, `isHidden`, `revealedCorrectly`).
- **لحظة الصلة (HifzMoment):** تظهر كـ BottomSheet بعد كل آية في الجلسة إذا اختار المستخدم ذلك.
- **Results Screen:** موجودة وتعرض: الحسنات، الدقة، عدد الآيات، الوقت، ورسم بياني بسيط لأداء كل مرحلة.
- **SM-2 update:** يحدث في ميثود [_finishSession](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/interactive_shadow_controller.dart#517-576) داخل [InteractiveShadowController](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/interactive_shadow_controller.dart#163-592) لكل آية تم حفظها.

---

### قسم ٥ — الطرق الثلاثة الباقية
1. **المراجعة الذكية:**
   - الصفحة غير موجودة كملف مستقل.
   - الكنترولر يحتوي على [startReviewSession](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/hifz_home_controller.dart#174-177) كـ stub.
2. **التلقي:**
   - الصفحة غير موجودة.
   - الكنترولر يحتوي على [startListeningSession](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/hifz_home_controller.dart#178-181) كـ stub.
3. **التكرار:**
   - الصفحة غير موجودة.
   - الكنترولر يحتوي على [startRepetitionSession](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/hifz_home_controller.dart#182-185) كـ stub.
- **الارتباط بـ HifzVerseRecord:** الكود جاهز للربط لكنه حالياً مفعل فقط في "الظل التفاعلي".

---

### قسم ٦ — Data Layer
- **HifzVerseRecord:** (`surahIndex`, `verseNumber`, `intervalDays`, `easinessFactor`, `nextReviewDate`, `lastReviewDate`, `totalSessions`, `correctSessions`, `lastMethodUsed`).
- **HifzSession:** (`surahIndex`, `fromVerse`, `toVerse`, `method`, [date](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/tasmi/presentation/pages/tasmi_surah_selection_page.dart#59-65), `correctWords`, `wrongWords`, `durationSeconds`).
- **HifzMoment:** (`surahIndex`, `verseNumber`, `reflection`, `createdAt`).
- **HifzUserProfile:** (`ageGroup`, `dailyMinutes`, [goal](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/domain/plan_generator.dart#51-60), `learningStyle`, `autoAdapt`, `createdAt`).
- **IsarHifzRepository:** مكتمل ويحتوي على كل ميثودات الـ CRUD والـ queries المطلوبة (getProfile, saveSession, getDueReviews... إلخ).
- **التسجيل في IsarService:** **نعم**، كل الـ Schemas الأربعة مسجلة في [isar_service.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/isar_service.dart).

---

### قسم ٧ — Domain Logic
- **SpacedRepetitionEngine:**
  - خوارزمية SM-2 مكتملة ومنطقية.
  - الـ Inputs: `currentIntervalDays`, `easinessFactor`, `quality`.
  - الـ Outputs: [ReviewSchedule](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/domain/spaced_repetition_engine.dart#1-12).
  - لا توجد Unit Tests للملف حالياً.
- **PlanGenerator:**
  - يحسب بناءً على الدقائق (10/20/30/60) والهدف (سور قصيرة/جزء/كامل).
  - الـ `estimatedCompletion` يحسب بقسمة آيات الهدف على التارجت اليومي.
- **HasanatCalculator:**
  - يحسب عدد الحروف العربية ويضرب في 10.
  - ميثود [formatHasanat](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/domain/hasanat_calculator.dart#16-19) موجودة.

---

### قسم ٨ — مشاكل وثغرات

١. **الميزات الناقصة:** صفحات "المراجعة الذكية"، "التلقي"، و"التكرار" عبارة عن أزرار توجه لنفس ميثودات الـ stub في الكنترولر ولا توجد صفحات UI لها.
٢. **الـ Bugs الواضحة:** في ميثودات الصوت والميكروفون في [InteractiveShadowController](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/interactive_shadow_controller.dart#163-592) يتم استخدام `Future.delayed` بقيم ثابتة (ثانية أو ٤ ثواني) بدلاً من انتظار انتهاء تشغيل الصوت فعلياً، مما قد يسبب عدم التزامن.
٣. **TODO comments:** يوجد TODO في [isar_hifz_repository.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/data/repositories/isar_hifz_repository.dart) بخصوص الـ Cloud Sync.
٤. **صفحات Placeholder:** الزر "أكمل من حيث توقفت" في الهوم يوجه دائماً لـ [InteractiveShadowPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/pages/methods/interactive_shadow_page.dart#14-29) بافتراض أنها الطريقة الوحيدة.
٥. **Navigation:** الربط بين "اختيار السور" وبدء "الظل التفاعلي" مع الباراميترز المختارة يحتاج لضبط (حالياً الصفحة تبدأ بالديفولت لو فُتحت مباشرة).

---

### قسم ٩ — ملخص تنفيذي

✅ **ما اكتمل 100%:** الـ Data Layer، الـ Domain Logic، الـ Onboarding UI، الـ Home Page UI.
⚠️ **ما اكتمل جزئياً:** نظام "الظل التفاعلي" (يحتاج تحسين في التوقيت والتعامل مع الصوت الحقيقي)، نظام الإشعارات اليومي.
❌ **ما لم يُنفَّذ خالص:** طرق الحفظ (المراجعة الذكية، التكرار، التلقي) كصفحات مستقلة.

**نسبة اكتمال الأقسام:**
- **Onboarding:** 100%
- **Home Page:** 90%
- **Surah Selection:** 100% (باعتبارها موروثة من التسميع)
- **الظل التفاعلي:** 75%
- **المراجعة الذكية:** 10% (منطق الكنترولر فقط)
- **التلقي:** 10%
- **التكرار:** 10%
- **Data Layer:** 100%
- **Domain Logic:** 100%
