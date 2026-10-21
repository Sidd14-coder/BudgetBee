import 'package:hive/hive.dart';

/// SAVE USER
void saveUserToHive(String name, String email) {
  var box = Hive.box('userBox');

  box.put('user', {
    "name": name,
    "email": email,
  });
}

/// LOAD USER
Map? getUserFromHive() {
  var box = Hive.box('userBox');
  return box.get('user');
}

/// CLEAR USER (logout ke liye)
void clearUser() {
  var box = Hive.box('userBox');
  box.delete('user');
}
