import 'package:permission_handler/permission_handler.dart';

abstract class RxPermissionsInterface {
  // A list of all recent permissions that have been requested
  List<Permission> get permissionsOfInterest;
  // An Observable stream that emits all recent requested permissions
  Stream<List<Permission>> get permissionsOfInterestObservable;
  // Returns an observable data source which returns the status changes via the specified permissions.
  Stream<List<Permission>> permissions(List<Permission> permissions);
  // Requests permissions to be granted to this application.
  request(List<Permission> permission);
  // Requests permissions to be granted manuel by the user in the app settings.
  requestRevoked(List<Permission> permission);
  // Whether the permission has been granted or not
  Future<bool> granted(List<Permission> permission);
  // Whether the permission has been revoked or not
  Future<bool> revoked(List<Permission> permission);
  // invalidate the internal state
  void invalidateState();
}
