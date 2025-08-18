import 'package:englishkey/domain/datasources/user_datasource.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDatasourceImpl extends UserDatasource {
  static const _keyFirstName = '_keyFirstName';
  static const _keyLastName = 'keyLastName';
  static const _keyPhoto = 'keyPhoto';
  static const _keyEmail = 'keyEmail';
  @override
  Future<User> getUser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return User(
      firstName: prefs.getString(_keyFirstName) ?? '',
      lastName: prefs.getString(_keyLastName) ?? '',
      photo: prefs.getString(_keyPhoto),
      email: prefs.getString(_keyEmail),
    );
  }

  @override
  Future<User> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, user.firstName);
    await prefs.setString(_keyLastName, user.lastName);
    await prefs.setString(_keyPhoto, user.photo ?? '');
    await prefs.setString(_keyEmail, user.email ?? '');
    return user;
  }

  @override
  Future<User> updateUser(User user, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, user.firstName);
    await prefs.setString(_keyLastName, user.lastName);
    await prefs.setString(_keyPhoto, user.photo ?? '');
    await prefs.setString(_keyEmail, user.email ?? '');
    return user;
  }
}
