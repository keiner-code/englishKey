import 'package:englishkey/domain/datasources/cloud/user_cloud_datasource.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/domain/entities/user_cloud_option.dart';
import 'package:englishkey/domain/repositories/cloud/user_cloud_repository.dart';
import 'package:englishkey/infraestructure/datasources/cloud/user_cloud_datasource_impl.dart';

class UserCloudRepositoryImpl extends UserCloudRepository {
  final UserCloudDatasource _datasource;
  UserCloudRepositoryImpl({datasource})
    : _datasource = datasource ?? UserCloudDatasourceImpl();
  @override
  Future<UserCloudOption> createUser(User user) {
    return _datasource.createUser(user);
  }

  @override
  Future<UserCloudOption> login({
    required String email,
    required String password,
  }) {
    return _datasource.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _datasource.logout();
  }

  @override
  Future<UserCloudOption> updateUser(User user, String id) {
    return _datasource.updateUser(user, id);
  }

  @override
  Future<bool> existEmailToRegister(String email) {
    return _datasource.existEmailToRegister(email);
  }
}
