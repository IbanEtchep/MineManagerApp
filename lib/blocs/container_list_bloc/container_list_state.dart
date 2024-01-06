import '../../models/container.dart';

abstract class ContainerListState {}

class ContainerListInitial extends ContainerListState {}

class ContainerListLoading extends ContainerListState {}

class ContainerListLoaded extends ContainerListState {
  final List<DockerContainer> containers;

  ContainerListLoaded(this.containers);
}

class ContainerListError extends ContainerListState {
  final String message;

  ContainerListError(this.message);
}