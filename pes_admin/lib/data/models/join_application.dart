
class JoinApplication{
  String name,email,phone,pathshaala,profession,address,ques1,ques2;

  JoinApplication({
    this.name = '',
    this.profession = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.ques1 = '',
    this.ques2 = '',
    this.pathshaala = '',
  }
  );

  JoinApplication.fromJson(Map json):
  name = json["name"],
  pathshaala = json["pathshaala"].toString(),
  profession = json["profession"],
  email = json["email"],
  phone = json["phone"].toString(),
  address = json["address"],
  ques1 = json["text1"],
  ques2 = json["text2"];


}