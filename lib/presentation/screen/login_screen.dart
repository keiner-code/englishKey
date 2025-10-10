import 'package:englishkey/presentation/providers/user_provider.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:englishkey/presentation/widget/shared/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeTitle = Theme.of(context).textTheme.titleSmall;
    final currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        title: Text(
          'Iniciar Session',
          style: TextStyle(
            color: sizeTitle?.color,
            fontSize: sizeTitle?.fontSize,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text('Bienvenido'),
                  const SizedBox(height: 8),
                  Text('Inicia sesión para continuar'),
                  const SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          textController: _emailController,
                          errorMessage: 'Por favor, ingresa tu correo',
                          hintText: 'Correo electrónico',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          textController: _passwordController,
                          errorMessage: 'Por favor, ingresa tu contraseña',
                          hintText: 'Contraseña',
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref
                                    .read(userProvider.notifier)
                                    .login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                if (currentUser.state.errorMessage.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        currentUser.state.errorMessage,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (currentUser.state.isLoginInline) {
                                  context.go('/');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: const Color(0xFF6A11CB),
                            ),
                            child: const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Text('¿Olvidaste tu contraseña?'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}
