import 'package:dentocare/screens/dentist/manage_appointments_screen.dart';
import 'package:dentocare/screens/patient/patient_portal.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart';

import '../patient/patient_portal.dart';
import '../dentist/manage_appointments_screen.dart';
//import '../patient/patient_portal.dart';
//import '../dentist/manage_appointments_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final authService = AuthService();

  void login() async {
    try {
      String? role = await authService.loginAndGetRole(
        emailCtrl.text.trim(),
        passCtrl.text,
      );

      if (role == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else if (role == 'dentist') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ManageAppointmentsScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("No role found for this user.")));
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            ElevatedButton(onPressed: login, child: Text("Login")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // Choose role before signup
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: Text("Sign up as"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => SignUpScreen(role: 'patient'),
                                    ),
                                  );
                                },
                                child: Text("Patient"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => SignUpScreen(role: 'dentist'),
                                    ),
                                  );
                                },
                                child: Text("Dentist"),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
