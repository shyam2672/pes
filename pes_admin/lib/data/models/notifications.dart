class AppNotification {
  String id,title,description;
  DateTime time;

  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  AppNotification.fromJson(Map json)
      : id = json["id"].toString(),
        description = json["description"].toString(),
        title = json["title"].toString(),
        time = DateTime.parse(json["time"]);
}
