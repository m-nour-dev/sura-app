import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/wird/presentation/riverpod/wird_controller.dart';

class WirdHistoryPage extends ConsumerWidget {
  const WirdHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wirdStateAsync = ref.watch(wirdControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'الأوراد السابقة',
          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
      ),
      body: SafeArea(
        child: wirdStateAsync.when(
          data: (wirdState) {
            if (wirdState.history.isEmpty) {
              return const Center(
                child: Text('لا توجد أوراد سابقة مسجلة بعد', style: TextStyle(color: Colors.grey)),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: wirdState.history.length,
              itemBuilder: (context, index) {
                final historyItem = wirdState.history[index];
                final formattedDate = DateFormat('yyyy/MM/dd').format(historyItem.date);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'من صفحة ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${historyItem.startPage} ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'إلى ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${historyItem.endPage}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
