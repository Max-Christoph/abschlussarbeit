import 'package:mysql1/mysql1.dart';
import '../models/user.dart';

class AuthService {
  String dbUsername;
  String dbPassword;
  String dbAddress;

  AuthService(this.dbUsername, this.dbPassword, this.dbAddress);

  Future<User?> login(String username, String password) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: dbAddress,
        port: 3306,
        user: dbUsername,
        db: 'FoodOrganizer',
        password: dbPassword,
      ));

      var results = await conn.query('SELECT * FROM users WHERE username = ? AND password = ?', [username, password]);

      if (results.isNotEmpty) {
        var row = results.first;
        return User(username: row[1], token: row[2]); // Angenommen, Token ist in der 3. Spalte
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: dbAddress,
        port: 3306,
        user: dbUsername,
        db: 'FoodOrganizer',
        password: dbPassword,
      ));

      var result = await conn.query('INSERT INTO users (username, password) VALUES (?, ?)', [username, password]);

      return result.insertId != null; // Überprüfen, ob der Einfügevorgang erfolgreich war
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
} 