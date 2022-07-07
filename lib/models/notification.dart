part of 'models.dart';

class NotificationModel {
  String title;
  String body;
  String read;
  DateTime? date;
  NotificationModel({
    required this.title,
    required this.body,
    required this.read,
    this.date,
  });

  factory NotificationModel.toMap(String data) => NotificationModel(
      title: jsonDecode(data)["title"],
      body: jsonDecode(data)["body"],
      read: jsonDecode(data)["read"],
      date: DateTime.tryParse(jsonDecode(data)["date"]));
}
