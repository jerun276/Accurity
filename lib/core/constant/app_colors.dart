import 'package:flutter/material.dart';

/// Contains the color palette for the Accurity Inspection App.
class AppColors {
  // This class is not meant to be instantiated.
  AppColors._();

  // --- PRIMARY COLORS ---
  /// The main deep purple used for field labels and primary accents.
  static const Color primary = Color(0xFF6200EE);

  /// A slightly lighter shade of the primary purple.
  static const Color primaryLight = Color(0xFF7E3FF2);

  /// The main teal/turquoise color used for headers and interactive elements.
  static const Color accent = Color(0xFF00A99D);

  // --- UI & NEUTRAL COLORS ---
  /// The standard background color for most screens.
  static const Color background = Color(0xFFF5F5F5);

  /// The color for card surfaces, text fields, and dialogs.
  static const Color surface = Colors.white;

  /// The color used for dividers, borders, and disabled elements.
  static const Color lightGrey = Color(0xFFE0E0E0);

  /// A darker grey for secondary text or icons.
  static const Color mediumGrey = Color(0xFF9E9E9E);

  /// Standard color for error messages and delete icons.
  static const Color error = Color(0xFFB00020);

  static const Color errorLight = Color.fromARGB(255, 255, 0, 0);

  // --- TEXT COLORS ---
  /// The default color for body text.
  static const Color textPrimary = Color(0xFF212121);

  /// A lighter text color for subtitles, hints, or less important info.
  static const Color textSecondary = Color(0xFF757575);

  /// The color for text that appears on dark backgrounds (e.g., buttons, headers).
  static const Color textOnPrimary = Colors.white;
}
