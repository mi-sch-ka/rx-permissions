# rx-permissions
This package provides a reactive cross-platform (iOS, Android) API 
to request and check permissions for the [permission_handler](https://pub.dev/packages/permission_handler) package.

# How to use

Request a subject for the permission you are interested in.
```dart
    List<Permission> requiredPermission = [Permission.camera, Permission.microphone];
    final subject = rx_permissions.permissions(requiredPermission);
```

Once you have received the stream, you can observe it as usual and react to changes.

```dart

 subject.listen((permissionResults) => onPermissionUpdate(permissionResults));

 //...

 void onPermissionUpdate(List<Permission> result) async {
    List<PermissionResult> permissionResults = await Future.wait(result.map((i) async {
      final granted = await i.isGranted;
      final revoked = await i.isPermanentlyDenied;
      return PermissionResult(i, granted, revoked);
    }));
  }

 class PermissionResult {
   final Permission permission;
   final bool granted;
   final bool revoked;

   PermissionResult(this.permission, this.granted, this.revoked);
 }
```

Call the method `request()` to request the required permissions

```dart
  rx_permissions.request(requiredPermission);
```
