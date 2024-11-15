enum UserRole { admin, editor, viewer }

class UserPermissions {
  static bool canEdit(UserRole role) => role == UserRole.admin || role == UserRole.editor;
  static bool canDelete(UserRole role) => role == UserRole.admin;
  static bool canView(UserRole role) => role == UserRole.admin || role == UserRole.editor || role == UserRole.viewer;
}