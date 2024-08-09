import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showErrorSnackbar(BuildContext context, String? text) {
  final snackBar = SnackBar(
    backgroundColor: Theme.of(context).primaryColor,
    behavior: SnackBarBehavior.floating,
    elevation: 10,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    action: SnackBarAction(
      label: AppLocalizations.of(context)!.snackbar_label,
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
        Expanded(
          child: Text(
            softWrap: true,
            text!.isEmpty ? 'Error when logged in!' : text,
            style:
                TextStyle(color: const ColorScheme.light().onPrimaryContainer),
          ),
        ),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showLoginSnackbar(BuildContext context) {
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
          child: Icon(Icons.done_all,
              color: const ColorScheme.light().onPrimaryContainer),
        ),
        Text(
          AppLocalizations.of(context)!.snackbar_title,
          style: TextStyle(color: const ColorScheme.light().onPrimaryContainer),
        ),
      ],
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
