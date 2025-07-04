import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dentocare/screens/authentication/login_screen.dart';

class ManageAppointmentsScreen extends StatefulWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  State<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState extends State<ManageAppointmentsScreen> {
  String? currentUid;
  String? userRole;
  String? userName;
  String? _selectedStatus; // For filtering: 'pending', 'approved', 'rejected'
  //DateTime? _selectedDate; // For date filtering

  @override
  void initState() {
    super.initState();
    fetchCurrentUserInfo();
  }

  Future<void> fetchCurrentUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: user.uid)
              .limit(1)
              .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        setState(() {
          currentUid = userData['uid'];
          userRole = userData['role'];
          userName = userData['name'];
        });
      }
    }
  }

  /// Firestore stream based on role
  Stream<QuerySnapshot> getAppointmentsStream() {
    // if (userRole == 'patient') {
    //   return FirebaseFirestore.instance
    //       .collection('appointments')
    //       .where('patientUID', isEqualTo: currentUid)
    //       .orderBy('submittedAt', descending: true)
    //       .snapshots();
    // } else

    // if (userRole == 'dentist') {
    //   return FirebaseFirestore.instance
    //       .collection('appointments')
    //       .where('dentistUID', isEqualTo: currentUid)
    //       .orderBy('submittedAt', descending: true)
    //       .snapshots();
    // }
    // else {
    //   return const Stream.empty();
    // }

    Query query = FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('submittedAt', descending: true);

    if (userRole == 'patient') {
      query = query.where('patientUID', isEqualTo: currentUid);
    } else if (userRole == 'dentist') {
      query = query.where('dentistUID', isEqualTo: currentUid);
    }

    // Apply status filter
    if (_selectedStatus != null) {
      query = query.where('status', isEqualTo: _selectedStatus);
    }
    return query.snapshots();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_top;
    }
  }

  /// 🔁 Action functions
  void _approveAppointment(String docId) {
    FirebaseFirestore.instance.collection('appointments').doc(docId).update({
      'status': 'approved',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Appointment approved')));
  }

  void _rejectAppointment(String docId) {
    FirebaseFirestore.instance.collection('appointments').doc(docId).update({
      'status': 'rejected',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Appointment cancelled')));
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
                color: Color.fromARGB(255, 4, 6, 62),
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
                  backgroundColor: const Color.fromARGB(255, 4, 6, 62),
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

    if (confirmed == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userName == null
              ? 'Dentist Portal '
              : 'Dentist Portal : Welcome ${userName![0].toUpperCase()}${userName!.substring(1)}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 6, 62),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Status Filter Dropdown
          DropdownButton<String>(
            dropdownColor: const Color.fromARGB(255, 4, 6, 62),
            hint: const Text('Status', style: TextStyle(color: Colors.white)),
            value: _selectedStatus,
            items:
                ['pending', 'approved', 'rejected'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() => _selectedStatus = value);
              print(_selectedStatus);
            },
          ),
          // Date Picker
          // IconButton(
          //   icon: const Icon(Icons.calendar_today, color: Colors.white),
          //   onPressed: () async {
          //     final pickedDate = await showDatePicker(
          //       context: context,
          //       initialDate: DateTime.now(),
          //       firstDate: DateTime(2020),
          //       lastDate: DateTime(2030),
          //     );
          //     if (pickedDate != null) {
          //       setState(() => _selectedDate = pickedDate);
          //     }
          //   },
          // ),
          // Clear Filters
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                //  _selectedDate = null;
              });
            },
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body:
          currentUid == null || userRole == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                stream: getAppointmentsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    print('StackTrace: ${snapshot.stackTrace}');
                    return Center(
                      child: Text(
                        'Error loading appointments: ${snapshot.error}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 70, 15, 11),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            color: Colors.grey[400],
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No appointments found.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final docId = docs[index].id;
                      final date = DateFormat(
                        'yyyy-MM-dd',
                      ).format(DateTime.parse(data['dateTime']));
                      final time = DateFormat(
                        'hh:mm a',
                      ).format(DateTime.parse(data['dateTime']));
                      final status = data['status'];
                      final statusColor = getStatusColor(status);
                      final statusIcon = getStatusIcon(status);

                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: // Service Title
                                        Text(
                                      data['service'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),

                                  // ✅ Show Approve/Cancel buttons if dentist and pending
                                  if (userRole == 'dentist' &&
                                      status.toLowerCase() == 'pending') ...[
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed:
                                              () => _approveAppointment(docId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  27,
                                                  105,
                                                  30,
                                                ),
                                            foregroundColor:
                                                Colors
                                                    .white, // <-- This sets the text color to white
                                          ),
                                          child: const Text('Approve'),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed:
                                              () => _rejectAppointment(docId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  255,
                                                  94,
                                                  25,
                                                  21,
                                                ),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 10),
                              //  const SizedBox(height: 10),

                              // Patient Name
                              Text(
                                'Patient: ${data['patientName']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Dentist Name
                              Text(
                                'Dentist: ${data['dentist']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Appointment Date
                              Text(
                                'Date: $date at $time',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),

                              // Status with Icon
                              Row(
                                children: [
                                  Icon(statusIcon, color: statusColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Status: ${status.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}













// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../login&signUp/portal_choice_screen.dart';

// class ManageAppointmentsScreen extends StatelessWidget {
//   void _confirmAppointment(BuildContext context, String docId) {
//     FirebaseFirestore.instance.collection('appointments').doc(docId).update({
//       'status': 'confirmed',
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Appointment approved')));
//   }

//   void _cancelAppointment(BuildContext context, String docId) {
//     FirebaseFirestore.instance.collection('appointments').doc(docId).update({
//       'status': 'cancelled',
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Appointment cancelled')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return Scaffold(body: Center(child: Text("Unauthorized access")));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Doctor Appointment Requests',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 4, 6, 62),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => const PortalChoiceScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance
//                 .collection('appointments')
//                 .where('dentistUID', isEqualTo: currentUser.uid)
//                 .orderBy('submittedAt', descending: true)
//                 .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final docs = snapshot.data!.docs;

//           if (docs.isEmpty)
//             return Center(child: Text('No appointments found.'));

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               final docId = docs[index].id;
//               final date = DateFormat(
//                 'yyyy-MM-dd – kk:mm',
//               ).format(DateTime.parse(data['dateTime']));

//               return Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: ListTile(
//                   title: Text('${data['patientName']} - ${data['service']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 4),
//                       Text('Dentist: ${data['dentist']}'),
//                       Text('Time: ${date}'),
//                       Text(
//                         'Status: ${data['status'].toString().toUpperCase()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color:
//                               data['status'] == 'confirmed'
//                                   ? Colors.green
//                                   : data['status'] == 'cancelled'
//                                   ? Colors.red
//                                   : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (data['status'] == 'pending') ...[
//                         ElevatedButton(
//                           onPressed: () => _confirmAppointment(context, docId),
//                           child: Text('Approve'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         ElevatedButton(
//                           onPressed: () => _cancelAppointment(context, docId),
//                           child: Text('Cancel'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                         ),
//                       ] else if (data['status'] == 'confirmed') ...[
//                         Icon(Icons.check_circle, color: Colors.green),
//                       ] else if (data['status'] == 'cancelled') ...[
//                         Icon(Icons.cancel, color: Colors.red),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }























// ...................before flutter authentication 






























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// import '../login&signUp/portal_choice_screen.dart';

// class ManageAppointmentsScreen extends StatelessWidget {
//   void _confirmAppointment(BuildContext context, String docId) {
//     FirebaseFirestore.instance.collection('appointments').doc(docId).update({
//       'status': 'confirmed',
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Appointment approved')));
//   }

//   void _cancelAppointment(BuildContext context, String docId) {
//     FirebaseFirestore.instance.collection('appointments').doc(docId).update({
//       'status': 'cancelled',
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Appointment cancelled')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Doctor Appointment Requests',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color.fromARGB(255, 4, 6, 62), // Colors.teal,
//         iconTheme: const IconThemeData(
//           color: Colors.white, // <-- this changes the back arrow color to white
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Navigate to PortalChoiceScreen
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => const PortalChoiceScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance
//                 .collection('appointments')
//                 .orderBy('submittedAt', descending: true)
//                 .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final docs = snapshot.data!.docs;

//           if (docs.isEmpty)
//             return Center(child: Text('No appointments found.'));

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               final docId = docs[index].id;

//               return Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: ListTile(
//                   title: Text('${data['patientName']} - ${data['service']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 4),
//                       Text('Dentist: ${data['dentist']}'),
//                       Text(
//                         'Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.parse(data['dateTime']))}',
//                       ),
//                       Text(
//                         'Status: ${data['status'].toString().toUpperCase()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color:
//                               data['status'] == 'confirmed'
//                                   ? Colors.green
//                                   : data['status'] == 'cancelled'
//                                   ? Colors.red
//                                   : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (data['status'] == 'pending') ...[
//                         ElevatedButton(
//                           onPressed: () => _confirmAppointment(context, docId),
//                           child: Text('Approve'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         ElevatedButton(
//                           onPressed: () => _cancelAppointment(context, docId),
//                           child: Text('Cancel'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                         ),
//                       ] else if (data['status'] == 'confirmed') ...[
//                         Icon(Icons.check_circle, color: Colors.green),
//                       ] else if (data['status'] == 'cancelled') ...[
//                         Icon(Icons.cancel, color: Colors.red),
//                       ],
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
