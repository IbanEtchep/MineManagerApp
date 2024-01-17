import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/blocs/container_bloc/container_bloc.dart';
import 'package:mine_manager/blocs/container_bloc/container_bloc_event.dart';
import 'package:mine_manager/blocs/container_bloc/container_bloc_state.dart';
import 'package:mine_manager/blocs/container_logs_cubit.dart';
import 'package:mine_manager/blocs/container_update_cubit.dart';
import 'package:mine_manager/constants.dart';
import 'package:mine_manager/models/container.dart';
import 'package:mine_manager/repositories/container_repository.dart';
import 'package:mine_manager/services/socket_service.dart';

class ContainerViewScreen extends StatefulWidget {
  final String containerId;

  const ContainerViewScreen({super.key, required this.containerId});

  @override
  ContainerViewScreenState createState() => ContainerViewScreenState();
}

class ContainerViewScreenState extends State<ContainerViewScreen> {
  final TextEditingController _commandInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commandInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendCommand(ContainerBloc containerBloc) {
    final String value = _commandInputController.text;
    containerBloc.add(SendContainerCommandEvent(widget.containerId, value));
    _commandInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ContainerRepository containerRepository =
        RepositoryProvider.of<ContainerRepository>(context);
    SocketService socketService = SocketService(widget.containerId);
    ContainerBloc containerBloc =
        ContainerBloc(containerRepository, socketService, widget.containerId);

    return MultiBlocProvider(
        providers: [
          BlocProvider<ContainerBloc>(
            create: (context) => containerBloc,
          ),
          BlocProvider<ContainerLogsCubit>(
            create: (context) => ContainerLogsCubit(socketService),
          ),
          BlocProvider<ContainerInfoUpdateCubit>(
            create: (context) => ContainerInfoUpdateCubit(socketService),
          ),
        ],
        child: Scaffold(
            backgroundColor: Constants.darkBackgroundColor,
            appBar: AppBar(
              title: BlocBuilder<ContainerBloc, ContainerState>(
                builder: (context, state) {
                  if (state is ContainerLoaded) {
                    return Row(
                      children: [
                        Text(state.container.name),
                        const SizedBox(width: 8),
                        _getStatusIcon(state.container),
                      ],
                    );
                  }
                  return const Text('Chargement...');
                },
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 16),
                _getContainerActionBar(containerBloc),
                const SizedBox(height: 16),
                _getContainerTerminal(context),
                _getCommandInput(containerBloc),
                const SizedBox(height: 16),
                _getContainerUsage(),
              ],
            )
        )
    );
  }

  Widget _getContainerActionBar(ContainerBloc containerBloc) {
    return BlocBuilder<ContainerBloc, ContainerState>(
      builder: (context, state) {
        if (state is ContainerLoaded) {
          var container = state.container;

          return BlocBuilder<ContainerInfoUpdateCubit, DockerContainer?>(
            builder: (context, dockerContainer) {
              String containerState = dockerContainer?.state ?? '';
              bool isRunning = containerState.toLowerCase() == 'running';
              bool isExited = containerState.toLowerCase() == 'exited';

              if(dockerContainer != null) {
                container = dockerContainer;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isExited)
                    ElevatedButton(
                      onPressed: () =>
                          containerBloc.add(StartContainerEvent(container.id)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Start'),
                    ),
                  if (isRunning) ...[
                    ElevatedButton(
                      onPressed: () => containerBloc
                          .add(RestartContainerEvent(container.id)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Restart'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          containerBloc.add(StopContainerEvent(container.id)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Stop'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          containerBloc.add(KillContainerEvent(container.id)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Kill'),
                    ),
                  ],
                  if (!isRunning && !isExited)
                    ElevatedButton(
                      onPressed: () =>
                          containerBloc.add(KillContainerEvent(container.id)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Kill'),
                    ),
                ],
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _getContainerTerminal(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.6,
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        color: Constants.terminalBackGroundColor,
      ),
      child: BlocBuilder<ContainerLogsCubit, List<String>>(
        builder: (context, logs) {
          if (logs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients &&
                !_scrollController.position.isScrollingNotifier.value) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            }
          });

          return Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(Colors.white),
                thickness: MaterialStateProperty.all(6.0),
                radius: const Radius.circular(10),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 2),
                    child: Text(
                      logs[index],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getCommandInput(
    ContainerBloc containerBloc,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        color: Constants.terminalBackGroundColorSecondary,
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Envoyer une commande',
                hintStyle: TextStyle(color: Colors.white),
              ),
              onSubmitted: (_) => _sendCommand(containerBloc),
              controller: _commandInputController,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              _sendCommand(containerBloc);
            },
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(DockerContainer container) {
    return BlocBuilder<ContainerInfoUpdateCubit, DockerContainer?>(
      builder: (context, state) {
        if (state != null) {
          container = state;
        }

        return Container(
          alignment: Alignment.center,
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: container.getStatusColor(),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _getContainerUsage() {
    return BlocBuilder<ContainerInfoUpdateCubit, DockerContainer?>(
      builder: (context, state) {

        double cpuUsage = state != null ? state.cpuUsage : 0;
        String memoryUsage = state != null ? state.getMemoryUsageFormatted() : 'MB';

        return Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: Constants.terminalBackGroundColorSecondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(Icons.memory, color: Colors.white),
                  const SizedBox(width: 5),
                  Text('$cpuUsage%', style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.storage, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(memoryUsage, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
