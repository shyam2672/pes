class Topic {
  String n_id, topicname,description;
  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  Topic.fromJson(Map json)
      : n_id = json["n_id"].toString(),
        topicname = (json['title'] ?? "").toString(),
        description=(json['description'] ?? "").toString();
}
