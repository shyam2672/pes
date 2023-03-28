class UserProfile {
  final String name,pes_id,phone, email,profession, pathshaala, address;

  UserProfile.fromJson(Map json) :
    name = json['name'],
    pes_id = json['pes_id'],
    phone = json['phone'].toString(),
    email = json['email'],
    profession = json['profession'],
    pathshaala = json['pathshaala'].toString(),
    address = json['address'];

  UserProfile() : name = '', pes_id='',phone='', email='', profession='',pathshaala='', address='';
}
