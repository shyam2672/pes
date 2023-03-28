class VolunteerAttendance {
  final String pesId, name, pathshaala, profession;
  final int totalSlots, slotsAttended;
  int attendancePercentage = 0;

  VolunteerAttendance.fromJson(Map json)
      : pesId = json['pesId'],
        name = json['name'],
        profession = json['profession'],
        pathshaala = json['pathshaala'].toString(),
        totalSlots = json['totalSlots'],
        slotsAttended = json['slotsAttended'] {
    try {
      attendancePercentage = (slotsAttended * 100 / totalSlots).floor();
    } catch (e) {
      attendancePercentage = 0;
    }
  }
}
