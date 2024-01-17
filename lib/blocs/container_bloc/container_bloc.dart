import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_manager/repositories/container_repository.dart';
import 'package:mine_manager/services/socket_service.dart';

import 'container_bloc_event.dart';
import 'container_bloc_state.dart';

class ContainerBloc extends Bloc<ContainerEvent, ContainerState> {
  ContainerRepository containerRepository;
  SocketService socketService;
  final String containerId;

  ContainerBloc(this.containerRepository, this.socketService ,this.containerId) : super(ContainerInitialState()) {
    add(LoadContainerEvent(containerId));

    on<LoadContainerEvent>((event, emit) async {
      var container = await containerRepository.getContainer(containerId);
      emit(ContainerLoaded(container));
    });

    on<StartContainerEvent>((event, emit) async {
      containerRepository.startContainer(containerId);
    });

    on<StopContainerEvent>((event, emit) async {
      containerRepository.stopContainer(containerId);
    });

    on<RestartContainerEvent>((event, emit) async {
      containerRepository.restartContainer(containerId);
    });

    on<KillContainerEvent>((event, emit) async {
      containerRepository.killContainer(containerId);
    });

    on<SendContainerCommandEvent>((event, emit) async {
      containerRepository.sendCommand(containerId, event.command);
    });
  }

  @override
  Future<void> close() {
    socketService.dispose();
    return super.close();
  }
}
