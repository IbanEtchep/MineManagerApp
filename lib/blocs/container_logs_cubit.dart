import 'package:bloc/bloc.dart';
import 'package:mine_manager/services/socket_service.dart';

class ContainerLogsCubit extends Cubit<List<String>> {
  final SocketService socketService;

  ContainerLogsCubit(this.socketService) : super([]) {
    socketService.logStream.listen((data) {
      var newLogs = List<String>.from(state);
      newLogs.add(data);
      if (newLogs.length > 100) {
        newLogs = newLogs.sublist(newLogs.length - 100);
      }
      emit(newLogs);
    });
  }
}