import 'package:flutter/foundation.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/firebase/firestore.dart';

import 'package:haja/login/responder.dart';
import 'package:haja/content/users/content.dart';
import 'package:haja/content/todo/content.dart';

class User {
  String name, id, icon, email;
  bool exists;

  User({
    this.name = '',
    this.id = '',
    this.icon = '',
    this.email = '',
    this.exists = true,
  });
}

class UserState extends ChangeNotifier {
  static bool loadMockData = false;
  final int _delayTime = 250;

  User data = User(exists: false);

  UserState() {
    var currentUser = AuthApi.activeUserInformation;

    if (currentUser != null) {
      _login(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        email: currentUser.email ?? '',
        icon: currentUser.photoURL ??
            Constants.liveSvgs + currentUser.uid + '.svg',
      );
      return;
    }

    if (!UserState.loadMockData) return;

    _login(
      name: AppDebugLogin.username,
      email: AppDebugLogin.email,
      id: AppDebugLogin.id,
      icon: AppDebugLogin.icon,
    );
  }

  void _login({
    String id = '',
    String email = '',
    String name = '',
    String icon = AppDebugLogin.icon,
  }) {
    data = User(
      name: name,
      id: id,
      icon: icon,
      email: email,
    );
  }

  void logout() {
    AuthApi.logout();
    data = User(exists: false);
    notify();
  }

  void notify() {
    notifyListeners();
  }

  Future<String?> _waitForResponse(ResponseData response) async {
    while (!response.validated) {
      await Future.delayed(Duration(milliseconds: _delayTime));
    }

    if (response.failure == null) {
      var currentUser = AuthApi.activeUserInformation;

      if (currentUser != null) {
        _login(
          id: currentUser.uid,
          name: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          icon: currentUser.photoURL ??
              Constants.liveSvgs + currentUser.uid + '.svg',
        );
      }
    }

    return response.failure;
  }

  Future<String?> signup({
    String? email,
    String? auth,
  }) async {
    if (email == null) return 'No email provided';
    if (auth == null) return 'No password provided';

    ResponseData response = ResponseData(
      user: email,
      pass: auth,
    );

    AuthApi.createNewUser(response);

    String? result = await _waitForResponse(response);

    if (result == null) {
      FirestoreApi.upload(
        UserContent.fromJson({
          'email': data.email,
        }),
      );
      FirestoreApi.upload(
        TodoContent(
          date: DateTime.now(),
          status: TodoContent.unfinishedStatus,
          color: Constants.toHex(Constants.primaryColorLight),
          title: 'Welcome to Haja! Get started by tapping [+ Add]',
          caption: 'We are glad to help you :)',
          type: TodoContent.typeMessageFromHajaTeam,
          id: '',
        ),
        onComplete: (_) => FirestoreApi.upload(
          TodoContent(
            date: DateTime.now().add(const Duration(days: 365)),
            status: TodoContent.unfinishedStatus,
            color: Constants.toHex(Constants.primaryColorLight),
            title: 'Happy Aniversary!!',
            caption: 'Thanks for using Haja for 1 year :)',
            type: TodoContent.typeMessageFromHajaTeam,
            id: '',
          ),
        ),
      );
    }

    return result;
  }

  Future<String?> provider(String provider) async {
    ResponseData response = ResponseData(
      provider: provider,
    );

    AuthApi.loginWithProvider(response);

    return _waitForResponse(response);
  }

  Future<String?> supply(String? _name, String? _auth) async {
    if (_name == null) return 'No name provided';
    if (_auth == null) return 'No password provided';

    ResponseData response = ResponseData(
      user: _name,
      pass: _auth,
    );

    AuthApi.login(response);

    return _waitForResponse(response);
  }

  Future<String?> recover(String _name) async {
    ResponseData response = ResponseData(
      user: _name,
      pass: '',
    );

    while (!response.validated) {
      await Future.delayed(Duration(milliseconds: _delayTime));
    }

    return response.failure;
  }
}
