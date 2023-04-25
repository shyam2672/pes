class School {
  String n_id, schoolname;
  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  School.fromJson(Map json)
      : n_id = json["n_id"].toString(),
        schoolname = (json['school'] ?? "").toString();
}
