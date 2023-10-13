import 'package:flutter/material.dart';

CardTheme movieCardTheme() {
  return CardTheme(
    elevation: 2,
    shadowColor: Colors.blue,
    surfaceTintColor: Colors.lightBlueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    margin: const EdgeInsets.only(top: 15),
  );
}
