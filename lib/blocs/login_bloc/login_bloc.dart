import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_event.dart';
import '../auth_bloc/auth_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthBloc authBloc;
  String email = '';
  String password = '';

  LoginBloc({required this.userRepository, required this.authBloc}) : super(LoginInitial()) {

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
        authBloc.add(AuthLoggedIn());
      } catch (e) {
        emit(LoginFailure((e.toString())));
      }
    });
  }
}
