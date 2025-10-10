import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/domain/entities/user_cloud_option.dart';

abstract class UserCloudDatasource {
  Future<UserCloudOption> createUser(User user);
  Future<UserCloudOption> updateUser(User user, String id);
  Future<void> logout();
  Future<bool> existEmailToRegister(String email);
  Future<UserCloudOption> login({
    required String email,
    required String password,
  });
}
