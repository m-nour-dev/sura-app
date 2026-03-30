import 'package:flutter/material.dart';

class TasmiWordChip extends StatelessWidget {
  const TasmiWordChip({super.key, required this.label, this.isError = false});
  final String label;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label),
      backgroundColor: isError
          ? theme.colorScheme.errorContainer
          : theme.chipTheme.backgroundColor,
      labelStyle: TextStyle(
        color: isError
            ? theme.colorScheme.onErrorContainer
            : theme.chipTheme.labelStyle?.color,
      ),
    );
  }
}
