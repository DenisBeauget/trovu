import 'package:Trovu/model/user.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/connexion.dart';
import 'package:Trovu/screen/home.dart';
import 'package:Trovu/screen/inscription.dart';
import 'package:Trovu/service/google_auth.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isAuthenticated) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(showSnackbar: true),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/trovu_transparent.png',
                width: 200,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: btnSecondaryStyle(context),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Connexion()));
                },
                child: const Text('Connexion'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: btnSecondaryStyle(context),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Inscription()));
                },
                child: const Text('Inscription'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final googleAuth = await GoogleAuth().setupGoogleAuth();
                  final accessToken = googleAuth.accessToken;
                  final idToken = googleAuth.idToken;

                  try {
                    final response = await SupabaseAuth()
                        .handlerUserConnexionWithGoogle(idToken!, accessToken!);

                    UserModel? user = await UserService().setupUser(response);

                    if (user != null && context.mounted) {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      userProvider.setUser(user);
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Home(showSnackbar: true)));
                  } catch (e) {
                    rethrow;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 22.0),
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  elevation: 10,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/google.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Connexion avec Google',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
