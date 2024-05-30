import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'api.dart' show Api;
import '../user.dart' show UserModel;

class AuthService {
  // Lookup key for local storage/shared preferences
  static const userKey = 'u';
  final Api _api;

  AuthService({required Api api}) : _api = api;

  StreamController<UserModel> _userController = StreamController<UserModel>();

  Stream<UserModel> get user => _userController.stream;

  void getUser() async {
    // Check client for user info.
    // If none, then create an anonymous user.

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(userKey);
    final UserModel user;

    if (userId != null) {
      print('existing user: $userId');
      user = UserModel(id: userId);
    } else {
      final UserModel _user = await _api.createUser();
      prefs.setString(userKey, _user.id!);
      print('new user: ${_user.id}');
      user = _user;
    }

    _userController.add(user);
  }
}
