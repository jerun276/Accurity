part of 'login_bloc.dart';

/// Represents the events that can be dispatched from the LoginView.
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched when the user presses the email/password sign-in button.
final class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event dispatched when the user presses the email/password sign-up button.
final class SignUpButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const SignUpButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event dispatched when the user presses the "Sign In with Google" button.
final class GoogleLoginButtonPressed extends LoginEvent {}