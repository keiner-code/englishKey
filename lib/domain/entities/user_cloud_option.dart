import 'package:englishkey/domain/entities/user.dart';

class UserCloudOption {
  final User? user;
  final String? errorMessage;
  const UserCloudOption({this.user, this.errorMessage});

  UserCloudOption copyWith({User? user, String? errorMessage}) =>
      UserCloudOption(
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
