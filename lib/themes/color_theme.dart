import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.deepPurple,
    onPrimary: Colors.white,
    secondary: Colors.amber,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 30),
    titleMedium: TextStyle(fontSize: 26),
    titleSmall: TextStyle(fontSize: 24),
    bodyLarge: TextStyle(fontSize: 20),
    bodyMedium: TextStyle(fontSize: 18),
    bodySmall: TextStyle(fontSize: 14),
  ),
);