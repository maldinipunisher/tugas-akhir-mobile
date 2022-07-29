part of 'models.dart';

class Arduino {
  final String deviceId;
  double latitude;
  double longtitude;
  String lock;
  String status;
  DateTime lastOnline;
  DateTime firstStart;
  String trigger;
  List<NotificationModel?>? notifications;

  Arduino(
    this.deviceId, {
    required this.latitude,
    required this.longtitude,
    required this.lock,
    required this.lastOnline,
    required this.status,
    required this.trigger,
    required this.firstStart,
    this.notifications,
  });
}
