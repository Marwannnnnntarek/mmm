import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = SlaGradients.button,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final bool isLoading;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || isLoading;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: disabled ? null : gradient,
            color: disabled ? SlaColors.disabledBg : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                      color: SlaColors.primaryPurple.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: disabled ? null : onPressed,
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Padding(
              padding: padding,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : DefaultTextStyle.merge(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        child: IconTheme.merge(
                          data: const IconThemeData(color: Colors.white),
                          child: child,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
