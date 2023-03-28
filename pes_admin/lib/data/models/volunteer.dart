class VolunteerProfile {
  String name,
      pes_id,
      phone,
      email,
      profession,
      pathshaala,
      address,
      joining_date
     ;

  VolunteerProfile.fromJson(Map json)
      : name = json['name'],
        pes_id = json['pes_id'],
        phone = json['phone'].toString(),
        email = json['email'],
        profession = json['profession'],
        pathshaala = json['pathshaala'].toString(),
        joining_date = json['joining_date'],
        address = json['address'];

  VolunteerProfile()
      : name = '',
        pes_id = '',
        phone = '',
        email = '',
        profession = '',
        pathshaala = '',
        address = '',
        joining_date='';
}

class VolunteerHomeScreen {
  final String name, pes_id, batch;

  VolunteerHomeScreen.fromJson(Map json)
      : name = json['name'].toString(),
        pes_id = json['pes_id'].toString(),
        batch = json['batch'].toString();

  VolunteerHomeScreen()
      : name = '',
        pes_id = '',
        batch = '';
}

class VolunteerSlotPage{
  String name,pes_id,pathshaala;
  VolunteerSlotPage.fromJson(Map json)
  : name = json["name"],
  pes_id = json["pes_id"],
  pathshaala = json["pathshaala"].toString();
}