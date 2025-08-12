import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constant/app_colors.dart';
import 'core/constant/text_styles.dart';
import 'view/login/login_view.dart';
import 'view/order_list/order_list_view.dart';
import 'core/bloc/feedback_bloc.dart';

// A global navigator key is essential for navigating from the auth listener.
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  /// Listens to Supabase auth state changes and navigates the user accordingly.
  void _listenToAuthChanges() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final session = data.session;

      // Ensure the widget is still mounted before attempting to navigate.
      if (!mounted) return;

      if (event == AuthChangeEvent.signedIn && session != null) {
        print('[Auth Listener] User signed in. Navigating to Order List.');
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OrderListView()),
          (route) => false,
        );
      } else if (event == AuthChangeEvent.signedOut) {
        print('[Auth Listener] User signed out. Navigating to Login.');
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accurity Inspection',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      // Assign the global navigator key.
      navigatorKey: navigatorKey,
      // Determine the initial screen based on whether a user session exists on startup.
      home: Supabase.instance.client.auth.currentUser == null
          ? const LoginView()
          : const OrderListView(),
      builder: (context, child) {
        return BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is ShowFeedbackSnackbar) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: state.isError ? AppColors.error : Colors.green,
                  ),
                );
            }
          },
          child: child!,
        );
      },
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
