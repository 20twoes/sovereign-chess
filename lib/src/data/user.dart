import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import '../user.dart' show UserModel;
import 'common.dart' show baseApiUrl;

const apiUrl = "$baseApiUrl/users";

// Lookup key for local storage/shared preferences
const userKey = 'u';

Future<UserModel> getUser() async {
  // Check client for user info.
  // If none, then create an anonymous user.

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userId = prefs.getString(userKey);
  final user = UserModel();

  if (userId != null) {
    print('existing user: $userId');
    user.id = userId;
  } else {
    final UserModel _user = await createUser();
    prefs.setString(userKey, _user.id!);
    print('new user: ${_user.id}');
    user.id = _user.id;
  }
  return user;
}

Future<UserModel> createUser() async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create user.');
  }
}
