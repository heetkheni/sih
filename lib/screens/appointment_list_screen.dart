import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sih_practice/screens/appointment_add_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late CollectionReference appointmentRef;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // Initialize appointmentRef to the "appointments" collection
    appointmentRef = FirebaseFirestore.instance.collection('appointments');
    // Fetch current user ID from FirebaseAuth
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddAppointmentScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: appointmentRef
            .where('u_id', isEqualTo: currentUserId)
            .orderBy('priority', descending: true)
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final appointments = snapshot.data!.docs;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient Name: ${appointment['patient_name'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Status: ${appointment['status'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Priority: ${appointment['priority'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Queue Number: ${appointment['queue_number'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Contact: ${appointment['contact_info'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Date: ${appointment['created_at'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Description: ${appointment['description'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Disease: ${appointment['disease'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Email: ${appointment['email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Hospital ID: ${appointment['hospital_id'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Hospital Name: ${appointment['hospital_name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
