import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';
import 'package:sila_app/features/wird/presentation/pages/wird_reader_page.dart';
import 'package:sila_app/features/wird/presentation/riverpod/wird_controller.dart';

class WirdCard extends ConsumerWidget {
  const WirdCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wirdStateAsync = ref.watch(wirdControllerProvider);

    return wirdStateAsync.when(
      data: (state) {
        final startPage = state.currentPage;
        final endPage = state.targetPage;
        final isDone = state.isCompletedToday;
        
        // Status Logic
        Color statusColor = Colors.grey;
        String statusText = 'على الجدول';
        if (state.daysDifference > 0) {
          statusColor = Colors.green;
          statusText = 'متقدم بـ ${state.daysDifference} يوم';
        } else if (state.daysDifference < 0) {
          statusColor = Colors.orange;
          statusText = 'متأخر بـ ${state.daysDifference.abs()} يوم';
        }

        final startSurah = quran.getSurahNameArabic(quran.getPageData(startPage)[0]['surah']); 
        
        return Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // TODO: Add pattern_bg.png image when available
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/pattern_bg.png'),
              //   fit: BoxFit.cover,
              //   opacity: 0.05,
              // ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDone 
                  ? [const Color(0xFF1B5E20), const Color(0xFF43A047)]
                  : [Colors.white, const Color(0xFFF5F5F5)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDone ? Colors.white24 : Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: isDone ? Colors.white : Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'daily_wird'.tr(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDone ? Colors.white : Colors.black87,
                                ),
                              ),
                              if (!isDone)
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Settings Button
                      IconButton(
                        icon: Icon(Icons.tune, color: isDone ? Colors.white70 : Colors.grey),
                        onPressed: () => _showSettingsDialog(context, ref, state.pagesPerDay),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Main Content
                  if (isDone)
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         color: Colors.white10,
                         borderRadius: BorderRadius.circular(16),
                       ),
                       child: Column(
                         children: [
                           const Icon(Icons.check_circle_outline, color: Colors.white, size: 48),
                           const SizedBox(height: 8),
                           Text(
                            'great_job_wird_done'.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          // Read More Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                 // Open Reader starting from current page
                                 // We don't need a specific target, just let them read
                                 await Navigator.push(
                                   context, 
                                   MaterialPageRoute(
                                     builder: (_) => WirdReaderPage(
                                       startPage: endPage, // Start from where they left off
                                       endPage: endPage + state.pagesPerDay, // Suggest next chunk
                                     )
                                   )
                                 );
                              },
                              icon: const Icon(Icons.menu_book),
                              label: const Text('قراءة المزيد (زيادة الخير)'),
                            ),
                          )
                         ],
                       ),
                     )
                  else ...[
                    // Pages Display (Creative Layout)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCreativePageInfo(context, 'من صفحة', startPage, startSurah, true),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 16),
                        _buildCreativePageInfo(context, 'إلى صفحة', endPage, '', false),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: state.khatmaProgress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نسبة الختمة: ${(state.khatmaProgress * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.end,
                    ),

                    const SizedBox(height: 16),
                    
                    // Action Button
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37), // Gold
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () async {
                           final shouldComplete = await Navigator.push<bool>(
                             context, 
                             MaterialPageRoute(
                               builder: (_) => WirdReaderPage(
                                 startPage: startPage,
                                 endPage: endPage,
                               )
                             )
                           );
                           
                           if (shouldComplete == true && context.mounted) {
                             _showCompletionDialog(context, ref);
                           }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('start_reading'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(child: Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))),
      error: (e, s) => Card(child: Padding(padding: EdgeInsets.all(16), child: Text("Error: $e"))),
    );
  }

  Widget _buildCreativePageInfo(BuildContext context, String label, int pageNum, String subLabel, bool isStart) {
    return Column(
      crossAxisAlignment: isStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$pageNum',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
            ),
            const SizedBox(width: 4),
            Text('صفحة', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
          ],
        ),
        if (subLabel.isNotEmpty)
          Container(
             margin: const EdgeInsets.only(top: 4),
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
             decoration: BoxDecoration(
               color: Colors.brown[50],
               borderRadius: BorderRadius.circular(4),
             ),
             child: Text(subLabel, style: TextStyle(color: Colors.brown[800], fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref, int currentPageCount) {
    int selectedPages = currentPageCount;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('إعدادات الورد اليومي'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('كم صفحة تريد أن تقرأ يومياً؟'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (selectedPages > 1) setState(() => selectedPages--);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$selectedPages',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => selectedPages++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'سيتم ختم القرآن في ${(604 / selectedPages).round()} يوم تقريباً',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(wirdControllerProvider.notifier).updatePagesPerDay(selectedPages);
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('wird_completed_title'.tr()),
        content: Text('wird_completed_body'.tr()),
        actions: [
          TextButton(
            onPressed: () {
               ref.read(wirdControllerProvider.notifier).completeWird();
               Navigator.pop(context);
            },
            child: Text('done_only'.tr()),
          ),
          FilledButton.icon(
             icon: const Icon(Icons.diversity_1),
             label: Text('gift_thawab'.tr()),
             onPressed: () {
               ref.read(wirdControllerProvider.notifier).completeWird();
               Navigator.pop(context);
               // Navigate to Vefa Selection
               Navigator.push(context, MaterialPageRoute(builder: (_) => const VefaPage(isSelectionMode: true)));
             },
          )
        ],
      ),
    );
  }
}
