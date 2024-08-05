import 'package:Trovu/screen/home.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/styles/buttonStyle.dart';
import 'package:Trovu/styles/textStyle.dart';
import 'package:flutter/material.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

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
                  keyboardType: TextInputType.emailAddress,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
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
                          softWrap: true,
                          style: classicUnderlineMediumText(),
                          'Je suis d\'accord avec les conditions d\'utilisation')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: checkedValue
                    ? () async {
                        try {
                          final response = await SupabaseAuth()
                              .handlerUserCreation(
                                  emailController.text,
                                  passwordController.text,
                                  usernameController.text);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Home(showSnackbar: true)));
                        } catch (e) {
                          _showErrorSnackbar(context);
                        }
                      }
                    : null,
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

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
