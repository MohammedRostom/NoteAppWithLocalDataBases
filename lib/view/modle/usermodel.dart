class User {
  int? Id;
  String? name, email, phone;

  User({this.Id, this.name, this.email, this.phone});

//nOFECTORY no iNTERNET
  User.fromJson(Map<dynamic, dynamic> json) {
    Id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
  }

  Map<String, dynamic> toMap() {
    return ({
      'id': Id,
      'name': name,
      'email': email,
      'phone': phone,
    });
  }
}
