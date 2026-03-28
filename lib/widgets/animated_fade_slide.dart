import 'package:flutter/material.dart';

/// A widget that animates its child with a fade + slide effect.
/// Use [direction] to control slide origin. Provide [delay] for stagger.
class AnimatedFadeSlide extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Offset beginOffset;

  const AnimatedFadeSlide({
    super.key,
    required this.child,
    required this.animation,
    this.beginOffset = const Offset(0, 0.08),
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }
}
