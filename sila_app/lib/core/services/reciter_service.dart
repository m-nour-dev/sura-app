class ReciterModel {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final String folderName;
  final String baseUrl;
  final String quality;
  final String style;
  final bool isRecommendedForHifz;

  const ReciterModel({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.folderName,
    required this.baseUrl,
    required this.quality,
    required this.style,
    required this.isRecommendedForHifz,
  });

  String buildAyahUrl(int surahNumber, int ayahNumber) {
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final ayahStr = ayahNumber.toString().padLeft(3, '0');
    return '$baseUrl$folderName/$surahStr$ayahStr.mp3';
  }
}

class ReciterService {
  static const List<ReciterModel> availableReciters = [
    ReciterModel(
      id: 'husary',
      nameArabic: 'الشيخ محمود خليل الحصري',
      nameEnglish: 'Mahmoud Khaleel Al-Husary',
      folderName: 'Husary_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مرتل',
      isRecommendedForHifz: true,
    ),
    ReciterModel(
      id: 'husary_mujawwad',
      nameArabic: 'الشيخ الحصري - مجود',
      nameEnglish: 'Husary Mujawwad',
      folderName: 'Husary_128kbps_Mujawwad',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مجود',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'minshawi',
      nameArabic: 'الشيخ محمد صديق المنشاوي',
      nameEnglish: 'Muhammad Siddiq Al-Minshawi',
      folderName: 'Menshawi_16kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '16kbps',
      style: 'مرتل',
      isRecommendedForHifz: true,
    ),
    ReciterModel(
      id: 'minshawi_mujawwad',
      nameArabic: 'الشيخ المنشاوي - مجود',
      nameEnglish: 'Minshawi Mujawwad',
      folderName: 'Menshawi_Mujawwad_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مجود',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'abdul_basit_murattal',
      nameArabic: 'الشيخ عبد الباسط عبد الصمد - مرتل',
      nameEnglish: 'Abdul Basit Murattal',
      folderName: 'Abdul_Basit_Murattal_192kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '192kbps',
      style: 'مرتل',
      isRecommendedForHifz: true,
    ),
    ReciterModel(
      id: 'abdul_basit_mujawwad',
      nameArabic: 'الشيخ عبد الباسط عبد الصمد - مجود',
      nameEnglish: 'Abdul Basit Mujawwad',
      folderName: 'Abdul_Basit_Mujawwad_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مجود',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'sudais',
      nameArabic: 'الشيخ عبد الرحمن السديس',
      nameEnglish: 'Abdurrahmaan As-Sudais',
      folderName: 'Abdurrahmaan_As-Sudais_192kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '192kbps',
      style: 'مرتل',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'shuraim',
      nameArabic: 'الشيخ سعود الشريم',
      nameEnglish: 'Saud Ash-Shuraym',
      folderName: 'Saud_ash-Shuraym_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مرتل',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'alafasy',
      nameArabic: 'الشيخ مشاري راشد العفاسي',
      nameEnglish: 'Mishari Rashid Al-Afasy',
      folderName: 'Alafasy_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مرتل',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'maher',
      nameArabic: 'الشيخ ماهر المعيقلي',
      nameEnglish: 'Maher Al-Muaiqly',
      folderName: 'MaherAlMuaiqly128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مرتل',
      isRecommendedForHifz: false,
    ),
    ReciterModel(
      id: 'tablawi',
      nameArabic: 'الشيخ محمد الطبلاوي',
      nameEnglish: 'Mohammad Al-Tablawi',
      folderName: 'Mohammad_al_Tablawi_128kbps',
      baseUrl: 'https://everyayah.com/data/',
      quality: '128kbps',
      style: 'مجود',
      isRecommendedForHifz: false,
    ),
  ];

  static const String defaultReciterId = 'husary';

  static ReciterModel getById(String id) {
    return availableReciters.firstWhere(
      (reciter) => reciter.id == id,
      orElse: () => availableReciters.firstWhere(
        (reciter) => reciter.id == defaultReciterId,
        orElse: () => availableReciters.first,
      ),
    );
  }

  static List<ReciterModel> get hifzRecommended {
    return availableReciters.where((r) => r.isRecommendedForHifz).toList();
  }
}
