import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'models/user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _login(BuildContext context) async {
    final box = Hive.box<UserModel>('users');
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final user = box.values.cast<UserModel?>().firstWhere(
          (user) => user?.username == username && user?.password == password,
          orElse: () => null,
        );

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInUser', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal, periksa username dan password.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.deepPurple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _animation,
                    child: Icon(
                      Icons.holiday_village,
                      size: 120,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome to Hogwarts!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your wizard credentials",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.amber.shade200,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Username Input
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person, color: Colors.amber),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.amber),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  ElevatedButton(
                    onPressed: () => _login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
