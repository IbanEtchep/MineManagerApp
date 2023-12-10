import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_event.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        //logout button
        child: ElevatedButton(
          child: const Text('Déconnexion'),
          onPressed: () => {
            authBloc.add(AuthLoggedOut()),
            Navigator.pushReplacementNamed(context, '/login')
          },
        ),
      ),
    );
  }
}
