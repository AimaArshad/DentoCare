import 'package:dentocare/screens/login&signUp/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentocare/screens/login&signUp/portal_choice_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dentocare/screens/authentication/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Make sure you have firebase_core in pubspec.yaml
  runApp(DentoCareApp());
}

class DentoCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Appointments',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginScreen(), //PortalChoiceScreen(), //HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}







/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/patient/appointment_booking_screen.dart';
import 'firebase_options.dart';
import 'screens/dentist/manage_appointments_screen.dart';
import 'screens/login&signUp/login_screen.dart'; // Import your login screen

import 'screens/login&signUp/register_user.dart'; // Import your register user screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Make sure you have firebase_core in pubspec.yaml
  runApp(DentoCareApp());
}

class DentoCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DentoCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: AppointmentBookingScreen(), //LoginScreen() , //  RegisterUserPage()
      //  ManageAppointmentsScreen(), //AddAppointmentScreen(), //ManageAppointmentsScreen(),
      // You can replace this with a role selection or login screen
    );
  }
}
*/

//........................................................................................

/*

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login&signUp/login_screen.dart';
import 'screens/patient/appointment_booking_screen.dart';
import 'firebase_options.dart';
import 'screens/dentist/manage_appointments_screen.dart';
import 'screens/patient/patient_home_screen.dart';
import 'screens/dentist/dentist_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/patientHome': (context) => PatientHomeScreen(),
        '/dentistHome': (context) => DentistHomeScreen(),
      },
    );
  }
}
*/