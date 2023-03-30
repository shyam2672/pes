import 'dart:io';

class AppNotification {
  final String title, description, id;
  final DateTime time;
  bool read;

  AppNotification.fromJson(Map json)
      : title = json["title"].toString(),
        description = json["description"].toString(),
        time = DateTime.parse(json["time"]),
        id = json["id"].toString(),
        read = json["read"].toString() == '1';
}
