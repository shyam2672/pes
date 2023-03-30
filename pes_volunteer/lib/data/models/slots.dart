class Slot {
  final String day, description, slotId, pathshaala, batch, remarks, batchClass;
  final String timeEnd, timeStart;

  //['slot_id','pathshaala','batch','day','description','time_start','time_end', 'remarks']
  Slot.fromJson(Map json)
      : day = json["day"].toString(),
        description = json["description"] ?? json["description"].toString(),
        slotId = json["slot_id"].toString(),
        timeEnd = json["time_end"],
        timeStart = json["time_start"],
        pathshaala = (json["pathshaala"] ?? "").toString(),
        batch = (json['batch'] ?? "").toString(),
        batchClass = (json['batch_remarks'] ?? "").toString(),
        remarks = (json['remarks'] ?? "").toString();
}
