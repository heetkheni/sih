import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sih_practice/screens/appointment_add_screen.dart';
import 'package:sih_practice/screens/bed_add_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  final String hospitalId;

  AppointmentListScreen({required this.hospitalId});

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late CollectionReference appointmentRef;

  @override
  void initState() {
    super.initState();
    appointmentRef = FirebaseFirestore.instance
        .collection('hospitals')
        .doc(widget.hospitalId)
        .collection('appointments');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.hospitalId} Appointments"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAppointmentScreen(hospitalId: widget.hospitalId),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.bed),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBedScreen(hospitalId: widget.hospitalId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: appointmentRef
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
                return ListTile(
                  title: Text(appointment['patient_name']),
                  subtitle: Text(
                      "Status: ${appointment['status']} - Priority: ${appointment['priority']}"),
                  trailing: Text("Queue #: ${appointment['queue_number']}"),
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