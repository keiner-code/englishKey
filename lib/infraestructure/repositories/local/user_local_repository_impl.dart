import 'package:englishkey/domain/datasources/local/user_local_datasource.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/domain/repositories/local/user_local_repository.dart';
import 'package:englishkey/infraestructure/datasources/local/user_local_datasource_impl.dart';

class UserLocalRepositoryImpl extends UserLocalRepository {
  final UserLocalDatasource _datasource;
  UserLocalRepositoryImpl({datasource})
    : _datasource = datasource ?? UserLocalDatasourceImpl();
  @override
  Future<User> getUser(String key) {
    return _datasource.getUser(key);
  }

  @override
  Future<User> saveUser(User user) {
    return _datasource.saveUser(user);
  }

  @override
  Future<User> updateUser(User user, String key) {
    return _datasource.updateUser(user, key);
  }

  @override
  Future<void> deleteUser(String key) {
    return _datasource.deleteUser(key);
  }
}
