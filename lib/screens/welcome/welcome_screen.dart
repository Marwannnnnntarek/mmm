import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../models/registration_application.dart';
import '../../providers/registration_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _checkingConnectivity = false;
  bool _showConnectivityError = false;

  Future<void> _onStart() async {
    setState(() {
      _checkingConnectivity = true;
      _showConnectivityError = false;
    });

    final connectivity = ref.read(connectivityServiceProvider);
    final isConnected = await connectivity.isConnected();

    if (!mounted) return;
    setState(() => _checkingConnectivity = false);

    if (!isConnected) {
      setState(() => _showConnectivityError = true);
      return;
    }

    context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(selectedLanguageProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: SlaGradients.welcomeBackground),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sla_logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Language / اللغة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedButton<Language>(
                      segments: [
                        ButtonSegment(
                          value: Language.arabic,
                          label: Text(
                            l10n.languageArabic,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ButtonSegment(
                          value: Language.english,
                          label: Text(
                            l10n.languageEnglish,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      selected: {language},
                      onSelectionChanged: (selected) {
                        ref.read(selectedLanguageProvider.notifier).state =
                            selected.first;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (_showConnectivityError) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: SlaColors.redOrange.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: SlaColors.redOrange, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.errorNoConnection,
                                style: const TextStyle(
                                  color: SlaColors.redOrange,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    GradientButton(
                      onPressed: _checkingConnectivity ? null : _onStart,
                      isLoading: _checkingConnectivity,
                      gradient: SlaGradients.heroButton,
                      child: Text(l10n.startRegistration),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
