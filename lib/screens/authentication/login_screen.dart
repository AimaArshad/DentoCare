import 'package:flutter/material.dart';
import 'package:dentocare/screens/dentist/manage_appointments_screen.dart';
import 'package:dentocare/screens/patient/patient_portal.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart';

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
      String error =
          e.toString().contains("Unauthorized dentist")
              ? "You are not authorized to log in as a dentist."
              : "Login failed. Please check your credentials.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      //PreferredSize(
      // preferredSize: const Size.fromHeight(60),
      //child:
      AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        //backgroundColor: const Color.fromARGB(255, 15, 100, 90),
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0, // No top margin, only horizontal padding
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 15, 100, 90),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 16, // Match Login button's vertical padding
            ),
            child: const Text(
              "Dento-Care",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      //  ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                "Welcome ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 15, 100, 90),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildInputField(emailCtrl, "Email", Icons.email),
              _buildInputField(passCtrl, "Password", Icons.lock, obscure: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 15, 100, 90),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Don't have an account?"),
              //     TextButton(
              //       onPressed: () {
              //         // REMOVE or comment this to disable dentist signup
              //         showDialog(
              //           context: context,
              //           builder:
              //               (_) => AlertDialog(
              //                 title: Text("Sign up as"),
              //                 actions: [
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.pop(context);
              //                       Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                           builder:
              //                               (_) =>
              //                                   SignUpScreen(role: 'patient'),
              //                         ),
              //                       );
              //                     },
              //                     child: Text("Patient"),
              //                   ),
              //                   TextButton(
              //                     onPressed: () {
              //                       Navigator.pop(context);
              //                       Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                           builder:
              //                               (_) =>
              //                                   SignUpScreen(role: 'dentist'),
              //                         ),
              //                       );
              //                     },
              //                     child: Text("Dentist"),
              //                   ),
              //                 ],
              //               ),
              //         );
              //       },
              //       child: Text("Sign Up"),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
                                "Create Account",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 15, 100, 90),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Select your role:",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        15,
                                        100,
                                        90,
                                      ),
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                              actions: [
                                // Patient Button
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        15,
                                        100,
                                        90,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  SignUpScreen(role: 'patient'),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Patient",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Dentist Button with Tooltip
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Tooltip(
                                    message:
                                        "Dentist signup is currently disabled by admin",
                                    preferBelow: true,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Dentist signup is currently disabled by admin",
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Dentist",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 15, 100, 90),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
