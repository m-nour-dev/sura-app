
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/tasmi/presentation/pages/tasmi_page.dart';

class AyahRangeBottomSheet extends StatefulWidget {
  final int surahNumber;
  const AyahRangeBottomSheet({super.key, required this.surahNumber});

  @override
  State<AyahRangeBottomSheet> createState() => _AyahRangeBottomSheetState();
}

class _AyahRangeBottomSheetState extends State<AyahRangeBottomSheet> {
  bool _isCustomRangeExpanded = false;
  double _fromAyah = 1.0;
  late double _toAyah;
  late int _maxAyah;

  @override
  void initState() {
    super.initState();
    _maxAyah = quran.getVerseCount(widget.surahNumber);
    _toAyah = _maxAyah.toDouble();
  }

  void _navigateToTasmi(int from, int to) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TasmiPage(
          surahNumber: widget.surahNumber,
          fromAya: from,
          toAya: to,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'سورة ${quran.getSurahName(widget.surahNumber)}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '${quran.getVerseCount(widget.surahNumber)} آية',
            style: TextStyle(color: theme.textTheme.bodySmall?.color),
          ),
          const Divider(height: 24),

          // Option 1: Full Surah
          _buildOptionCard(
            context: context,
            icon: Icons.menu_book,
            title: 'السورة كاملة',
            subtitle: 'من الآية ١ إلى نهاية السورة',
            onTap: () => _navigateToTasmi(1, _maxAyah),
          ),
          const SizedBox(height: 12),

          // Option 2: Custom Range
          _buildOptionCard(
            context: context,
            icon: Icons.cut,
            title: 'نطاق مخصص',
            subtitle: 'اختر من أي آية إلى أي آية',
            onTap: () {
              setState(() {
                _isCustomRangeExpanded = !_isCustomRangeExpanded;
              });
            },
          ),

          // Custom Range Sliders (Animated)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isCustomRangeExpanded ? 200 : 0,
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text('من الآية: ${_fromAyah.round()}'),
                  Slider(
                    value: _fromAyah,
                    min: 1,
                    max: _maxAyah.toDouble(),
                    divisions: _maxAyah > 1 ? _maxAyah - 1 : 1,
                    label: _fromAyah.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fromAyah = value;
                        if (_toAyah < _fromAyah) {
                          _toAyah = _fromAyah;
                        }
                      });
                    },
                  ),
                  Text('إلى الآية: ${_toAyah.round()}'),
                  Slider(
                    value: _toAyah,
                    min: 1,
                    max: _maxAyah.toDouble(),
                    divisions: _maxAyah > 1 ? _maxAyah - 1 : 1,
                    label: _toAyah.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        if (value >= _fromAyah) {
                          _toAyah = value;
                        }
                      });
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToTasmi(_fromAyah.round(), _toAyah.round()),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('ابدأ التسميع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: theme.primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
