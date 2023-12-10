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
}
