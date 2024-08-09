import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Trovu/styles/text_style.dart';

class TutorialOne extends StatelessWidget {
  const TutorialOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: <Widget>[
              const Expanded(
                child: Center(
                    child: Image(
                        image:
                            AssetImage('assets/images/trovu_transparent.png'),
                        width: 250)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tutorial_one_title,
                      textAlign: TextAlign.center,
                      style: titleText(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          AppLocalizations.of(context)!
                              .tutorial_one_description,
                          textAlign: TextAlign.center,
                          style: classicText(),
                        )),
                    const SizedBox(height: 20),
                    const Image(
                        image: AssetImage('assets/images/scroll.gif'),
                        height: 100)
                  ],
                ),
              )
            ],
          )),
    );
  }
}
