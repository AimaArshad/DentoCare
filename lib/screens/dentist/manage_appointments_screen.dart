import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../login&signUp/portal_choice_screen.dart';

class ManageAppointmentsScreen extends StatelessWidget {
  void _confirmAppointment(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection('appointments').doc(docId).update({
      'status': 'confirmed',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Appointment approved')));
  }

  void _cancelAppointment(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection('appointments').doc(docId).update({
      'status': 'cancelled',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Appointment cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Appointment Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 6, 62), // Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- this changes the back arrow color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to PortalChoiceScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const PortalChoiceScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('appointments')
                .orderBy('submittedAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty)
            return Center(child: Text('No appointments found.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('${data['patientName']} - ${data['service']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text('Dentist: ${data['dentist']}'),
                      Text(
                        'Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.parse(data['dateTime']))}',
                      ),
                      Text(
                        'Status: ${data['status'].toString().toUpperCase()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              data['status'] == 'confirmed'
                                  ? Colors.green
                                  : data['status'] == 'cancelled'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data['status'] == 'pending') ...[
                        ElevatedButton(
                          onPressed: () => _confirmAppointment(context, docId),
                          child: Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _cancelAppointment(context, docId),
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ] else if (data['status'] == 'confirmed') ...[
                        Icon(Icons.check_circle, color: Colors.green),
                      ] else if (data['status'] == 'cancelled') ...[
                        Icon(Icons.cancel, color: Colors.red),
                      ],
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
