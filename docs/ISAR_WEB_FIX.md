# حل مشكلة Isar مع Flutter Web

## المشكلة

عند تشغيل Flutter Web، تظهر الأخطاء التالية:
```
lib/features/wird/data/models/wird_settings.g.dart:18:7: Error: The integer literal 5980852363758198336 can't be represented exactly in JavaScript.
lib/features/vefa/data/models/vefa_person_model.g.dart:18:8: Error: The integer literal -6013139107813053430 can't be represented exactly in JavaScript.
```

**السبب:** Isar يولد schema IDs كبيرة جداً (64-bit integers) لا يمكن تمثيلها بدقة في JavaScript.

## الحلول المتاحة

### ✅ الحل 1: تشغيل على Android/iOS بدلاً من Web 
**الأسهل والأفضل** - Isar مصمم للعمل على Mobile platforms وليس Web.

```bash
# تشغيل على Android
flutter run -d <device-id>

# أو Windows
flutter run -d windows
```

###ممكن الحل 2: إزالة Isar من Web Build
تعديل `pubspec.yaml` لاستخدام Isar فقط على platforms معينة أو استخدام `kIsWeb` للتحقق.

### ⚠️ الحل 3: استبدال Isar بـ shared_preferences أو Hive للويب
استخدام database مختلفة للويب تدعم JavaScript بشكل أفضل.

### ❌ الحل المؤقت: تعديل الملفات المولدة يدوياً
**لا يُنصح به** - سيتم الكتابة فوقها في كل مرة تقوم بتشغيل `build_runner`.

## التوصية

**نفذ التطبيق على Android/Windows** لتجربة ميزة قراءة القرآن الصوتية! 🎧

الصوت يعمل بشكل ممتاز على:
- ✅ Android  
- ✅ iOS
- ✅ Windows
- ✅ MacOS  
- ⚠️ Web (قد تواجه مشاكل CORS)

```bash
# قم بتشغيل هذا الأمر:
flutter run -d <اختر Android أو Windows>
```
