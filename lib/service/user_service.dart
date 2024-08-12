import 'dart:convert';

import 'package:Trovu/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  static Future<UserModel?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }

  Future<UserModel?> setupUser(AuthResponse response) async {
    if (response.user != null) {
      final user = UserModel(
          email: response.user!.email,
          display_name: response.user!.userMetadata!['display_name'],
          token: response.session!.accessToken);
      await saveUser(user);
      return user;
    }
    return null;
  }

  Future<UserModel?> setupForGoogleUser(AuthResponse response) async {
    if (response.user != null) {
      final user = UserModel(
          email: response.user!.email,
          display_name: response.user!.userMetadata!['name'],
          token: response.session!.accessToken);
      await saveUser(user);
      return user;
    }
    return null;
  }
}
