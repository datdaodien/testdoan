

class CurrentUser {

  static final CurrentUser _singleton = CurrentUser._internal();
  late String uid;

  factory CurrentUser() {
    return _singleton;
  }

  CurrentUser._internal();
}
class UserRole {
  static final UserRole _singleton = UserRole._internal();
  late String role;

  factory UserRole() {
    return _singleton;
  }

  UserRole._internal();
}