import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Renders the SLA logo image.
///
/// [height] controls the display height; width scales proportionally.
/// [cardMode] wraps the logo in a white elevated card — use on dark backgrounds.
class SlaLogo extends StatelessWidget {
  const SlaLogo({
    super.key,
    this.height = 80,
    this.cardMode = false,
  });

  final double height;

  /// When true, wraps the image in a white rounded card with shadow.
  /// Use on dark/gradient backgrounds so the logo stands out cleanly.
  final bool cardMode;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/sla_logo.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _FallbackLogo(height: height),
    );

    if (!cardMode) return image;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: image,
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    final size = height * 1.2;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: SlaGradients.button,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [SlaColors.yellow, Colors.white],
            ).createShader(bounds),
            child: Text(
              'SLA',
              style: TextStyle(
                fontSize: size * 0.28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          Text(
            'SPORTS FOR LIFE',
            style: TextStyle(
              fontSize: size * 0.07,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
