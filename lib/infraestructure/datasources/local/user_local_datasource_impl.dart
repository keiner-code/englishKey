import 'package:englishkey/domain/datasources/local/user_local_datasource.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDatasourceImpl extends UserLocalDatasource {
  static const _keyFirstName = '_keyFirstName';
  static const _keyLastName = 'keyLastName';
  static const _keyPhoto = 'keyPhoto';
  static const _keyEmail = 'keyEmail';
  static const _keyPassword = 'keyPassword';
  static const _itISRegisterInline = '_itISRegisterInline';
  @override
  Future<User> getUser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return User(
      firstName: prefs.getString(_keyFirstName) ?? '',
      lastName: prefs.getString(_keyLastName) ?? '',
      email: prefs.getString(_keyEmail) ?? '',
      password: prefs.getString(_keyPassword) ?? '',
      photo: prefs.getString(_keyPhoto),
      itIsRegisterOnline: prefs.getBool(_itISRegisterInline) ?? false,
    );
  }

  @override
  Future<User> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, user.firstName);
    await prefs.setString(_keyLastName, user.lastName);
    await prefs.setString(_keyPassword, user.password);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyPhoto, user.photo ?? '');
    await prefs.setBool(_itISRegisterInline, user.itIsRegisterOnline);
    return user;
  }

  @override
  Future<User> updateUser(User user, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFirstName, user.firstName);
    await prefs.setString(_keyLastName, user.lastName);
    //await prefs.setString(_keyEmail, user.email);
    //await prefs.setString(_keyPassword, user.password);
    await prefs.setString(_keyPhoto, user.photo ?? '');
    return user;
  }

  @override
  Future<void> deleteUser(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyPhoto);
    await prefs.remove(_itISRegisterInline);
  }
}
