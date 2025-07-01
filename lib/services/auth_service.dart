import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role, // "patient" or "dentist"
  }) async {
    UserCredential userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCred.user!.uid;
    final data = {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection(role == 'patient' ? 'patients' : 'dentists')
        .doc(uid)
        .set(data);
  }

  Future<String?> loginAndGetRole(String email, String password) async {
    UserCredential userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = userCred.user!.uid;

    // Check in both collections
    var patientDoc = await _firestore.collection('patients').doc(uid).get();
    if (patientDoc.exists) return 'patient';

    var dentistDoc = await _firestore.collection('dentists').doc(uid).get();
    if (dentistDoc.exists) return 'dentist';

    return null; // Not found
  }
}
