import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<void> ensureAnonymousSession() async {
    if (currentUser == null) {
      print('[AuthService] No user session. Signing in anonymously...');
      try {
        await _client.auth.signInAnonymously();
        print('[AuthService] Anonymous sign-in successful.');
      } catch (e) {
        print('[AuthService] Anonymous sign-in FAILED: $e');
      }
    }
  }
}
