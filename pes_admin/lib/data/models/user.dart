class User {
  String name, pesId, emailId, phoneNumber;
  String token = "";

  User.empty({required this.token})
      : name = "Volunteer",
        pesId = "123456",
        emailId = "example@gmail.com",
        phoneNumber = "11231313";

  User.fromJson(Map json, {token})
      : this.token = token != null ? token : json["auth_token"],
        name = json["name"],
        pesId = json["pes_id"],
        emailId = json["email"],
        phoneNumber = json["phone"];
}
