import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/main_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pref = await SharedPreferences.getInstance();
  String? username = pref.getString("username");
  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF181818),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFF181818),
          titleTextStyle: TextStyle(fontSize: 20, color: Color(0xFFFFFCFC)),
        ),
      ),
      home: username == null ? WelcomeScreen() : MainScreen(),
    );
  }
}
