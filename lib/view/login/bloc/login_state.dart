part of 'login_bloc.dart';

/// Represents the different states of the Login screen.
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

/// The initial state of the login form, ready for user input.
final class LoginInitial extends LoginState {}

/// The state when the login process is in progress, showing a loading indicator.
final class LoginLoading extends LoginState {}

/// The state upon successful login, used to trigger navigation.
final class LoginSuccess extends LoginState {}

/// The state when login fails, containing an error message to display.
final class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
