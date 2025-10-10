import 'package:englishkey/domain/entities/user.dart';

abstract class UserLocalRepository {
  Future<User> saveUser(User user);
  Future<User> updateUser(User user, String key);
  Future<User> getUser(String key);
  Future<void> deleteUser(String key);
}
