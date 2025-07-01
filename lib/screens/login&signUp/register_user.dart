import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedRole = 'patient'; // default role

  Future<void> registerUser() async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCred.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameController.text,
        'email': emailController.text,
        'role': selectedRole,
        'phone': '', // Add later if needed
      });

      // Navigate based on role
      if (selectedRole == 'patient') {
        Navigator.pushNamed(context, '/patientHome');
      } else {
        Navigator.pushNamed(context, '/dentistHome');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: selectedRole,
              items:
                  ['patient', 'dentist'].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registerUser, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
