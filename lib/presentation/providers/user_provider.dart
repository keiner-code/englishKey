import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/infraestructure/repositories/cloud/user_cloud_repository_impl.dart';
import 'package:englishkey/infraestructure/repositories/local/user_local_repository_impl.dart';
import 'package:englishkey/presentation/providers/connection_provider.dart';
import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserStatus { initial, loading, success, error }

class UserState {
  final String errorMessage;
  final User? user;
  final UserStatus status;
  final bool isLoginInline;

  UserState({
    required this.errorMessage,
    required this.status,
    this.user,
    this.isLoginInline = false,
  });

  UserState copyWith({
    String? errorMessage,
    User? user,
    UserStatus? status,
    bool? isLoginInline,
  }) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      status: status ?? this.status,
      isLoginInline: isLoginInline ?? this.isLoginInline,
    );
  }
}

class UserNotifier extends ChangeNotifier {
  late UserLocalRepositoryImpl _localRepositoryImpl = UserLocalRepositoryImpl();
  late UserCloudRepositoryImpl _cloudRepositoryImpl = UserCloudRepositoryImpl();
  late Ref<UserNotifier> ref;
  UserState _state = UserState(errorMessage: '', status: UserStatus.initial);
  UserState get state => _state;

  UserNotifier({required this.ref}) {
    _localRepositoryImpl = UserLocalRepositoryImpl();
    _cloudRepositoryImpl = UserCloudRepositoryImpl();
  }

  void isLoginToggleInline(bool isLogin) {
    _state = _state.copyWith(isLoginInline: isLogin);
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    _state = _state.copyWith(
      status: UserStatus.loading,
      errorMessage: null,
      isLoginInline: false,
    );
    notifyListeners();
    try {
      final hasInternet = ref
          .read(connectionProvider)
          .maybeWhen(data: (has) => has, orElse: () => false);

      if (hasInternet) {
        final response = await _cloudRepositoryImpl.createUser(user);
        _state = _state.copyWith(
          isLoginInline: response.errorMessage == null ? false : true,
          errorMessage: response.errorMessage,
        );
        notifyListeners();
        user.itIsRegisterOnline = true;
      }
      if (_state.user!.email.isNotEmpty) return;

      _localRepositoryImpl.saveUser(user);
      await getUser();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      final user = await _localRepositoryImpl.getUser('key');
      if (user.email != email && user.password != password) {
        _state = _state.copyWith(
          status: UserStatus.error,
          errorMessage: 'Usuario no registrado',
        );
        notifyListeners();
        //return;
      }
      final response = await _cloudRepositoryImpl.login(
        email: email,
        password: password,
      );

      if (response.errorMessage != null) {
        if (response.errorMessage!.isNotEmpty) {
          _state = _state.copyWith(
            errorMessage: response.errorMessage,
            isLoginInline: false,
          );
          notifyListeners();
          return;
        }
      }
      _state = _state.copyWith(isLoginInline: true);

      ref
          .read(settingProvider.notifier)
          .toggleMessage('De nuevo la session esta activa 👌');
      await Future.delayed(Duration(seconds: 3), () {
        ref.read(settingProvider.notifier).toggleMessage('');
      });
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  void logout() async {
    try {
      await _cloudRepositoryImpl.logout();
      _state = _state.copyWith(isLoginInline: false, errorMessage: '');
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  Future<void> getUser() async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      final user = await _localRepositoryImpl.getUser('key');
      _state = _state.copyWith(
        status: UserStatus.success,
        errorMessage: null,
        user: user,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      final hasInternet = ref
          .read(connectionProvider)
          .maybeWhen(data: (has) => has, orElse: () => false);

      if (hasInternet) {
        await _cloudRepositoryImpl.updateUser(user, '');
      }

      final userUpdate = await _localRepositoryImpl.updateUser(user, '');
      _state = _state.copyWith(
        status: UserStatus.success,
        errorMessage: null,
        user: userUpdate,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      await _localRepositoryImpl.deleteUser('key');
      _state = _state.copyWith(
        user: User(
          firstName: '',
          lastName: '',
          password: '',
          email: '',
          itIsRegisterOnline: false,
          photo: null,
        ),
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }
}

final userProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier(ref: ref)..getUser();
});
