# sila_app

تطبيق Flutter لمشروع **صلة** (Sila): تطبيق إسلامي متكامل يجمع بين القرآن، الأذكار، المواقيت، الورد، وميزة التسميع الذكي.

## المزايا الأحدث

- تحسينات كبيرة على ميزة التسميع:
  - استقرار أعلى لـ STT وإعادة تشغيل تلقائية بعد الانقطاع.
  - منع تضارب STT/TTS أثناء نطق التصحيح.
  - مؤشر حالة الاستماع وتجربة أخطاء أوضح.
  - تقرير جلسة مفصل مع نسبة دقة وتصنيف للأخطاء.
- نظام تفضيلات شخصية للتسميع:
  - سلوك التطبيق عند الخطأ.
  - عدد المحاولات قبل احتساب الخطأ.
  - تشغيل/إيقاف صوت التصحيح.
  - مستوى الصرامة في التقييم.

## التشغيل محلياً

```bash
flutter pub get
flutter run
```

## الفحص والاختبارات

```bash
flutter analyze
flutter test
```

## ملاحظة

قد تظهر نتائج `analyze` على شكل ملاحظات lint/deprecations في بعض الملفات. هذه لا تمنع تشغيل التطبيق لكنها تحتاج تحسين تدريجي.

## GitHub Actions (تحديثات أوتوماتيك)

تمت إضافة workflowين:

- `.github/workflows/ci.yml`
  - يعمل على `push` و `pull_request`
  - يشغل: `flutter pub get` + `dart format` + `flutter analyze` + `flutter test` (لو مجلد `test` موجود)

- `.github/workflows/release-update.yml`
  - يعمل تلقائيا عند عمل tag مثل `v2.0.0`
  - يبني `APK` release
  - ينشئ GitHub Release ويرفع ملف APK
  - يحدث Firebase Remote Config تلقائيا (`latest_version`, `apk_url`, `force_update`, `update_title`, `update_message`, `update_release_notes`)
  - يرسل notification للتحديث (اختياري) عبر Cloud Function

### Secrets المطلوبة في GitHub

من: `Settings > Secrets and variables > Actions > New repository secret`

- `FIREBASE_PROJECT_ID`
- `FIREBASE_SERVICE_ACCOUNT_JSON`
  - JSON كامل لحساب Service Account بصلاحية Remote Config Admin
- `UPDATE_FUNCTION_URL` (اختياري)
- `UPDATE_FUNCTION_TOKEN` (اختياري لو endpoint محمي)

### طريقة إصدار تحديث تلقائي

```bash
git tag v2.0.0
git push origin v2.0.0
```

بعدها GitHub Actions سيتولى كل شيء تلقائيا.
