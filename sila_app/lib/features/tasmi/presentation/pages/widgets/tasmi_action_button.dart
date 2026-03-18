
import 'package:flutter/material.dart';
import 'package:sila_app/features/tasmi/presentation/controllers/tasmi_controller.dart';

class TasmiActionButton extends StatelessWidget {
  final TasmiState state;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRestart;
  final VoidCallback onShowResults;

  const TasmiActionButton({
    super.key,
    required this.state,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
    required this.onShowResults,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildButton(context, state.status),
    );
  }

  Widget _buildButton(BuildContext context, TasmiStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case TasmiStatus.listening:
        return _buildFullWidthButton(
          context: context,
          label: 'إيقاف',
          icon: Icons.stop,
          onPressed: onStop,
          color: Colors.red,
        );
      case TasmiStatus.finished:
        return Row(
          children: [
            Expanded(
              child: _buildFullWidthButton(
                context: context,
                label: 'عرض النتائج',
                onPressed: onShowResults,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFullWidthButton(
                context: context,
                label: 'إعادة',
                icon: Icons.refresh,
                onPressed: onRestart,
                isOutlined: true,
              ),
            ),
          ],
        );
      case TasmiStatus.idle:
      case TasmiStatus.error:
      default:
        return _buildFullWidthButton(
          context: context,
          label: 'ابدأ التسميع',
          icon: Icons.play_arrow,
          onPressed: onStart,
          color: Colors.green,
        );
    }
  }

  Widget _buildFullWidthButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    Color? color,
    bool isOutlined = false,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 52,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: BorderSide(color: theme.primaryColor),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
    );
  }
}
