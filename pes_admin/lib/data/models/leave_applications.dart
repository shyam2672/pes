
class LeaveApplication{
  String pes_id,name,pathshaala,reason,attend;
  LeaveApplication(this.pes_id,this.name,this.pathshaala,this.reason,this.attend);
  
  LeaveApplication.fromJson(Map json)
    : pes_id = json["pes_id"],
    name = json["name"],
    pathshaala = json["pathshaala"].toString(),
    reason = json["reason"],
    attend = json["attend"].toString();
}