import 'package:mine_manager/models/container.dart';

abstract class ContainerState {}

class ContainerInitialState extends ContainerState {}

class ContainerLoaded extends ContainerState{
  DockerContainer container;

  ContainerLoaded(this.container);
}
