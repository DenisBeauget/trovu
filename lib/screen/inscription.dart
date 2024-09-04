import 'package:Trovu/model/user.dart';
import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/screen/home.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:Trovu/styles/snackbar_style.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final supabase = Supabase.instance.client;
final Uri _url = Uri.parse('https://flutter.dev');

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  bool checkedValue = false;
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _register() async {
    try {
      final response = await SupabaseAuth().handlerUserCreation(
        emailController.text,
        passwordController.text,
        usernameController.text,
      );

      if (response.user != null && response.session != null) {
        final user = await UserService().setupUser(response);

        if (user != null && context.mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(showSnackbar: true),
              ));
        }
      }
    } on AuthApiException catch (e) {
      if (e.statusCode == '409') {
        showErrorSnackbar(
            context, AppLocalizations.of(context)!.inscription_error_exist);
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
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText:
                        AppLocalizations.of(context)!.inscription_username,
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 20),
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
              Row(
                children: [
                  Checkbox(
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: _launchUrl,
                    child: Text(
                      AppLocalizations.of(context)!.inscription_conditions,
                      softWrap: true,
                      style: classicUnderlineMediumText(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: checkedValue ? _register : null,
                style: btnPrimaryStyle(context),
                child: Text(
                  AppLocalizations.of(context)!.inscription_button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
