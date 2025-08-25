import 'dart:io';

import 'package:englishkey/config/permission/permission_config.dart';
import 'package:englishkey/domain/entities/user.dart';
import 'package:englishkey/presentation/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  File? _fileImage;
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = ref.read(userProvider).state;
      if (userState.user != null) {
        _nameController.text = userState.user!.firstName;
        _lastnameController.text = userState.user!.lastName;
        _fileImage = File(userState.user!.photo!);
        _emailController.text = userState.user!.email!;
        setState(() {});
      }
    });
  }

  void selectedImage() async {
    final permisionStatus = await PermissionConfig.askImagePermission();
    if (!permisionStatus) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileImage = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.titleMedium;
    final screen = MediaQuery.of(context).size;
    final userState = ref.watch(userProvider).state;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, size: 30),
                    ),
                    const SizedBox(width: 6),
                    Text('Gestionar usuario', style: theme),
                  ],
                ),
              ),
              Container(
                width: screen.width * 0.9,
                height: screen.height / 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          (userState.user != null &&
                                  userState.user!.photo != null)
                              ? Image.file(
                                File(userState.user!.photo!),
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              )
                              : Center(
                                child: Text(
                                  'No hay usuario configurado',
                                  style: theme,
                                ),
                              ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () => selectedImage(),
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Agrege el nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor agregue el nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Agrege el apellido',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor agregue el apellido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Agrege el correo',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor agregue el correo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (userState.user == null) {
                            ref
                                .read(userProvider.notifier)
                                .addUser(
                                  User(
                                    firstName: _nameController.text,
                                    lastName: _lastnameController.text,
                                    photo: _fileImage!.path,
                                    email: _emailController.text,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Usuario Agregado')),
                            );
                            return;
                          }
                          ref
                              .read(userProvider.notifier)
                              .updateUser(
                                User(
                                  firstName: _nameController.text,
                                  lastName: _lastnameController.text,
                                  photo: _fileImage!.path,
                                  email: _emailController.text,
                                ),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              content: Text('Usuario Actualizado'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        userState.user == null
                            ? 'Agregar el usuario'
                            : 'Actualizar usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
