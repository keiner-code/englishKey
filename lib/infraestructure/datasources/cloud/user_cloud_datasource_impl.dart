import 'package:englishkey/domain/datasources/cloud/user_cloud_datasource.dart';
import 'package:englishkey/domain/entities/user_cloud_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:englishkey/domain/entities/user.dart' as user_entity;
import 'package:logger/logger.dart';

class UserCloudDatasourceImpl extends UserCloudDatasource {
  final Logger _logger = Logger();
  @override
  Future<UserCloudOption> createUser(user_entity.User user) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );
      final userAuth = credential.user;
      if (userAuth != null) {
        await userAuth.updateDisplayName('${user.firstName} ${user.lastName}');
        await userAuth.updatePhotoURL(user.photo);

        await userAuth.reload();

        final updateUser = FirebaseAuth.instance.currentUser!;

        final UserInfo userProviderData = updateUser.providerData[0];

        //await FirebaseAuth.instance.signOut();

        return UserCloudOption(
          user: user_entity.User(
            email: userProviderData.email!,
            firstName: userProviderData.displayName!.split(' ').first,
            lastName: userProviderData.displayName!.split(' ').last,
            photo: userProviderData.photoURL,
            password: '',
          ),
        );
      }
      return UserCloudOption(errorMessage: 'Usuario no creado');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _logger.i('La contraseña proporcionada es demasiado débil');
        return UserCloudOption(
          errorMessage: 'La contraseña proporcionada es demasiado débil',
        );
      }
      if (e.code == 'email-already-in-use') {
        _logger.i('El Email proporcionado ya esta en uso');
        return UserCloudOption(
          errorMessage: 'El Email proporcionado ya esta en uso',
        );
      }

      return UserCloudOption(errorMessage: 'Error al registrar El usuario');
    } catch (e) {
      _logger.e('Error no controlado $e');
      return UserCloudOption(errorMessage: 'Error no controlado $e');
    }
  }

  @override
  Future<UserCloudOption> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserCloudOption(
        user: user_entity.User(
          email: credential.user!.email!,
          firstName: credential.user!.displayName!.split(' ').first,
          lastName: credential.user!.displayName!.split(' ').last,
          password: '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      _logger.i('FirebaseAuthException code: ${e.code}');
      if (e.code == 'invalid-credential') {
        return UserCloudOption(errorMessage: 'Credencial inválida');
      } else if (e.code == 'user-not-found') {
        return UserCloudOption(errorMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return UserCloudOption(
          errorMessage: 'Wrong password provided for that user.',
        );
      } else {
        return UserCloudOption(errorMessage: 'Firebase error: ${e.code}');
      }
    } catch (e) {
      _logger.e('Error no controlado $e');
      return UserCloudOption(errorMessage: 'Error no controlado $e');
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserCloudOption> updateUser(user_entity.User user, String id) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return UserCloudOption(errorMessage: "Usuario no autenticado");
      }

      await currentUser.updateDisplayName('${user.firstName} ${user.lastName}');
      if (user.photo != null) await currentUser.updatePhotoURL(user.photo);

      await currentUser.reload();

      final updateCurrentUser = FirebaseAuth.instance.currentUser;
      if (updateCurrentUser == null) {
        return UserCloudOption(errorMessage: "Usuario no encontrado");
      }

      final updateUser = UserCloudOption(
        user: user_entity.User(
          firstName: updateCurrentUser.displayName!.split(' ').first,
          lastName: updateCurrentUser.displayName!.split(' ').last,
          password: '',
          email: updateCurrentUser.email!,
        ),
      );

      return updateUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _logger.i('La contraseña proporcionada es demasiado débil');
        return UserCloudOption(
          errorMessage: 'La contraseña proporcionada es demasiado débil',
        );
      }
      if (e.code == 'email-already-in-use') {
        _logger.i('El Email proporcionado ya esta en uso');
        return UserCloudOption(
          errorMessage: 'El Email proporcionado ya esta en uso',
        );
      }
      return UserCloudOption(errorMessage: 'Error al registrar El usuario');
    } catch (e) {
      _logger.e('Error no controlado $e');
      return UserCloudOption(errorMessage: 'Error no controlado$e');
    }
  }

  @override
  Future<bool> existEmailToRegister(String email) async {
    throw UnimplementedError();
  }
}
