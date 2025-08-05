import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Contains the typographic styles for the Accurity Inspection App.
class AppTextStyles {
  // This class is not meant to be instantiated.
  AppTextStyles._();

  /// Style for the main headers on each section (e.g., "NEIGHBOURHOOD", "SITE").
  static const TextStyle sectionHeader = TextStyle(
    fontFamily: 'Roboto', // Consider adding a custom font in pubspec.yaml
    color: AppColors.textOnPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  /// Style for the labels above each form field (e.g., "Client File Number").
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.primary,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  );

  /// Style for the text the user types into a form field.
  static const TextStyle input = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.textPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  /// Style for hint text inside form fields.
  static const TextStyle hint = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.textSecondary,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  /// Style for the main title in a list item (e.g., the order list).
  static const TextStyle listItemTitle = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.textPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  /// Style for the subtitle in a list item (e.g., order address and date).
  static const TextStyle listItemSubtitle = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.textSecondary,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
  );

  /// Style for primary buttons.
  static const TextStyle button = TextStyle(
    fontFamily: 'Roboto',
    color: AppColors.textOnPrimary,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}
