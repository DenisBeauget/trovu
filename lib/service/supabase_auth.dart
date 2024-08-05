import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> handlerUserConnexion(String email, String password) {
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
}
