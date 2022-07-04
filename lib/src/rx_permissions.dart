import 'package:rx_permissions/src/dart_language_extension.dart';
import 'package:rx_permissions/src/permission_extensions.dart';
import 'package:rx_permissions/src/rx_permissions_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class RxPermissions extends RxPermissionsInterface {
  // Contains all the current permission requests.
  // Once granted or denied, they are removed from it.
  final Map<Permission, Subject<Permission>> requestStorage = {};
  final BehaviorSubject<List<Permission>> permissionsOfInterestSubject =
      BehaviorSubject<List<Permission>>();

  @override
  List<Permission> get permissionsOfInterest =>
      permissionsOfInterestSubject.value;

  @override
  Stream<List<Permission>> get permissionsOfInterestObservable =>
      permissionsOfInterestSubject.asBroadcastStream();

  @override
  Future<bool> granted(List<Permission> permission) => permission.granted();

  @override
  Future<bool> revoked(List<Permission> permission) => permission.revoked();

  @override
  Stream<List<Permission>> permissions(List<Permission> permissions) {
    final subjects = permissions.map((it) => _requireSubject(it));
    return Rx.combineLatest(
      subjects,
      (List<Permission> value) {
        return <Permission>[].also((it) => it.addAll(value));
      },
    ).doOnListen(
        () => permissionsOfInterestSubject.add(requestStorage.keys.toList()));
  }

  @override
  request(List<Permission> permission) async {
    await permission.request();
    _onResult(permission);
  }

  @override
  requestRevoked(List<Permission> permission) async {
    await openAppSettings();
    invalidateState();
  }

  @override
  void invalidateState() {
    _onResult(permissionsOfInterest);
  }

  void _onResult(List<Permission> permissions) {
    for (var permission in permissions) {
      final subject = requestStorage[permission];
      subject?.let((it) => it.add(permission));
    }
  }

  Subject<Permission> _requireSubject(Permission permission) {
    return requestStorage[permission] ?? _createSubject(permission);
  }

  Subject<Permission> _createSubject(Permission permission) {
    return BehaviorSubject.seeded(permission).also((it) {
      requestStorage[permission] = it;
      permissionsOfInterestSubject.add(requestStorage.keys.toList());
    });
  }
}
