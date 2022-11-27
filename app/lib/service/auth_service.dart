import 'dart:convert';
import 'dart:html';

import 'package:aleaves_app/model/user.dart';
import 'package:aleaves_app/service/backend_service.dart';

class AuthService {
  static AuthService? _instance;
  final BackendService _backendService;

  AuthService._internal(this._backendService);

  factory AuthService() {
    if (_instance == null) {
      _instance = AuthService._internal(BackendService());
      return _instance!;
    }
    return _instance!;
  }

  String? _loggedInUserId;

  bool get isUserLoggedIn => _loggedInUserId != null;

  Future<User> attemptLogin(
      {required String email, required String password}) async {
    User loggedInUser = await _sendLoginRequest(email, password);
    _loggedInUserId = loggedInUser.id;
    return loggedInUser;
  }

  Future<User> attemptRegistration(
      {required User user, required String password}) async {
    User newlyRegisteredUser = await _sendRegistrationRequest(user, password);
    _loggedInUserId = newlyRegisteredUser.id;
    return newlyRegisteredUser;
  }

  Future<User> _sendRegistrationRequest(User user, String password) async {
    return User.fromJson(await _backendService.post('/v1/register', {
      'given_name': user.givenName,
      'family_name': user.familyName,
      'email': user.emailAddress,
      'password': password
    }));
  }

  Future<User> _sendLoginRequest(String email, String password) async {
    return User.fromJson(await _backendService
        .post('/v1/login', {'email': email, 'password': password}));
  }
}
