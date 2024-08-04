import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:Trovu/screen/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
        ],
        localeListResolutionCallback: (locales, supportedLocales) {
          if (locales != null && locales.isNotEmpty) {
            if (locales.first.languageCode == 'fr') {
              return const Locale('fr', '');
            } else {
              return const Locale('en', '');
            }
          }
          return null;
        },
        home: redirectUser(),
        theme: theme);
  }
}

Widget redirectUser() {
  return const WelcomeScreen();
}
