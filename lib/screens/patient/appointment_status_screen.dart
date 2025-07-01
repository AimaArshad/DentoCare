import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentStatusScreen extends StatelessWidget {
  const AppointmentStatusScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patients Appointment Status',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 6, 62), // Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- this changes the back arrow color to white
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('appointments')
                .orderBy('submittedAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading appointments.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final date = DateFormat(
                'yyyy-MM-dd – kk:mm',
              ).format(DateTime.parse(data['dateTime']));
              final status = data['status'];
              final statusColor = getStatusColor(status);
              final statusIcon = getStatusIcon(status);

              return Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Title
                      Text(
                        data['service'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),

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
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 6),

                      // Appointment Date
                      Text('Date: $date', style: const TextStyle(fontSize: 16)),
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
