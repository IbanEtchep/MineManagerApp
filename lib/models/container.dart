class DockerContainer {
  final String id;
  final String name;
  final String image;
  final String state;
  final double cpuUsage;
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
      name: json['name'],
      image: json['image'],
      state: json['state'],
      cpuUsage: double.parse(json['cpuUsage'].toString()),
      memoryUsage: memoryUsage,
    );
  }

  String getDisplayName() {
    var name = this.name;

    if (name.startsWith('/')) {
      name = name.substring(1);
    }

    if (name.length > 20) {
      name = name.substring(0, 20);
      name += '...';
    }

    return name;
  }
}
