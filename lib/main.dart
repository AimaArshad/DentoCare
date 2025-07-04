import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
//import 'package:dentocare/screens/authentication/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:dentocare/screens/patient/patient_portal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(DentoCareApp());
}

class DentoCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Appointments',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay before navigating to login screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(), // LoginScreen()
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Light teal background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Icon(Icons.medical_services, size: 100, color: Colors.teal[700]),
            const SizedBox(height: 20),
            // App name
            Text(
              'DentoCare',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 40),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[700]!),
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            // Loading text
            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.teal[600]),
            ),
          ],
        ),
      ),
    );
  }
}













// //import 'package:dentocare/screens/login&signUp/login_screen.dart';
// import 'package:flutter/material.dart';
// //import 'package:dentocare/screens/login&signUp/portal_choice_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';
// import 'package:dentocare/screens/authentication/login_screen.dart';
// import 'package:flutter/foundation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   ); // Make sure you have firebase_core in pubspec.yaml

//   if (kIsWeb) {
//     await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//   }

//   runApp(DentoCareApp());
// }

// class DentoCareApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dental Appointments',
//       theme: ThemeData(primarySwatch: Colors.teal),
//       home: LoginScreen(), //PortalChoiceScreen(), //HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }







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