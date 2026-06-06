import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/registration_application.dart';
import '../services/connectivity_service.dart';
import '../services/supabase_service.dart';

final connectivityServiceProvider =
    Provider<ConnectivityService>((_) => const ConnectivityService());

final supabaseServiceProvider =
    Provider<SupabaseService>((_) => SupabaseService());

final selectedLanguageProvider =
    StateProvider<Language>((_) => Language.arabic);
