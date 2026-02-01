import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sila_app/features/sunan_mahjoura/data/sunan_data.dart';

class SunanListPage extends StatelessWidget {
  const SunanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sunan_mahjoura'.tr()),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sunanMahjouraList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final sunnah = sunanMahjouraList[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sunnah.text,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المصدر: ${sunnah.source}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                       if (sunnah.explanation.isNotEmpty)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                             showDialog(
                               context: context,
                               builder: (context) => AlertDialog(
                                 title: Text("شرح السنة"),
                                 content: Text(sunnah.explanation),
                                 actions: [
                                   TextButton(onPressed: () => Navigator.pop(context), child: Text("إغلاق"))
                                 ],
                               ),
                             );
                          },
                          icon: Icon(Icons.info_outline, size: 20, color: Theme.of(context).primaryColor),
                        )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
