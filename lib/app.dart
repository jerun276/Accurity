import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/bloc/feedback_bloc.dart';
import 'core/constant/app_colors.dart';
import 'core/constant/text_styles.dart';
import 'view/login/login_view.dart';
import 'view/order_list/order_list_view.dart';

// NOTE: The global navigatorKey is no longer needed with this architecture.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accurity Inspection',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      builder: (context, child) {
        // The global BlocListener for Snackbars is perfect here.
        return BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is ShowFeedbackSnackbar) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: state.isError
                        ? AppColors.error
                        : Colors.green,
                  ),
                );
            }
          },
          child: child!,
        );
      },
      // The StreamBuilder is now the single source of truth for navigation.
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          // While waiting for the initial session state, show a loading screen.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If a user session exists, the user is logged in.
          if (snapshot.hasData && snapshot.data?.session != null) {
            return const OrderListView();
          }

          // Otherwise, the user is logged out.
          return const LoginView();
        },
      ),
    );
  }

  /// Builds the global theme for the entire application.
  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4.0,
        titleTextStyle: AppTextStyles.sectionHeader,
      ),
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        hintStyle: AppTextStyles.hint,
        labelStyle: AppTextStyles.fieldLabel,
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
