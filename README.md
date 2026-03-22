# Sila | صلة

منصة إسلامية رقمية مبنية بـ Flutter لرفع جودة العبادة اليومية عبر تجربة حديثة، هادئة، وعملية.

`Sila` تركّز على أربع ركائز: القرآن، الصلاة، الأذكار، والحفظ/التسميع الذكي، مع بنية Offline-first ومتابعة يومية للمستخدم.

## Product Overview

- **Mission**: تحويل المداومة على العبادة من "مهمة متقطعة" إلى "رحلة يومية" واضحة وقابلة للقياس.
- **Audience**: المستخدم العربي (مع دعم التركية في أجزاء من التطبيق) الراغب في تجربة إسلامية متكاملة داخل تطبيق واحد.
- **Core Value**: تجربة روحانية + هندسة منتج عملية (تذكير، قياس، وتحسين تدريجي).

## Core Capabilities

### 1) Quran Experience
- قارئ قرآن بتصميم حديث ودعم تشغيل التلاوة لكل آية.
- إدارة القارئ (Reciter) مع تحميل/تخزين محلي وإدارة كاش الصوت.
- إعدادات قراءة مخصصة (الخط، الحجم، واجهة القراءة).

### 2) Smart Tasmi (التسميع الذكي)
- تقييم فوري للتلاوة مع تطبيع النص العربي والمقارنة الذكية.
- معالجة أخطاء STT ودمج أفضل بين الاستماع والتفاعل داخل الجلسة.
- شاشة نتائج واضحة تساعد المستخدم على معرفة نقاط القوة والتحسين.

### 3) Hifz (الحفظ)
- مسار Onboarding للحفظ وتوليد خطة يومية مبدئية.
- **Interactive Shadow** متعدد المراحل (استماع، ترديد، كتابة/اختبار).
- مقارنة الكلمات المخفية + تتبع الأداء + تسجيل لحظات إيمانية (Moments).
- إعدادات حفظ قابلة للتخصيص (الصرامة، عدد المحاولات، التلميحات، إلخ).

### 4) Prayer & Adhan
- جدولة تنبيهات الصلوات مع إدارة إعدادات الأذان لكل صلاة.
- اختبار صوت الأذان داخل التطبيق.
- تكامل مع نظام الإشعارات الذكية اليومي.

### 5) Azkar, Wird, Ibadah Tracking
- أذكار وورد يومي بتجربة متابعة مرئية.
- إشعارات سياقية وخطط تذكير يومية.
- تتبع نشاطات التعبد اليومية لرفع الاستمرارية.

## Architecture & Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (Codegen)
- **Persistence**: Isar (Local-first)
- **Audio**: just_audio + audioplayers (بحسب الحالة)
- **Notifications**: flutter_local_notifications
- **Speech**: speech_to_text
- **Localization**: easy_localization

## Repository Structure

```text
.
|- sila_app/
|  |- lib/
|  |  |- core/                # Services, shared widgets, providers
|  |  |- features/            # Feature-first modules (quran, hifz, tasmi...)
|  |- assets/                 # Fonts, audio, images
|  |- scripts/                # Automation scripts
|- README.md                  # Project overview (this file)
```

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code

### Local Run

```bash
git clone https://github.com/7amed3li/Sila.git
cd Sila/sila_app
flutter pub get
flutter run
```

### Quality Checks

```bash
cd sila_app
flutter analyze
flutter test
```

## Delivery & CI

- CI workflows موجودة لفحص الصياغة والتحليل والاختبارات.
- يوجد pre-push gate محلي ضمن السكربتات لضمان جودة الحد الأدنى قبل أي push.
- يدعم المشروع مسار إصدار مبني على tags للتحديثات.

## Roadmap (High-Level)

- استكمال طرق الحفظ المتقدمة (Smart Review / Repetition / Listening) بصفحات مخصصة.
- توسيع التخصيص في رحلات الحفظ والتسميع.
- تحسينات إضافية على الأداء وإدارة الوسائط على الأجهزة محدودة الموارد.

## Contribution

- افتح Issue واضح مع خطوات إعادة إنتاج للمشكلات.
- استخدم فروع Feature قصيرة ووصف PR عملي ومباشر.
- مرّر `flutter analyze` و `flutter test` قبل طلب المراجعة.

## Dedication | إهداء وصدقة جارية

هذا العمل وقف لله تعالى وصدقة جارية عن أرواح:

- **صديقي وأخي/ محمود أحمد وهبة** (رحمه الله)
- **صديقي وأخي الدكتور/ محمود أحمد فرحات** (رحمه الله)
- **صديقي وأخي/ عبدالرحمن جمال** (رحمه الله)
- **خالي، وجدي، وجدتي** (غفر الله لهم)
- **وجميع موتانا المنسيين الذين انقطع عملهم ولا يجدون من يدعو لهم**

اللهم اجعل هذا العمل نورا وبشرى لهم في قبورهم، وثقّل به موازينهم، واجمعنا بهم في مستقر رحمتك.

