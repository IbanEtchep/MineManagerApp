abstract class ContainerEvent {}

class LoadContainerEvent extends ContainerEvent {
  final String containerId;

  LoadContainerEvent(this.containerId);
}

class StartContainerEvent extends ContainerEvent {
  final String containerId;

  StartContainerEvent(this.containerId);
}

class StopContainerEvent extends ContainerEvent {
  final String containerId;

  StopContainerEvent(this.containerId);
}

class RestartContainerEvent extends ContainerEvent {
  final String containerId;

  RestartContainerEvent(this.containerId);
}

class KillContainerEvent extends ContainerEvent {
  final String containerId;

  KillContainerEvent(this.containerId);
}

class SendContainerCommandEvent extends ContainerEvent {
  final String containerId;
  final String command;

  SendContainerCommandEvent(this.containerId, this.command);
}