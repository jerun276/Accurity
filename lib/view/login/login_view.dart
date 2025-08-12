import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/text_styles.dart';
import '../../../core/services/supabase_auth_service.dart';
import 'bloc/login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => LoginBloc(
          authService: RepositoryProvider.of<SupabaseAuthService>(context),
        ),
        child: Stack(
          children: [
            // --- First Purple Circular Background Shape (top-right) ---
            Positioned(
              top: -150,
              right: -150,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
            ),
            // --- Second Purple Circular Background Shape (bottom-left) ---
            Positioned(
              bottom: -100, // Adjust position as needed
              left: -100, // Adjust position as needed
              child: Container(
                width: 250, // Slightly smaller size for variation
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(
                    0.1,
                  ), // A lighter shade to make it less prominent
                ),
              ),
            ),
            // --- The Login Form itself ---
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_isSigningUp) {
        context.read<LoginBloc>().add(
          SignUpButtonPressed(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      } else {
        context.read<LoginBloc>().add(
          LoginButtonPressed(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  void _onGoogleSignInPressed() {
    context.read<LoginBloc>().add(GoogleLoginButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.error,
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 96,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  _isSigningUp ? 'Create Account' : 'Welcome to Accurity',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isSigningUp
                      ? 'Create an account to get started.'
                      : 'Sign in to your account.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.listItemSubtitle.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                // --- Email Input Field ---
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration.copyWith(
                    labelText: 'Email Address',
                    labelStyle: AppTextStyles.hint,
                  ),
                  style: AppTextStyles.input,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || !value.contains('@'))
                      ? 'Please enter a valid email'
                      : null,
                ),
                const SizedBox(height: 24),
                // --- Password Input Field ---
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration.copyWith(
                    labelText: 'Password',
                    labelStyle: AppTextStyles.hint,
                  ),
                  style: AppTextStyles.input,
                  obscureText: true,
                  validator: (value) => (value == null || value.length < 6)
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 48),
                // --- Primary Button ---
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is LoginLoading ? null : _onFormSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.textOnPrimary,
                        elevation: 0,
                      ),
                      child: state is LoginLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.textOnPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isSigningUp ? 'SIGN UP' : 'SIGN IN',
                              style: AppTextStyles.button,
                            ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // --- "OR" Divider ---
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.lightGrey, height: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColors.mediumGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.lightGrey, height: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // --- Google Button ---
                OutlinedButton(
                  onPressed: _onGoogleSignInPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                      color: AppColors.lightGrey,
                      width: 2,
                    ),
                    backgroundColor: AppColors.surface,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.google,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Sign In with Google',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textPrimary,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => setState(() => _isSigningUp = !_isSigningUp),
                  child: Text(
                    _isSigningUp
                        ? 'Already have an account? Sign In'
                        : 'Need an account? Sign Up',
                    style: AppTextStyles.listItemSubtitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable InputDecoration for consistent form field styling.
const InputDecoration _inputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.lightGrey),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.lightGrey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.primary, width: 2),
  ),
  filled: true,
  fillColor: AppColors.surface,
  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
);
