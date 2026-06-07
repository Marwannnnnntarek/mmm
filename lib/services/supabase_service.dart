import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/registration_request.dart';

class SupabaseService {
  static const _url = 'https://fhmorjicydakcoqwrwix.supabase.co';
  static const _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZobW9yamljeWRha2NvcXdyd2l4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA3MzM0ODgsImV4cCI6MjA5NjMwOTQ4OH0'
      '.pLEz0QdjNknkOM5m16xwv9FKTEuITEV3hCx9WQw7tbs';
  static const _table = 'registration_requests';

  static Future<void> initialize() async {
    await Supabase.initialize(url: _url, publishableKey: _anonKey);
  }

  Future<void> submitRegistrationRequest(RegistrationRequest request) async {
    try {
      await Supabase.instance.client.from(_table).insert(request.toJson());
    } on PostgrestException catch (e) {
      throw Exception('${e.message} (code: ${e.code})');
    }
  }
}
