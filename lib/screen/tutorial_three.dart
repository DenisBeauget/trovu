import 'package:Trovu/styles/buttonStyle.dart';
import 'package:flutter/material.dart';
import 'package:Trovu/styles/textStyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        onPressed: () {},
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
