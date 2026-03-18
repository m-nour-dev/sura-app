
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasmiCorrectionBubble extends StatefulWidget {
  final String? word;

  const TasmiCorrectionBubble({super.key, this.word});

  @override
  State<TasmiCorrectionBubble> createState() => _TasmiCorrectionBubbleState();
}

class _TasmiCorrectionBubbleState extends State<TasmiCorrectionBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(covariant TasmiCorrectionBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.word != null && oldWidget.word == null) {
      _controller.forward();
    } else if (widget.word == null && oldWidget.word != null) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // --- PLACEHOLDER: Replace with your actual settings provider ---
    const fontFamily = 'Amiri';
    const fontSize = 28.0;
    // --- END PLACEHOLDER ---

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, color: theme.colorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'الصواب:',
                style: TextStyle(fontSize: 16, color: theme.textTheme.bodySmall?.color),
              ),
              const SizedBox(width: 16),
              if (widget.word != null)
                Text(
                  widget.word!,
                  style: GoogleFonts.getFont(
                    fontFamily,
                    fontSize: fontSize,
                    color: theme.primaryColor, // Green
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
