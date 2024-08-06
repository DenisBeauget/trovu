import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  Future<GoogleSignInAuthentication> setupGoogleAuth() async {
    String webClientId = dotenv.env['WEB_CLIENT_ID'].toString();

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(clientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      return googleUser!.authentication;
    } catch (e) {
      rethrow;
    }
  }
}
