import 'package:flutter/foundation.dart' show ChangeNotifier, notifyListeners;

class UserModel extends ChangeNotifier {
  String? id;

  UserModel({this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
      } =>
        UserModel(
          id: name,
        ),
      _ => throw const FormatException('Failed to parse User'),
    };
  }

  void setUser(UserModel user) {
    print('setUser: ${user.id}');
    id = user.id;
    notifyListeners();
  }
}
