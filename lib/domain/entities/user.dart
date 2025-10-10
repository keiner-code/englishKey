class User {
  String firstName;
  String lastName;
  String email;
  String password;
  String? photo;
  bool itIsRegisterOnline;

  User({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    this.photo,
    this.itIsRegisterOnline = false,
  });
}
