import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentBookingScreen extends StatefulWidget {
  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  List<String> _dentistNames = [];
  String? _selectedDentist;
  String? _selectedService;
  DateTime? _selectedDateTime;

  final List<String> _services = [
    'Teeth Cleaning',
    'Root Canal',
    'Braces',
    'Cavity Filling',
    'Tooth Extraction',
  ];

  Future<void> fetchDentistNames() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('dentists')
              .orderBy('createdAt', descending: false)
              .get();

      List<String> names =
          snapshot.docs.map((doc) => doc['name'] as String).toList();

      setState(() {
        _dentistNames = names;
      });
    } catch (e) {
      print('Error fetching dentist names: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDentistNames();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      try {
        await FirebaseFirestore.instance.collection('appointments').add({
          'patientName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'service': _selectedService,
          'dentist': _selectedDentist,
          'dateTime': _selectedDateTime!.toIso8601String(),
          'status': 'pending',
          'submittedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment added successfully'),
            backgroundColor: Colors.teal,
          ),
        );

        _formKey.currentState!.reset();
        setState(() {
          _selectedDateTime = null;
          _selectedService = null;
          _selectedDentist = null;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add appointment'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date == null) return;
    // You can add logic here if you want to restrict available dates/times.
    // For example, you could check if the
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text('Book Appointment', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 4, 6, 62), //Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- this changes the back arrow color to white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter patient name' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedService,
                      decoration: InputDecoration(
                        labelText: 'Select Service',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _services
                              .map(
                                (service) => DropdownMenuItem(
                                  value: service,
                                  child: Text(service),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => _selectedService = value);
                      },
                      validator:
                          (value) => value == null ? 'Select a service' : null,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _selectedDentist,
                      decoration: InputDecoration(
                        labelText: 'Select Dentist',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _dentistNames
                              .map(
                                (name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => _selectedDentist = value);
                      },
                      validator:
                          (value) => value == null ? 'Select a dentist' : null,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _pickDateTime,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          _selectedDateTime == null
                              ? 'Pick Appointment Date & Time'
                              : DateFormat(
                                'yyyy-MM-dd – kk:mm',
                              ).format(_selectedDateTime!),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.check, color: Colors.white),
                        // No widget needed here, just the icon and label for the button
                        label: Text(
                          'Confirm Appointment',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 4, 6, 62),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
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
