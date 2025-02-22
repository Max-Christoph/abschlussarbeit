import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'package:mysql1/mysql1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _dbAddress = '';
  bool _isLoading = false;
  late AuthService _authService;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      _authService = AuthService('your_username', 'your_password', _dbAddress); // Setzen Sie die DB-Anmeldeinformationen
      
      final user = await _authService.login(_username, _password);
      
      setState(() => _isLoading = false);
      
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed')),
          );
        }
      }
    }
  }

  Future<void> _checkDatabaseConnection() async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: _dbAddress,
        port: 3306,
        user: 'your_username', // Setzen Sie den DB-Benutzernamen
        db: 'FoodOrganizer',
        password: 'your_password', // Setzen Sie das DB-Passwort
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database connection successful!')),
      );
      await conn.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the database.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Database Address'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter database address' : null,
                      onChanged: (value) => _dbAddress = value,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _checkDatabaseConnection, // Check connection on press
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter username' : null,
                onChanged: (value) => _username = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter password' : null,
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text('Create Account'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}