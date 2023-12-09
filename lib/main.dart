import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/register_bloc/register_bloc.dart';
import 'package:mine_manager/repositories/user_repository.dart';
import 'package:mine_manager/screens/home_screen.dart';
import 'package:mine_manager/screens/login_screen.dart';
import 'package:mine_manager/screens/register_screen.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_state.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/login_bloc/login_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();
  late final LoginBloc loginBloc;
  late final RegisterBloc registerBloc;

  MyApp({super.key}) {
    loginBloc = LoginBloc(
      userRepository: userRepository,
      authBloc: AuthBloc(userRepository: userRepository),
    );

    registerBloc = RegisterBloc(
      userRepository: userRepository,
      authBloc: AuthBloc(userRepository: userRepository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineManager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => BlocProvider.value(
          value: loginBloc,
          child: const LoginScreen(),
        ),
        '/register': (context) => BlocProvider.value(
          value: registerBloc,
          child: const RegisterScreen(),
        ),
        '/home': (context) => BlocProvider(
          create: (context) => AuthBloc(userRepository: userRepository),
          child: AuthGate(userRepository: userRepository),
        )
      }
    );
  }
}

class AuthGate extends StatelessWidget {
  final UserRepository userRepository;

  const AuthGate({Key? key, required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    authBloc.add(AuthStarted());

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

}