import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// A service to handle all authentication logic with Supabase.
class SupabaseAuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Gets the current logged-in user.
  User? get currentUser => _client.auth.currentUser;

  /// Signs a user in with their email and password.
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      print('[AuthService] Sign-in successful for user: ${currentUser?.email}');
      return null;
    } on AuthException catch (e) {
      print('[AuthService] Sign-in FAILED: ${e.message}');
      return e.message;
    }
  }

  /// Signs a new user up with their email and password.
  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
      print('[AuthService] Sign-up successful for user: ${currentUser?.email}');
      return null;
    } on AuthException catch (e) {
      print('[AuthService] Sign-up FAILED: ${e.message}');
      return e.message;
    }
  }

  Future<void> initialize() async {
    // This logic is for testing with a placeholder user.
    if (currentUser == null) {
      print(
        '[AuthService] No user session found. Signing in anonymously for testing...',
      );
      try {
        await _client.auth.signInAnonymously();
        print(
          '[AuthService] Anonymous sign-in successful. User ID: ${currentUser?.id}',
        );
      } catch (e) {
        print('[AuthService] Anonymous sign-in FAILED: $e');
      }
    } else {
      print(
        '[AuthService] Existing user session found. User ID: ${currentUser?.id}',
      );
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await _client.auth.signOut();
    print('[AuthService] User signed out.');
  }

  Future<String?> signInWithGoogle() async {
    try {
      // The redirectTo parameter is crucial for mobile auth.
      const redirectTo = 'com.example.accurity://callback';

      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : redirectTo,
      );

      return null; // Success
    } on AuthException catch (e) {
      print('[AuthService] Google Sign-in FAILED: ${e.message}');
      return e.message;
    }
  }
}
