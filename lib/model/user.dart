class UserModel {
  final String? email;
  final String? display_name;
  final String? token;

  UserModel(
      {required this.email, required this.display_name, required this.token});

  Map<String, dynamic> toJson() => {
        'email': email,
        'display_name': display_name,
        'token': token,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        display_name: json['display_name'],
        token: json['token'],
      );
}
