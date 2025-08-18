import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/infraestructure/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserStatus { initial, loading, success, error }

class UserState {
  final String errorMessage;
  final User? user;
  final UserStatus status;

  UserState({required this.errorMessage, required this.status, this.user});

  UserState copyWith({String? errorMessage, User? user, UserStatus? status}) {
    return UserState(
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}

class UserNotifier extends ChangeNotifier {
  late UserRepositoryImpl _repositoryImpl;
  UserState _state = UserState(errorMessage: '', status: UserStatus.initial);
  UserState get state => _state;

  UserNotifier() {
    _repositoryImpl = UserRepositoryImpl();
  }

  void addUser(User user) async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      _repositoryImpl.saveUser(user);
      _state = _state.copyWith(status: UserStatus.success);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: UserStatus.error,
        errorMessage: 'Error interno $e',
      );
      notifyListeners();
    }
  }

  void getUser() async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      final user = await _repositoryImpl.getUser('key');
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

  void updateUser(User user) async {
    _state = _state.copyWith(status: UserStatus.loading, errorMessage: null);
    notifyListeners();
    try {
      final userUpdate = await _repositoryImpl.updateUser(user, '');
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
}

final userProvider = ChangeNotifierProvider<UserNotifier>((ref) {
  return UserNotifier()..getUser();
});
