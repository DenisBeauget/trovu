import 'package:Trovu/provider/user_provider.dart';
import 'package:Trovu/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

import 'package:Trovu/screen/welcome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await dotenv.load(fileName: ".env");

  OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'Trovu', version: '1.0', system: 'Flutter', url: '', comment: '');

  String anonKey = dotenv.env['SUPABASE_KEY'].toString();

  await Supabase.initialize(
      url: "https://itgqvewxpxemtrcsgill.supabase.co", anonKey: anonKey);

  final themeStr = await rootBundle.loadString('assets/theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  final savedUser = await UserService.loadUser();

  runApp(ChangeNotifierProvider(
      create: (_) => UserProvider()..setUser(savedUser),
      child: MyApp(theme: theme)));
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
              OpenFoodAPIConfiguration.globalLanguages =
                  <OpenFoodFactsLanguage>[OpenFoodFactsLanguage.FRENCH];
              OpenFoodAPIConfiguration.globalCountry =
                  OpenFoodFactsCountry.FRANCE;
              return const Locale('fr', '');
            } else {
              OpenFoodAPIConfiguration.globalLanguages =
                  <OpenFoodFactsLanguage>[OpenFoodFactsLanguage.ENGLISH];
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
