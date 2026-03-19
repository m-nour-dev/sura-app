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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: _buildButton(context, state.status),
    );
  }

  Widget _buildButton(BuildContext context, TasmiStatus status) {
    final primaryColor = const Color(0xFF064E3B);
    final accentColor = const Color(0xFFD97706);
    
    switch (status) {
      case TasmiStatus.listening:
        return _buildFullWidthButton(
          context: context,
          label: 'إيقاف التسميع',
          icon: Icons.stop_rounded,
          onPressed: onStop,
          color: Colors.red[700],
        );
      case TasmiStatus.finished:
        return Row(
          children: [
            Expanded(
              child: _buildFullWidthButton(
                context: context,
                label: 'عرض النتائج',
                icon: Icons.analytics_rounded,
                onPressed: onShowResults,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFullWidthButton(
                context: context,
                label: 'إعادة',
                icon: Icons.refresh_rounded,
                onPressed: onRestart,
                isOutlined: true,
                color: primaryColor,
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
          icon: Icons.mic_rounded,
          onPressed: onStart,
          color: primaryColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 56,
      decoration: isOutlined ? null : BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (color ?? Colors.transparent).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: color, size: 24),
              label: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: BorderSide(color: color ?? Colors.transparent, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, color: Colors.white, size: 24),
              label: Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
    );
  }
}
