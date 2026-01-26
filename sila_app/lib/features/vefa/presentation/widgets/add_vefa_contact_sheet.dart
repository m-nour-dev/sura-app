import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/vefa/domain/entities/vefa_person.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';

class AddVefaContactSheet extends ConsumerStatefulWidget {
  const AddVefaContactSheet({super.key});

  @override
  ConsumerState<AddVefaContactSheet> createState() => _AddVefaContactSheetState();
}

class _AddVefaContactSheetState extends ConsumerState<AddVefaContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final person = VefaPerson(
        name: _nameController.text,
        relation: _relationController.text.isEmpty ? null : _relationController.text,
        deathDate: DateTime.now(), // Placeholder for now, can add DatePicker later
      );
      
      ref.read(vefaListControllerProvider.notifier).addPerson(person);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'add_loved_one'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              decoration: InputDecoration(
                labelText: 'name'.tr(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) => 
                value == null || value.isEmpty ? 'field_required'.tr() : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _relationController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              decoration: InputDecoration(
                labelText: 'relation'.tr(),
                hintText: 'optional'.tr(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('save'.tr()),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
