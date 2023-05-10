class outreachSlot {
  String date,school,topic, description, slotId,pes_id, status, remarks;
  String timeEnd, timeStart;
  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  outreachSlot.fromJson(Map json)
      : date = json["date"].toString(),
        description = json["description"] ?? json["description"].toString(),
        slotId = json["slot_id"].toString(),
        timeEnd = json["time_end"].toString(),
        timeStart = json["time_start"],
        school = (json['school'] ?? "").toString(),
        topic = (json['topic'] ?? "").toString(),
        pes_id = (json['pes_id'] ?? "").toString(),
        status = (json['status'] ?? "").toString(),
        
        remarks = (json['remarks'] ?? "").toString();
}
