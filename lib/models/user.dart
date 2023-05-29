class User {
  int id;
  String username;
  String email;
  String password;

  User(
    this.id,
    this.username,
    this.email,
    this.password,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json["id"] != null ? int.parse(json["id"].toString()) : 0,
      json["username"] ?? "",
      json["email"] ?? "",
      json["password"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'username': username,
        'email': email,
        'password': password,
      };
}
