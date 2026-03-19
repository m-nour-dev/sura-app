import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastReadCard extends StatelessWidget {
  const LastReadCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? Colors.white12 : const Color(0xFFE2E8F0);
    final txtP = isDark ? Colors.white : const Color(0xFF0F172A);
    final txtS = isDark ? Colors.white60 : const Color(0xFF64748B);
    const primaryColor = Color(0xFF064E3B);

    return GestureDetector(
      onTap: () {
        // Mock navigation or real logic
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu_book_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أكمل قراءتك',
                    style: GoogleFonts.getFont('Cairo', fontSize: 12, color: txtS),
                  ),
                  Text(
                    'سورة البقرة', // Mock data
                    style: GoogleFonts.getFont('Cairo',
                        fontSize: 16, fontWeight: FontWeight.w700, color: txtP),
                  ),
                  Text(
                    'صفحة 2', // Mock data
                    style: GoogleFonts.getFont('Cairo', fontSize: 12, color: txtS),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: txtS, size: 14),
          ],
        ),
      ),
    );
  }
}
