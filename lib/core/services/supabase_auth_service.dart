import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  /// Ensures a user session exists, creating an anonymous one if needed.
  /// This should be called once when the app starts.
  Future<void> initialize() async {
    if (currentUser == null) {
      print(
        '[AuthService] No user session found. Signing in anonymously for testing.',
      );
      try {
        await _client.auth.signInAnonymously();
        print('[AuthService] Anonymous sign-in successful.');
      } catch (e) {
        print('[AuthService] Anonymous sign-in FAILED: $e');
      }
    } else {
      print('[AuthService] Existing user session found.');
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<String?> signInWithGoogle() async {
    try {
      const redirectTo = 'com.example.accurity://callback';
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : redirectTo,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }
}
