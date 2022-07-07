// ignore_for_file: must_be_immutable

part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  bool newNotification = false;

  NotificationState(
    this.newNotification,
  );

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  NotificationInitial() : super(false);
}

class NotificationNew extends NotificationState {
  NotificationNew() : super(true);
}

class NotificationRead extends NotificationState {
  NotificationRead() : super(false);
}
