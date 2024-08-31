
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String hospitalId;

  AddAppointmentScreen({required this.hospitalId});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  String _priority = "normal";

  Future<void> _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      final appointmentRef = FirebaseFirestore.instance
          .collection('hospitals')
          .doc(widget.hospitalId)
          .collection('appointments')
          .doc();

      final appointmentId = appointmentRef.id;

      final queueNumberSnapshot = await FirebaseFirestore.instance
          .collection('hospitals')
          .doc(widget.hospitalId)
          .collection('appointments')
          .get();
      final queueNumber = queueNumberSnapshot.docs.length + 1;

      await appointmentRef.set({
        'appointment_id': appointmentId,
        'patient_name': _patientNameController.text,
        'contact_info': _contactInfoController.text,
        'priority': _priority,
        'queue_number': queueNumber,
        'status': 'waiting',
        'created_at': DateTime.now().toIso8601String(),
      });

      

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Appointment"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(labelText: "Patient Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the patient's name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _contactInfoController,
                decoration: InputDecoration(labelText: "Contact Info"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the contact info";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _priority,
                items: [
                  DropdownMenuItem(child: Text("Normal"), value: "normal"),
                  DropdownMenuItem(child: Text("Emergency"), value: "emergency"),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Priority"),
              ),
              SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: _addAppointment,
                icon: Icon(Icons.add),
                label: Text("Add Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}