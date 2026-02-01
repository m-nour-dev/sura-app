import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sila_app/features/sunan_mahjoura/data/sunan_data.dart';

class DailyContentCard extends StatelessWidget {
  const DailyContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get daily sunnah
    // Note: In a real app with Riverpod, we might want to watch a provider, 
    // but for this simple daily logic, calling the function directly is fine as it's efficient.
    final sunnah = getTodaySunnah();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'sunan_mahjoura'.tr(), // Make sure to add this key to translations or use fallback
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sunnah.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Source & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                 child: Text(
                  "المصدر: ${sunnah.source}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                             ),
               ),
             if (sunnah.explanation.isNotEmpty)
               IconButton(
                 onPressed: () {
                   showDialog(
                     context: context,
                     builder: (context) => AlertDialog(
                       title: Text("شرح السنة"),
                       content: SingleChildScrollView(
                         child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Text(sunnah.text, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text(sunnah.explanation),
                              const SizedBox(height: 20),
                              Text("المصدر: ${sunnah.source}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                           ],
                         ),
                       ),
                       actions: [
                         TextButton(
                           onPressed: () => Navigator.pop(context),
                           child: const Text("إغلاق"),
                         )
                       ],
                     ),
                   );
                 },
                 icon: const Icon(Icons.info_outline, size: 20),
                 tooltip: "عرض الشرح",
               )
            ],
          ),
        ],
      ),
    );
  }
}
