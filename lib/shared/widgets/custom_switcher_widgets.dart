import 'package:flutter/material.dart';

class CustomSwitcherWidgets extends StatelessWidget {
  final Widget firstWidget;
  final Widget secondWidget;
  final CustomAnimation switcherAnimation;
  final CustomSwitcherState switcherState;

  const CustomSwitcherWidgets({
    super.key,
    required this.firstWidget,
    required this.secondWidget,
    required this.switcherState,
    required this.switcherAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation);

        switch (switcherAnimation) {
          case CustomAnimation.slide:
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          case CustomAnimation.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
        }
      },
      child: switcherState == CustomSwitcherState.showFirst ? firstWidget : secondWidget,
    );
  }
}

enum CustomAnimation {
  fade,
  slide,
}

enum CustomSwitcherState {
  showFirst,
  showSecond,
}
