class AzkarItem {
  final String text;
  final int count;
  final String fadilah;

  AzkarItem({required this.text, required this.count, required this.fadilah});

  factory AzkarItem.fromJson(Map<String, dynamic> json) {
    return AzkarItem(
      text: json['text'] as String,
      count: json['count'] as int? ?? 1,
      fadilah: json['fadilah'] as String? ?? "",
    );
  }
}
