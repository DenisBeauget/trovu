import 'package:Trovu/model/user.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/home.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/button_style.dart';
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
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    try {
      final response = await SupabaseAuth().handlerUserConnexion(
        emailController.text,
        passwordController.text,
      );

      if (response.user != null && response.session != null) {
        final user = await UserService().setupUser(response);

        if (user != null && context.mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(showSnackbar: true),
              ));
        }
      }
    } on AuthApiException catch (e) {
      if (e.statusCode == '400') {
        showErrorSnackbar(
          context,
          AppLocalizations.of(context)!.connexion_error_credentials,
        );
      } else {
        showErrorSnackbar(context,
            AppLocalizations.of(context)!.inscription_connexion_default_error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: _toggleVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: _obscureText,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _login,
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
