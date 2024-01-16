import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  String email = '';
  String password = '';

  LoginBloc({required this.userRepository}) : super(LoginInitial()) {

    on<LoginEmailChanged>((event, emit) {
      email = event.email;
    });

    on<LoginPasswordChanged>((event, emit) {
      password = event.password;
    });

    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        await userRepository.login(email, password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure((e.toString())));
      }
    });
  }
}
