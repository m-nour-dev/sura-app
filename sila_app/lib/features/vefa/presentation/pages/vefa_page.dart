import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';
import 'package:sila_app/features/vefa/presentation/widgets/add_vefa_contact_sheet.dart';
import 'package:sila_app/features/vefa/presentation/widgets/vefa_card.dart';

class VefaPage extends ConsumerWidget {
  final bool isSelectionMode;

  const VefaPage({
    super.key, 
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check Isar state first
    final isarAsync = ref.watch(isarInstanceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode ? 'gift_thawab'.tr() : 'vefa_list'.tr()),
        centerTitle: true,
      ),
      floatingActionButton: isSelectionMode ? null : FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => const AddVefaContactSheet(),
          );
        },
        label: Text('add_new'.tr()),
        icon: const Icon(Icons.add),
      ),
      body: isarAsync.when(
        data: (_) {
           final vefaListState = ref.watch(vefaListControllerProvider);
           return vefaListState.when(
            data: (list) {
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.diversity_1, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'vefa_list_empty'.tr(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (isSelectionMode) ...[
                         const SizedBox(height: 24),
                         FilledButton.icon(
                           onPressed: () {
                             showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (context) => const AddVefaContactSheet(),
                            );
                           },
                           icon: const Icon(Icons.add),
                           label: Text('add_new'.tr()),
                         )
                      ]
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final person = list[index];
                  return VefaCard(
                    person: person,
                    isSelectionMode: isSelectionMode,
                    onTap: isSelectionMode 
                      ? () {
                          // Perform the Gift Logic here
                          ref.read(vefaListControllerProvider.notifier).giftThawab(person.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('thawab_gifted'.tr(args: [person.name])),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                    onDelete: () {
                       ref.read(vefaListControllerProvider.notifier).deletePerson(person.id!);
                    },
                  );
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (err, stack) => Center(child: Text('Database Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
