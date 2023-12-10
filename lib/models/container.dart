class DockerContainer {
  final String id;
  final String name;
  final String image;
  final String state;
  final double cpuUsage;
  final double memoryUsage;

  DockerContainer({
    required this.id,
    required this.name,
    required this.image,
    required this.state,
    required this.cpuUsage,
    required this.memoryUsage,
  });

  factory DockerContainer.fromJson(Map<String, dynamic> json) {
    return DockerContainer(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      state: json['state'],
      cpuUsage: double.parse(json['cpuUsage'].toString()),
      memoryUsage: double.parse(json['memoryUsage'].toString()),
    );
  }
}
