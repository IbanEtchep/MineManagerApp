import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_event.dart';
import '../auth_bloc/auth_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../repositories/user_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {

    on<RegisterEmailChanged>((event, emit) {
      email = event.email;
    });

    on<RegisterPasswordChanged>((event, emit) {
      password = event.password;
    });

    on<RegisterUsernameChanged>((event, emit) {
      username = event.username;
    });

    on<RegisterConfirmPasswordChanged>((event, emit) {
      confirmPassword = event.confirmPassword;
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());

      if(password != confirmPassword) {
        emit(RegisterFailure("Les mots de passe ne correspondent pas"));
        return;
      }

      try {
        await userRepository.register(email, username, password);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure((e.toString())));
      }
    });
  }
}
