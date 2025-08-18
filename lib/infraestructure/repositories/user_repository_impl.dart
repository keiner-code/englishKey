import 'package:englishkey/domain/datasources/user_datasource.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/domain/repositories/user_repository.dart';
import 'package:englishkey/infraestructure/datasources/user_datasource_impl.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource _datasource;
  UserRepositoryImpl({datasource})
    : _datasource = datasource ?? UserDatasourceImpl();
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
}
