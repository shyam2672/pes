class Batch{
  String batch,syllabus, remarks;
  Batch.fromJson(Map json):
    batch = json["batch"].toString(),
    syllabus = json["syllabus"],
    remarks = json["remarks"];
}