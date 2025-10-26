import 'package:englishkey/infraestructure/services/sincronization/note_service_sincronization.dart';
import 'package:englishkey/presentation/providers/connection_provider.dart';
import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishkey/presentation/providers/user_provider.dart';
import 'package:englishkey/domain/entities/user.dart' as user_entity;

class BuildListenerWidget extends ConsumerWidget {
  const BuildListenerWidget({super.key, this.child});

  final Widget? child;

  Future<void> buildShowMessageState(String message, WidgetRef ref) async {
    ref.read(settingProvider.notifier).toggleMessage(message);

    await Future.delayed(const Duration(seconds: 3), () {
      ref.read(settingProvider.notifier).toggleMessage('');
    });
  }

  Widget checkConnectionToInternet(String message, TextStyle? textTheme) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          message.contains('Intentando') || message.contains('Sincronizando')
              ? SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(),
              )
              : SizedBox(),
          Text(
            message,
            style: textTheme!.copyWith(
              color: message.contains('Oops,') ? Colors.red : Colors.blue,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> asyncData(WidgetRef ref) async {
    await NoteServiceSincronization().asyncNotes(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme.titleSmall;
    final connectionAsync = ref.watch(connectionProvider);
    final settingsNotifier = ref.watch(settingProvider);
    final localUser = ref.watch(userProvider);

    ref.listen<AsyncValue<bool>>(connectionProvider, (prev, next) {
      next.when(
        data: (hasInternet) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            //? Validar si hay un usuario registrado local
            final user = localUser.state.user;
            if (user == null) {
              await buildShowMessageState("Por favor Registrarse", ref);
              return;
            }
            if (user.email.isEmpty) {
              await buildShowMessageState("Por favor Registrarse", ref);
              return;
            }

            await buildShowMessageState(
              hasInternet
                  ? "¡Estás conectado a Internet! 🎉"
                  : "Oops, no tienes conexión a internet. 😢",
              ref,
            );

            //? Validar si tiene conexion de internet
            if (hasInternet) {
              final currentUser = FirebaseAuth.instance.currentUser;

              //? Validar si el usuario tiene una session activa
              if (currentUser != null) {
                ref.read(userProvider.notifier).isLoginToggleInline(true);
                await buildShowMessageState("La session esta activa 👌", ref);
                //? Sincronization
                await asyncData(ref);
                await buildShowMessageState("Sincronizando los datos", ref);
                return;
              }

              await buildShowMessageState(
                "Oops, no has iniciado session en linea",
                ref,
              );

              await buildShowMessageState("Intentando iniciar session", ref);
              //?Iniciar session
              await ref
                  .read(userProvider.notifier)
                  .login(user.email, user.password);

              if (localUser.state.errorMessage.isEmpty) {
                await buildShowMessageState('Session iniciada 👍', ref);
                //? Sincronization
                await buildShowMessageState("Sincronizando los datos", ref);
                await asyncData(ref);
                return;
              }

              await buildShowMessageState(localUser.state.errorMessage, ref);

              await buildShowMessageState(
                "💪 Intentando registrar el usuario",
                ref,
              );
              //? Registrarse
              await ref
                  .read(userProvider)
                  .addUser(
                    user_entity.User(
                      email: user.email,
                      password: user.password,
                      firstName: user.firstName,
                      lastName: user.lastName,
                    ),
                  );

              //? Validar el estado de registrado
              if (localUser.state.errorMessage.isEmpty) {
                await buildShowMessageState(
                  'Usuario registrado en la nube 😊',
                  ref,
                );
                //? Sincronization
                await buildShowMessageState("Sincronizando los datos", ref);
                await asyncData(ref);
                return;
              }
              await buildShowMessageState(localUser.state.errorMessage, ref);
            }
          });
        },
        loading: () {},
        error: (_, __) {},
      );
    });

    return Stack(
      children: [
        child!,
        connectionAsync.when(
          data: (_) => const SizedBox(),
          loading:
              () => Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Center(
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        if (settingsNotifier.messageToInternet.isNotEmpty)
          checkConnectionToInternet(
            settingsNotifier.messageToInternet,
            textTheme,
          ),
      ],
    );
  }
}
