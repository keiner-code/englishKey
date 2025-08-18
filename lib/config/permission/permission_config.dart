import 'package:permission_handler/permission_handler.dart';

class PermissionConfig {
  static Future<bool> askVideoPermission() async {
    final status = await Permission.videos.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  static Future<bool> askImagePermission() async {
    final status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }
}
