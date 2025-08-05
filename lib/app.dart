import 'package:flutter/material.dart';

import 'core/constant/app_colors.dart';
import 'core/constant/text_styles.dart';
import 'view/login/login_view.dart';

/// The root widget of the Accurity Inspection application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accurity Inspection',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const LoginView(), // The first screen the user will see.
    );
  }

  /// Builds the global theme for the entire application.
  ThemeData _buildAppTheme() {
    return ThemeData(
      // Define the color scheme based on our AppColors constants.
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      // Set default colors for various components.
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      // --- COMPONENT THEMES ---

      // Default AppBar theme.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary, // Color for title and icons
        elevation: 4.0,
        titleTextStyle: AppTextStyles.sectionHeader,
      ),

      // Default ElevatedButton theme.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnPrimary,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),

      // Default theme for all input fields (TextFormField).
      // This ensures a consistent look across the entire app.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        hintStyle: AppTextStyles.hint,
        labelStyle: AppTextStyles.fieldLabel,
        // Define the border style for all states.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),
    );
  }
}
