import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/domain/entities/user_cloud_option.dart';

abstract class UserCloudRepository {
  Future<UserCloudOption> createUser(User user);
  Future<UserCloudOption> updateUser(User user, String id);
  Future<bool> existEmailToRegister(String email);
  Future<void> logout();
  Future<UserCloudOption> login({
    required String email,
    required String password,
  });
}
