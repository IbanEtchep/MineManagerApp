abstract class ContainerListEvent {}

class LoadContainerListEvent extends ContainerListEvent {}

class ContainerClickedEvent extends ContainerListEvent {
  final String containerId;

  ContainerClickedEvent(this.containerId);
}