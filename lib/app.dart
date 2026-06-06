import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'models/registration_application.dart';
import 'providers/registration_provider.dart';
import 'screens/registration/registration_screen.dart';
import 'screens/success/success_screen.dart';
import 'screens/welcome/welcome_screen.dart';
import 'theme/app_theme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (_, _) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (_, _) => const RegistrationScreen(),
    ),
    GoRoute(
      path: '/success',
      name: 'success',
      builder: (_, _) => const SuccessScreen(),
    ),
  ],
);

class RegistrationApp extends ConsumerWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(selectedLanguageProvider);
    final locale =
        language == Language.arabic ? const Locale('ar') : const Locale('en');

    return MaterialApp.router(
      routerConfig: _router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
      theme: buildSlaTheme(),
    );
  }
}
