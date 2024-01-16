import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/register_bloc/register_bloc.dart';
import 'package:mine_manager/repositories/container_repository.dart';
import 'package:mine_manager/repositories/user_repository.dart';
import 'package:mine_manager/screens/container_view_screen.dart';
import 'package:mine_manager/screens/home_screen.dart';
import 'package:mine_manager/screens/login_screen.dart';
import 'package:mine_manager/screens/register_screen.dart';
import 'package:mine_manager/services/auth_service.dart';
import 'package:mine_manager/services/docker_service.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/auth_bloc/auth_state.dart';
import 'blocs/auth_bloc/auth_event.dart';
import 'blocs/container_list_bloc/container_list_bloc.dart';
import 'blocs/login_bloc/login_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var repositoryProviders = [
      RepositoryProvider<AuthService>(
        create: (context) => AuthService(),
      ),
      RepositoryProvider<UserRepository>(
        create: (context) => UserRepository(
            authService: RepositoryProvider.of<AuthService>(context)),
      ),
      RepositoryProvider<ContainerRepository>(
        create: (context) => ContainerRepository(
            dockerService:
                DockerService(RepositoryProvider.of<AuthService>(context))),
      ),
    ];

    var blocProviders = [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
      ),
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
      ),
      BlocProvider<ContainerListBloc>(
        create: (context) => ContainerListBloc(
            containerRepository:
                RepositoryProvider.of<ContainerRepository>(context)),
      ),
    ];

    const int primaryColorValue = 0xFF142f3f;
    const MaterialColor primaryColor = MaterialColor(
      primaryColorValue,
      <int, Color>{
        50: Color(primaryColorValue),
        100: Color(primaryColorValue),
        200: Color(primaryColorValue),
        300: Color(primaryColorValue),
        400: Color(primaryColorValue),
        500: Color(primaryColorValue),
        600: Color(primaryColorValue),
        700: Color(primaryColorValue),
        800: Color(primaryColorValue),
        900: Color(primaryColorValue),
      },
    );

    return MultiRepositoryProvider(
        providers: repositoryProviders,
        child: MultiBlocProvider(
          providers: blocProviders,
          child: MaterialApp(
              title: 'Mine Manager',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: primaryColor,
              ),
              initialRoute: '/login',
              routes: {
                '/login': (context) => const AuthGate(),
                '/register': (context) => const RegisterScreen(),
                '/home': (context) => const HomeScreen(),
                '/container': (context) => ContainerViewScreen(
                  containerId: ModalRoute.of(context)!.settings.arguments as String,
                ),
              }
          ),
        ));
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthStarted());

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: const LoginScreen(),
    );
  }
}
