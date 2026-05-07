import '../data/models/auth_user.dart';

class SessionController {
  // Padrão Singleton para ter apenas uma instância
  static final SessionController instance = SessionController._();
  SessionController._();

  AuthUser? _user;

  AuthUser? get user => _user;
  String? get token => _user?.accessToken;
  bool get isLoggedIn => _user != null;

  void login(AuthUser user) {
    _user = user;
  }

  void logout() {
    _user = null;
  }
}
