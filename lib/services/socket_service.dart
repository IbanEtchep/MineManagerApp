import 'dart:async';
import 'package:mine_manager/constants.dart';
import 'package:mine_manager/models/container.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketService {
  late IO.Socket socket;
  final StreamController<String> _logStreamController = StreamController.broadcast();
  final StreamController<DockerContainer> _dockerInfoUpdateStreamController = StreamController.broadcast();

  SocketService(String containerId) {
    socket = IO.io(Constants.wsUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('Connected to WebSocket');
      socket.emit('subscribe', {'containerId': containerId});
    });

    socket.on('log', (data) {
      if (data != null) {
        final ansiEscape = RegExp(r'\x1B(\[|\])(;?[0-9]{1,3})*([0-9A-ORZcf-nqry=><~])');
        String log = data['log'];

        log = log.replaceAll(ansiEscape, '');
        log = log.replaceAll('\n', '').replaceAll('\r', '').replaceAll('>....', '');

        _logStreamController.add(log);
      }
    });

    socket.on('container-info', (data) {
      if (data != null) {
        _dockerInfoUpdateStreamController.add(DockerContainer.fromJson(data));
      }
    });

    socket.connect();
  }

  Stream<String> get logStream => _logStreamController.stream;
  Stream<DockerContainer> get stateStream => _dockerInfoUpdateStreamController.stream;

  void dispose() {
    print('Closing WebSocket connection');
    socket.emit('unsubscribe');
    socket.dispose();
    _logStreamController.close();
    _dockerInfoUpdateStreamController.close();
  }
}
