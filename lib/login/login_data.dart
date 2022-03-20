import 'package:quiver/core.dart';

class LoginData {
  final String email;
  final String password;

  LoginData({
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return '$runtimeType($email, $password)';
  }

  @override
  bool operator ==(Object other) {
    if (other is LoginData) {
      return email == other.email && password == other.password;
    }
    return false;
  }

  @override
  int get hashCode => hash2(email, password);
}
