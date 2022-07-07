import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      if (event is NewNotification) {
        emit(NotificationNew());
      } else if (event is ReadNotification) {
        emit(NotificationRead());
      }
    });
  }
}
