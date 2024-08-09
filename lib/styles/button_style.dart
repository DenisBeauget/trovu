import 'package:Trovu/styles/text_style.dart';
import 'package:flutter/material.dart';

btnPrimaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    textStyle: classicText(),
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 0.5),
    elevation: 10,
    shadowColor: Theme.of(context).colorScheme.shadow,
  );
}

btnSecondaryStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    textStyle: classicText(),
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20.0),
    side: const BorderSide(color: Colors.black, width: 0.5),
    elevation: 10,
    shadowColor: Theme.of(context).colorScheme.shadow,
  );
}
