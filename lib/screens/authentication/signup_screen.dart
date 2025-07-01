import 'package:flutter/material.dart';
//import './services/auth_service.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  SignUpScreen({required this.role});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  final authService = AuthService();

  void signUp() async {
    try {
      await authService.signUp(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        name: nameCtrl.text,
        phone: phoneCtrl.text,
        role: widget.role,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful. Please log in.")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Signup error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.role.capitalize()} Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}
// This extension is used to capitalize the first letter of the role for display purposes.
// It is a simple utility to enhance the user interface by making the role name more readable.