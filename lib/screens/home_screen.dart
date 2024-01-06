import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/auth_bloc/auth_event.dart';
import 'package:mine_manager/blocs/container_list_bloc/container_list_bloc.dart';
import 'package:mine_manager/blocs/container_list_bloc/container_list_event.dart';
import 'package:mine_manager/blocs/container_list_bloc/container_list_state.dart';

import '../blocs/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authBloc = BlocProvider.of<AuthBloc>(context);
    var containerListBloc = BlocProvider.of<ContainerListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: const Icon(Icons.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {
              authBloc.add(AuthLoggedOut()),
              Navigator.pushReplacementNamed(context, '/login')
            },
          )
        ],
      ),
      body: BlocConsumer<ContainerListBloc, ContainerListState>(
        listener: (context, state) {
          if (state is ContainerListError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ContainerListInitial) {
            containerListBloc.add(LoadContainerListEvent());
          }

          if (state is ContainerListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContainerListLoaded) {
            return ListView.builder(
              itemCount: state.containers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.containers[index].name),
                );
              },
            );
          }

          if (state is ContainerListError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
