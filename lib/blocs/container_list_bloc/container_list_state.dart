import '../../models/container.dart';

abstract class ContainerListState {}

class ContainerListInitial extends ContainerListState {}

class ContainerListLoading extends ContainerListState {}

class ContainerListLoaded extends ContainerListState {
  final List<DockerContainer> containers;

  ContainerListLoaded(this.containers);
}

class ContainersError extends ContainerListState {
  final String message;

  ContainersError(this.message);
}