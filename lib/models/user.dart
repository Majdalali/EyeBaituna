class User {
  int id;
  String username;
  String email;
  String password;
  int? pincode;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.pincode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] != null ? int.parse(json["id"].toString()) : 0,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      pincode: json["pincode"] != null
          ? int.parse(json["pincode"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id.toString(),
      'username': username,
      'email': email,
      'password': password,
    };

    if (pincode != null) {
      data['pincode'] = pincode.toString();
    }

    return data;
  }
}
