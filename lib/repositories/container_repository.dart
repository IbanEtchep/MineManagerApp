import 'package:mine_manager/services/docker_service.dart';
import '../../models/container.dart';

class ContainerRepository {
  final DockerService _dockerService;

  ContainerRepository({required DockerService dockerService}) : _dockerService = dockerService;

  Future<List<DockerContainer>> getContainers() async {
    final response = await _dockerService.getContainersList();
    if (response.success) {
      return response.data.map<DockerContainer>((e) => DockerContainer.fromJson(e)).toList();
    } else {
      throw Exception(response.errorMessage);
    }
  }

  Future<DockerContainer> getContainer(String id) async {
    final response = await _dockerService.getContainer(id);
    if (response.success) {
      return DockerContainer.fromJson(response.data);
    } else {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> startContainer(String id) async {
    final response = await _dockerService.startContainer(id);
    if (!response.success) {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> stopContainer(String id) async {
    final response = await _dockerService.stopContainer(id);
    if (!response.success) {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> restartContainer(String id) async {
    final response = await _dockerService.restartContainer(id);
    if (!response.success) {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> killContainer(String id) async {
    final response = await _dockerService.killContainer(id);
    if (!response.success) {
      throw Exception(response.errorMessage);
    }
  }

  Future<void> sendCommand(String id, String command) async {
    final response = await _dockerService.sendCommand(id, command);
    if (!response.success) {
      throw Exception(response.errorMessage);
    }
  }
}
