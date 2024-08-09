import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialTwo extends StatelessWidget {
  const TutorialTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: <Widget>[
              const Expanded(
                child: Center(
                    child: Image(
                        image: AssetImage('assets/images/trovu_background.png'),
                        width: 250)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tutorial_two_title,
                      textAlign: TextAlign.center,
                      style: italicTextSurface(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          AppLocalizations.of(context)!
                              .tutorial_two_description,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: classicTextSurface(),
                        )),
                    const SizedBox(height: 20),
                    const Image(
                        image: AssetImage('assets/images/scroll.gif'),
                        height: 100),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
