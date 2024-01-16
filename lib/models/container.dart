import 'package:flutter/material.dart';

class DockerContainer {
  final String id;
  final String name;
  final String image;
  String state;
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
    var name = json['name'] ?? '';
    if (name.startsWith('/')) {
      name = name.substring(1);
    }

    return DockerContainer(
      id: json['id'],
      name: name,
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

  Color getStatusColor() {
    switch (state) {
      case 'running':
        return Colors.green;
      case 'exited':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void setState(String state) {
    this.state = state;
  }

  String getMemoryUsageFormatted() {
    double memoryInMiB = memoryUsage / (1024 * 1024);
    if (memoryInMiB > 1024) {
      return "${(memoryInMiB / 1024).toStringAsFixed(2)} GiB";
    } else {
      return "${memoryInMiB.toStringAsFixed(2)} MiB";
    }
  }
}
