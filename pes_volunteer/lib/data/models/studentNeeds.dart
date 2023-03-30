import 'dart:io';

class AppStudentNeeds {
  final String pathshaala, data, id, pesId,name;
  final DateTime post_time;

  AppStudentNeeds.fromJson(Map json)
      : pathshaala = json["pathshaala"].toString(),
        data = json["data"].toString(),
        post_time = DateTime.parse(json["post_time"]),
        id = json["id"].toString(),
        name=json["name"].toString(),
        pesId = json["pes_id"].toString();
}
