class DockerContainer {
  final String id;
  final String name;
  final String image;
  final String state;
  final int cpuUsage;
  final int memoryUsage;

  DockerContainer({
    required this.id,
    required this.name,
    required this.image,
    required this.state,
    required this.cpuUsage,
    required this.memoryUsage,
  });

  factory DockerContainer.fromJson(Map<String, dynamic> json) {
    var memoryUsage = json['memoryUsage'] ?? 0;

    return DockerContainer(
      id: json['id'],
      name: json['name'].toString().substring(1),
      image: json['image'],
      state: json['state'],
      cpuUsage: int.parse(json['cpuUsage'].toString()),
      memoryUsage: memoryUsage,
    );
  }
}
