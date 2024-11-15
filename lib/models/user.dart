import 'package:rg_mana/utils/user_role.dart';

class User {
  final String username;
  final String email;
  final UserRole role;

  User({
    required this.username,
    required this.email,
    required this.role,
  });

  bool canEdit() => UserPermissions.canEdit(role);
  bool canDelete() => UserPermissions.canDelete(role);
  bool canView() => UserPermissions.canView(role);
}
