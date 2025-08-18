class User {
  String firstName;
  String lastName;
  String? photo;
  String? email;

  User({
    required this.firstName,
    required this.lastName,
    this.photo,
    this.email,
  });
}
