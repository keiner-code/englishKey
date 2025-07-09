import 'package:permission_handler/permission_handler.dart';

class PermissionConfig {
  static Future<bool> askStoragePermission() async {
    /*var status = await PermissionConfig.storagePermissionStatus();
    print(status);
    // Si está denegado o nunca se ha pedido, solicita el permiso
    if (status.isDenied || status.isPermanentlyDenied) {
      final granted = await PermissionConfig.askStoragePermission();
      if (!granted) {
        // Puedes mostrar un mensaje al usuario aquí si lo deseas
        return;
      }
      // Vuelve a consultar el estado después de pedir el permiso
      status = await PermissionConfig.storagePermissionStatus();
      print(status);
    } */
    final status = await Permission.storage.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  static Future<PermissionStatus> storagePermissionStatus() async {
    return await Permission.storage.status;
  }

  static Future<bool> askVideoPermission() async {
    final status = await Permission.videos.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }
}
