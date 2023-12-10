import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(AuthInitial()) {

    on<AuthStarted>((event, emit) async {
      print("AuthStarted");
      try {
        final user = await userRepository.getUser();
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoggedIn>((event, emit) async {
      print("AuthLoggedIn");
      try {
        final user = await userRepository.getUser();
        emit(AuthAuthenticated(user: user));
      } catch (e) {
        emit(AuthFailure(message: "Impossible de récupérer les informations de l'utilisateur"));
      }
    });


    on<AuthLoggedOut>((event, emit) async {
      print("AuthLoggedOut");
      await userRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}
