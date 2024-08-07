import 'package:Trovu/screen/auth.dart';
import 'package:Trovu/screen/connexion.dart';
import 'package:Trovu/screen/home.dart';
import 'package:Trovu/screen/inscription.dart';
import 'package:Trovu/service/supabase_auth.dart';
import 'package:Trovu/styles/button_style.dart';
import 'package:flutter/material.dart';
import 'package:Trovu/styles/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TutorialThree extends StatelessWidget {
  const TutorialThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: <Widget>[
              const Expanded(
                child: Center(
                    child: Image(
                        image: AssetImage('assets/images/trovu_black.png'),
                        width: 250)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          AppLocalizations.of(context)!
                              .tutorial_three_description,
                          textAlign: TextAlign.center,
                          style: tertiaryTextSurface(),
                        )),
                    const SizedBox(height: 100),
                    ElevatedButton(
                        onPressed: () {
                          redirectAfterTutorial(context);
                        },
                        style: btnPrimaryStyle(context),
                        child: const Text("C'est parti !")),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

void redirectAfterTutorial(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      if (Supabase.instance.client.auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const Home(showSnackbar: false)),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Auth()),
            (route) => false);
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
          (route) => false);
    }
  });
}
