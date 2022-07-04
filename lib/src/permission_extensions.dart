import 'package:permission_handler/permission_handler.dart';

extension PermissionsExtensions on List<Permission> {
  Future<bool> granted() async {
    bool result = true;
    for (var element in this) {
      result &= await element.isGranted;
    }
    return result;
  }

  Future<bool> revoked() async {
    bool result = false;
    for (var element in this) {
      result &= await element.isDenied || await element.isPermanentlyDenied;
    }
    return result;
  }
}