import 'package:flutter/material.dart';

class FormaPageShell extends StatelessWidget {
  const FormaPageShell({
    super.key,
    required this.child,
    this.appBar,
    this.maxWidth = 1120,
    this.showBackdrop = true,
    this.floatingActionButton,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final double maxWidth;
  final bool showBackdrop;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          if (showBackdrop) const Positioned.fill(child: _Backdrop()),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _BackdropPainter(
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          accentColor: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
          primaryColor: Theme.of(context).colorScheme.primary.withOpacity(0.06),
        ),
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({
    required this.baseColor,
    required this.accentColor,
    required this.primaryColor,
  });

  final Color baseColor;
  final Color accentColor;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = baseColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final accentPaint = Paint()..color = accentColor;
    final primaryPaint = Paint()..color = primaryColor;

    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.12), 180, accentPaint);
    canvas.drawCircle(Offset(size.width * 0.08, size.height * 0.22), 140, primaryPaint);
    canvas.drawCircle(Offset(size.width * 0.74, size.height * 0.78), 220, primaryPaint);
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) {
    return baseColor != oldDelegate.baseColor ||
        accentColor != oldDelegate.accentColor ||
        primaryColor != oldDelegate.primaryColor;
  }
}
