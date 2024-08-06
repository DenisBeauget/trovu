import 'dart:math';

import 'package:Trovu/model/user.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/home.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:Trovu/styles/buttonStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: AppLocalizations.of(context)!.connexion_email,
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: AppLocalizations.of(context)!.connexion_password,
                    prefixIcon:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await SupabaseAuth().handlerUserConnexion(
                        emailController.text, passwordController.text);

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
                    _showErrorSnackbar(context);
                  }
                },
                style: btnPrimaryStyle(context),
                child: Text(
                  AppLocalizations.of(context)!.connexion_button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showErrorSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {},
      textColor: const ColorScheme.light().onPrimaryContainer,
    ),
    content: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.close,
              color: const ColorScheme.light().onPrimaryContainer),
        ),
        Text(
          'Error when logged in!',
          style: TextStyle(color: const ColorScheme.light().onPrimaryContainer),
        ),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
