import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/supabase_auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SupabaseAuthService _authService;

  LoginBloc({required SupabaseAuthService authService})
    : _authService = authService,
      super(LoginInitial()) {
    // Register the event handlers
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
    on<GoogleLoginButtonPressed>(_onGoogleLoginButtonPressed);
  }

  /// Handles the standard email and password sign-in process.
  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await _authService.signInWithEmail(
      event.email,
      event.password,
    );
    if (result == null) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(error: result));
    }
  }

  /// Handles the email and password sign-up process.
  Future<void> _onSignUpButtonPressed(
    SignUpButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await _authService.signUpWithEmail(
      event.email,
      event.password,
    );
    if (result == null) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(error: result));
    }
  }

  /// Handles the Google Sign-In process.
  Future<void> _onGoogleLoginButtonPressed(
    GoogleLoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await _authService.signInWithGoogle();

    if (result != null) {
      emit(LoginFailure(error: result));
    } else {
      emit(LoginSuccess());
    }
  }
}
