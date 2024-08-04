import 'package:flutter/material.dart';

TextStyle titleText() {
  return TextStyle(
      color: const ColorScheme.light().onSurface,
      fontSize: 35,
      fontWeight: FontWeight.w600);
}

TextStyle classicText() {
  return TextStyle(
      color: const ColorScheme.light().inverseSurface,
      fontSize: 20,
      fontWeight: FontWeight.normal);
}

TextStyle classicTextSurface() {
  return const TextStyle(
      color: Color.fromRGBO(237, 225, 209, 100),
      fontSize: 15,
      fontWeight: FontWeight.normal);
}

TextStyle italicTextSurface() {
  return const TextStyle(
      color: Color.fromRGBO(106, 111, 76, 100),
      fontSize: 25,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic);
}

TextStyle tertiaryTextSurface() {
  return const TextStyle(
      color: Color.fromRGBO(65, 46, 39, 100),
      fontSize: 25,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic);
}

TextStyle tertiaryBoldTextSurface() {
  return const TextStyle(
      color: Color.fromRGBO(65, 46, 39, 100),
      fontSize: 20,
      fontWeight: FontWeight.bold);
}
