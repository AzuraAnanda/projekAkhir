import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();
  final email = _emailController.text.trim();

  final usersBox = Hive.box<UserModel>('users');

  // Cek apakah username sudah ada
  if (usersBox.values.any((user) => user.username == username)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Username already exists"),
        backgroundColor: Colors.redAccent,
      ),
    );
  } else {
    // Tambahkan user baru ke Hive
    final user =
        UserModel(username: username, password: password, email: email);
    await usersBox.add(user);

    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Registration successful! Please login."),
        backgroundColor: Colors.greenAccent,
      ),
    );

    // Arahkan ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7B4397),
                  Color(0xFFDC2430)
                ], // Gradien ungu-merah
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Icon
                  ScaleTransition(
                    scale: _animation,
                    child: const Icon(
                      Icons.person_add,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto', // Gaya font konsisten
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  const Text(
                    "Register to get started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Roboto',
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
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFF7B4397)),
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
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF7B4397)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Email Input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Email",
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF7B4397)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  // Register Button
                  ElevatedButton(
                    onPressed: () => register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7B4397),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.app_registration, color: Color(0xFF7B4397)),
                        SizedBox(width: 8),
                        Text(
                          "Register",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF7B4397)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Login Redirect
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.white,
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
