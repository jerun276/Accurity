import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String _kUserCacheKey = 'accurity_cached_user_session';

class SupabaseAuthService {
  final SupabaseClient _client = Supabase.instance.client;
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_kUserCacheKey);
    if (userJson != null) {
      _currentUser = User.fromJson(jsonDecode(userJson));
      print('[AuthService] Loaded user from cache: ${_currentUser?.email}');
    }
    _client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      _currentUser = session?.user;

      if (session != null) {
        print(
          '[AuthService] onAuthStateChange: User is signed in (${_currentUser?.email})',
        );
        await _cacheUserSession(session.user);
      } else {
        print('[AuthService] onAuthStateChange: User is signed out.');
        await _clearUserCache();
      }
    });

    _currentUser = _client.auth.currentUser;
    if (_currentUser != null) {
      print('[AuthService] Initial user check found: ${_currentUser?.email}');
      await _cacheUserSession(_currentUser!);
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

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> _cacheUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserCacheKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserCacheKey);
  }
}
