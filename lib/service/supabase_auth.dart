import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> handlerUserConnexion(
      String email, String password) async {
    try {
      return supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> handlerUserCreation(
      String email, String password, String username) {
    Map<String, String> datas = {"display_name": username};

    try {
      return supabase.auth
          .signUp(email: email, password: password, data: datas);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> handlerUserConnexionWithGoogle(
      String idToken, String accessToken) {
    try {
      return supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  bool userConnected() {
    return supabase.auth.currentSession != null;
  }
}
