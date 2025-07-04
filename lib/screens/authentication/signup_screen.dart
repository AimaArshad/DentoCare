import 'package:flutter/material.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("${widget.role.capitalize()} Signup")),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
              child: Text(
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                "${widget.role.capitalize()} Signup",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 15, 100, 90),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              _buildInputField(nameCtrl, "Full Name", Icons.person),
              _buildInputField(phoneCtrl, "Phone", Icons.phone),
              _buildInputField(emailCtrl, "Email", Icons.email),
              _buildInputField(passCtrl, "Password", Icons.lock, obscure: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 100, 90),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
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

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}




// import 'package:flutter/material.dart';
// //import './services/auth_service.dart';
// import '../../services/auth_service.dart';

// class SignUpScreen extends StatefulWidget {
//   final String role;
//   SignUpScreen({required this.role});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();

//   final authService = AuthService();

//   void signUp() async {
//     try {
//       await authService.signUp(
//         email: emailCtrl.text.trim(),
//         password: passCtrl.text,
//         name: nameCtrl.text,
//         phone: phoneCtrl.text,
//         role: widget.role,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Signup successful. Please log in.")),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       print("Signup error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Signup failed: ${e.toString()}")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("${widget.role.capitalize()} Signup")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameCtrl,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: phoneCtrl,
//               decoration: InputDecoration(labelText: "Phone"),
//             ),
//             TextField(
//               controller: emailCtrl,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passCtrl,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
//           ],
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
// }
// // This extension is used to capitalize the first letter of the role for display purposes.
// // It is a simple utility to enhance the user interface by making the role name more readable.