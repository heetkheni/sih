import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih_practice/shared/color.dart';

class AddAppointmentScreen extends StatefulWidget {
  final String hospitalId;
  final String hospitalName;

  AddAppointmentScreen({required this.hospitalId, required this.hospitalName});

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _priority = "normal";
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      final appointmentRef = FirebaseFirestore.instance
          .collection('appointments')
          .doc();  // Create a new document reference with an auto-generated ID

      final appointmentId = appointmentRef.id;

      // Fetch the last queue number for the specific hospital
      final queueNumberSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('h_id', isEqualTo: widget.hospitalId)
          .orderBy('queue_number', descending: true)
          .limit(1)
          .get();
      
      final queueNumber = queueNumberSnapshot.docs.isEmpty
          ? 1
          : (queueNumberSnapshot.docs.first['queue_number'] as int) + 1;

      // Set priority number based on the priority selected
      final priorityNumber = _priority == 'emergency' ? 1 : 2;

      await appointmentRef.set({
        'appointment_id': appointmentId,
        'patient_name': _patientNameController.text,
        'contact_info': _contactInfoController.text,
        'description': _descriptionController.text,
        'disease': _diseaseController.text,
        'email': _emailController.text,
        'hospital_id': widget.hospitalId,
        'hospital_name': widget.hospitalName,
        'priority': _priority,
        'priority_number': priorityNumber,
        'queue_number': queueNumber,
        'status': 'waiting',
        'created_at': DateTime.now().toIso8601String(),
        'appointment_date': _selectedDate?.toIso8601String(), // Add the date
      });

       final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.update({
        'appointments': FieldValue.arrayUnion([appointmentId]),
      });
    }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Appointment"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _patientNameController,
                labelText: "Patient Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the patient's name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _contactInfoController,
                labelText: "Contact Info",
                icon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the contact info";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _descriptionController,
                labelText: "Description",
                icon: Icons.description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _diseaseController,
                labelText: "Disease",
                icon: Icons.medical_services,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the disease";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _emailController,
                labelText: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _dateController,
                    labelText: "Appointment Date",
                    icon: Icons.calendar_today,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a date";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildDropdownField(
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
                labelText: "Priority",
              ),
              SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: _addAppointment,
                icon: Icon(Icons.add),
                label: Text("Add Appointment"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required String labelText,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.priority_high, color: Colors.teal),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
