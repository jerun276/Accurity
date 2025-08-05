// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    // Simulate network delay for a better user experience
    await Future.delayed(const Duration(seconds: 1));

    // --- FAKE AUTHENTICATION LOGIC ---
    // In the future, this is where you would call an AuthRepository
    // to authenticate against Windows password or another service.
    if (event.email == 'inspector@accurity.com' &&
        event.password == 'password') {
      emit(LoginSuccess());
    } else {
      emit(const LoginFailure(error: 'Invalid email or password.'));
    }
  }
}
