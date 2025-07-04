import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final List<String> approvedDentistEmails = [
    'drRameen@gmail.com',
    'drAyesha@gmail.com',
    'drArshad@gmail.com',
  ];

  //drRameen12 //drAyesha12 //drArshad123
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    if (role == 'dentist' && !approvedDentistEmails.contains(email)) {
      throw Exception("Unauthorized email for dentist registration.");
    }

    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    // Add to users collection
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Also add to dentists collection if dentist
    if (role == 'dentist') {
      await _firestore.collection('dentists').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> loginAndGetRole(String email, String password) async {
    UserCredential userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();

    final role = doc['role'];

    if (role == 'dentist' && !approvedDentistEmails.contains(email)) {
      await _auth.signOut();
      throw Exception("Unauthorized dentist login.");
    }

    return role;
  }

  User? get currentUser => _auth.currentUser;
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   Future<void> signUp({
//     required String email,
//     required String password,
//     required String name,
//     required String phone,
//     required String role, // "patient" or "dentist"
//   }) async {
//     final approvedDentistEmails = ['raheem@gmail.com', 'dr.amir@hospital.com'];
//     // Use 'dentist' for role to match the comment and collection usage
//     if (role == 'dentist' && !approvedDentistEmails.contains(email)) {
//       throw Exception("Unauthorized email for dentist registration.");
//     }

//     UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     await _firestore.collection('users').doc(userCred.user!.uid).set({
//       'uid': userCred.user!.uid,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'role': role,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<String?> loginAndGetRole(String email, String password) async {
//     UserCredential userCred = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     DocumentSnapshot userDoc =
//         await _firestore.collection('users').doc(userCred.user!.uid).get();

//     return userDoc['role'];
//   }

//   User? get currentUser => _auth.currentUser;
// }
