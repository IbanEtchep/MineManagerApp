import 'package:bloc/bloc.dart';
import 'package:mine_manager/models/container.dart';
import 'package:mine_manager/services/socket_service.dart';

class ContainerInfoUpdateCubit extends Cubit<DockerContainer?> {
  final SocketService socketService;
  late DockerContainer? container;

  ContainerInfoUpdateCubit(this.socketService) : super(null) {
    socketService.stateStream.listen((data) {
      emit(data);
    });
  }
}
