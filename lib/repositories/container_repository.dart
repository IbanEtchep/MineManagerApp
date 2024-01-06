import 'package:mine_manager/services/docker_service.dart';
import '../../models/container.dart';

class ContainerRepository {
  final DockerService _dockerService;

  ContainerRepository({required DockerService dockerService}) : _dockerService = dockerService;

  Future<List<DockerContainer>> getContainers() async {
    final response = await _dockerService.getContainersList();
    if (response.success) {
      print(response.data);
      for (var container in response.data) {
        print(DockerContainer.fromJson(container));
      }
      return response.data.map<DockerContainer>((e) => DockerContainer.fromJson(e)).toList();
    } else {
      print(response.errorMessage);
      throw Exception(response.errorMessage);
    }
  }
}
