String normalizeLanguageCode(String? locale, {String fallback = 'ar'}) {
  if (locale == null || locale.trim().isEmpty) return fallback;
  final normalized = locale.trim().replaceAll('_', '-').toLowerCase();
  return normalized.split('-').first;
}
