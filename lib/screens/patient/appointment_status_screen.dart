import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dentocare/screens/authentication/login_screen.dart';

class AppointmentStatusScreen extends StatefulWidget {
  const AppointmentStatusScreen({super.key});

  @override
  State<AppointmentStatusScreen> createState() =>
      _AppointmentStatusScreenState();
}

class _AppointmentStatusScreenState extends State<AppointmentStatusScreen> {
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

  /// Returns Firestore stream with filters applied
  Stream<QuerySnapshot> getAppointmentsStream() {
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

    // Apply date filter
    // if (_selectedDate != null) {
    //   final startOfDay = DateTime(
    //     _selectedDate!.year,
    //     _selectedDate!.month,
    //     _selectedDate!.day,
    //   );
    //   final endOfDay = startOfDay.add(const Duration(days: 1));
    //   query = query
    //       .where(
    //         'dateTime',
    //         isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
    //       )
    //       .where('dateTime', isLessThan: endOfDay.toIso8601String());
    // }

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

  Future<void> _cancelAppointment(String appointmentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            title: const Text(
              'Cancel Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 137, 23, 23),
              ),
            ),
            content: const Text(
              'Are you sure you want to cancel this appointment?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),

                child: const Text(
                  'KEEP APPOINTMENT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 137, 23, 23),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'CANCEL APPOINTMENT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        setState(() {
          // Show loading indicator if needed
        });

        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .update({'status': 'rejected'});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Appointment cancelled successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to cancel appointment: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 114, 20, 20),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      } finally {
        setState(() {
          // Hide loading indicator if needed
        });
      }
    }
  }
  // Future<void> _cancelAppointment(String appointmentId) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           title: const Text('Cancel Appointment?'),
  //           content: const Text(
  //             'Are you sure you want to cancel this appointment?',
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, false),
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, true),
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //   );

  //   if (confirmed == true) {
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection('appointments')
  //           .doc(appointmentId)
  //           .update({'status': 'rejected'});
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('Appointment cancelled!')));
  //     } catch (e) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  //     }
  //   }
  // }

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
              ? 'User Portal'
              : 'User Portal : Welcome ${userName![0].toUpperCase()}${userName!.substring(1)}',
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
                    return const Center(
                      child: Text('Error loading appointments.'),
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
                          // Text(
                          // 'Try adjusting your filters or check back later.',
                          // style: TextStyle(
                          //   fontSize: 16,
                          //   color: Colors.grey[500],
                          // ),
                          // textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
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
                              // Service Title and Cancel Button Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['service'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  if (userRole == 'patient' &&
                                      status == 'pending')
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          137,
                                          23,
                                          23,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Cancel Appointment'),
                                      onPressed:
                                          () => _cancelAppointment(
                                            docs[index].id,
                                          ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Patient/Dentist Info
                              if (userRole == 'dentist')
                                Text(
                                  'Patient: ${data['patientName']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo,
                                  ),
                                ),
                              if (userRole == 'patient')
                                Text(
                                  'Dentist: ${data['dentist']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 6),
                              // Date & Time
                              Text(
                                'Date: $date at $time',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              // Status Row
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
