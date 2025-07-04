// import 'package:flutter/material.dart';
// import 'appointment_booking_screen.dart';
// import 'appointment_status_screen.dart';
// import 'package:dentocare/screens/authentication/login_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70), // Increased height
//         child: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           flexibleSpace: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 4, 6, 62),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 0,
//               ), // More vertical padding
//               child: const Text(
//                 "Patient Portal",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: IconButton(
//                 icon: const Icon(Icons.logout, color: Colors.white, size: 26),
//                 onPressed: () async {
//                   final shouldLogout = await showDialog<bool>(
//                     context: context,
//                     builder:
//                         (context) => AlertDialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           title: const Text(
//                             "Confirm Logout",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: const Color.fromARGB(255, 4, 6, 62),
//                               fontSize: 20,
//                             ),
//                           ),
//                           content: const Text(
//                             "Are you sure you want to logout?",
//                           ),
//                           actions: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.grey[700],
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text("Cancel"),
//                               onPressed: () => Navigator.of(context).pop(false),
//                             ),

//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color.fromARGB(
//                                   255,
//                                   4,
//                                   6,
//                                   62,
//                                 ),
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text("Logout"),
//                               onPressed: () => Navigator.of(context).pop(true),
//                             ),
//                           ],
//                         ),
//                   );
//                   if (shouldLogout == true) {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (_) => LoginScreen()),
//                     );
//                   }
//                 },
//                 tooltip: 'Logout',
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Icon(
//                   //   Icons.medical_services,
//                   //   color: Color(0xFF0F645A),
//                   //   size: 32,
//                   // ),
//                   Expanded(
//                     child: Text(
//                       "Dento-Care. Take Your Dental Health Seriously",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: const Color.fromARGB(255, 15, 100, 90),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               _buildPortalButton(
//                 context,
//                 icon: Icons.calendar_today,
//                 label: "Book Appointment",
//                 destination: AppointmentBookingScreen(),
//               ),
//               const SizedBox(height: 20),
//               _buildPortalButton(
//                 context,
//                 icon: Icons.info_outline,
//                 label: "View Appointments",
//                 destination: AppointmentStatusScreen(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPortalButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required Widget destination,
//   }) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click, // Changes cursor on hover
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         child: StatefulBuilder(
//           builder: (context, setState) {
//             bool isHovering = false;
//             return MouseRegion(
//               onEnter: (_) => setState(() => isHovering = true),
//               onExit: (_) => setState(() => isHovering = false),
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       isHovering
//                           ? const Color.fromARGB(255, 5, 52, 47)
//                           : const Color.fromARGB(255, 11, 60, 81),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: isHovering ? 6 : 2,
//                   shadowColor: Colors.black.withOpacity(0.2),
//                 ),
//                 icon: Icon(icon, color: Colors.white),
//                 label: Text(
//                   label,
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => destination),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       // ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'appointment_booking_screen.dart';
import 'appointment_status_screen.dart';
import 'package:dentocare/screens/authentication/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final gradientColors = [
    //   Color.fromARGB(255, 199, 198, 218),
    //   Color(0xFF64B5F6),
    // ]; // Blue gradient

    // final gradientColors = [
    //   Color.fromARGB(255, 29, 142, 102),
    //   Color.fromARGB(255, 10, 158, 146),
    // ]; // Blue gradient

    // final buttonColor = Color.fromARGB(255, 99, 146, 193); // Darker blue
    // final buttonTextColor = Colors.white;
    final buttonColor = Color.fromARGB(255, 12, 92, 87); // Darker blue
    final buttonTextColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Portal', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 4, 6, 62), // Colors.teal,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 26),
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          "Confirm Logout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 4, 6, 62),
                            fontSize: 20,
                          ),
                        ),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                4,
                                6,
                                62,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Logout"),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                );
                if (shouldLogout == true) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              tooltip: 'Logout',
            ),
          ),

          // IconButton(
          //   icon: Icon(Icons.logout, color: Colors.white),
          //   tooltip: 'Logout',
          //   onPressed: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (_) => LoginScreen()),
          //     );
          //   },
          // ),
        ],
      ),
      body: Container(
        color: Colors.teal[50],
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: gradientColors,
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        // width: double.infinity,
        // height: double.infinity,
        child: Center(
          // Add backgroundColor to the parent Container if you want a solid color background.
          // For example:
          child: Container(
            color: Colors.teal[50],
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 10,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Light teal background
                    const Text(
                      'Welcome to Patient Portal',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(
                          255,
                          15,
                          100,
                          90,
                        ), //Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 26,
                      ),

                      label: const Text(
                        'Book an Appointment',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentBookingScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 26,
                      ),
                      label: const Text(
                        'View Appointment Status',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentStatusScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
