import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_model.dart';
import 'home_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Pastikan box hanya dibuka jika belum dibuka
  await openUserBox();

  // Register adapter jika perlu
  Hive.registerAdapter(UserModelAdapter());

  runApp(MyApp());
}

Future<void> openUserBox() async {
  if (!Hive.isBoxOpen('users')) {
    await Hive.openBox<UserModel>('users');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<bool>(
        future: checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Loading indicator
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error checking login status"),
            );
          } else {
            return snapshot.data == true
                ? HomePage()
                : LoginPage(); // Arahkan ke halaman sesuai status login
          }
        },
      ),
    );
  }

  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Return false jika null
  }
}
