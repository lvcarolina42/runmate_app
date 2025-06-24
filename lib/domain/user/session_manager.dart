import 'package:runmate_app/domain/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal();

  User? currentUser;

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setString('email', user.email);
    await prefs.setString('username', user.username);
    await prefs.setString('fullName', user.name);
    await prefs.setString('birthDate', user.birthDate.toIso8601String());

    await prefs.setInt('xp', 0);
    await prefs.setInt('level', 0);
    await prefs.setInt('nextLevelXp', 0);

    currentUser = user;
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final token = prefs.getString('token');
    final username = prefs.getString('username');
    final expirationStr = prefs.getString('expirationDate');
    final id = prefs.getString('id');
    final fullName = prefs.getString('fullName');
    final birthDate = prefs.getString('birthDate');
    final xp = prefs.getInt('xp');
    final level = prefs.getInt('level');
    final nextLevelXp = prefs.getInt('nextLevelXp');

    if (email != null && token != null && username != null && expirationStr != null) {
      currentUser = User(
        xp: xp ?? 0,
        id: id ?? '',
        email: email,
        level: level ?? 0,
        username: username,
        name: fullName ?? '',
        nextLevelXp: nextLevelXp ?? 0,
        birthDate: DateTime.parse(birthDate!),
      );
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser = null;
  }

  bool get isLoggedIn => currentUser != null;
}
