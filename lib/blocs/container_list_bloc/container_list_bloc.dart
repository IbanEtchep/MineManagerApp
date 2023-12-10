import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/container_repository.dart';
import 'container_list_event.dart';
import 'container_list_state.dart';

class ContainerListBloc extends Bloc<ContainerListEvent, ContainerListState> {
  final ContainerRepository containerRepository;

  ContainerListBloc({required this.containerRepository}) : super(ContainerListInitial()) {
    on<LoadContainerListEvent>((event, emit) async {
      emit(ContainerListLoading());
      try {
        final containers = await containerRepository.getContainers();
        emit(ContainerListLoaded(containers));
      } catch (e) {
        emit(ContainersError((e.toString())));
      }
    });
  }
}
