import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sih_practice/shared/color.dart'; // Assuming this file holds color constants like primaryColor and buttonColor

class AppointmentTile extends StatefulWidget {
  final String appointmentId;
  final String patientName;
  final String status;
  final String priority;
  final int queueNumber;
  final String contactInfo;
  final String date;
  final String description;
  final String disease;
  final String email;
  final String hospitalId;
  final String hospitalName;
  final VoidCallback onTap;

  const AppointmentTile({
    Key? key,
    required this.appointmentId,
    required this.patientName,
    required this.status,
    required this.priority,
    required this.queueNumber,
    required this.contactInfo,
    required this.date,
    required this.description,
    required this.disease,
    required this.email,
    required this.hospitalId,
    required this.hospitalName,
    required this.onTap,
  }) : super(key: key);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.9), primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name with a bold style
                Text(
                  widget.patientName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: buttonColor,
                  ),
                ),
                SizedBox(height: 8),
                // Status and Priority
                Text(
                  'Status: ${widget.status}',
                  style: TextStyle(
                    fontSize: 16,
                    color: buttonColor,
                  ),
                ),
                Text(
                  'Priority: ${widget.priority}',
                  style: TextStyle(
                    fontSize: 16,
                    color: buttonColor,
                  ),
                ),
                SizedBox(height: 12),
                // Queue Number and Date
                Row(
                  children: [
                    Icon(Icons.queue, color: buttonColor),
                    SizedBox(width: 8),
                    Text(
                      'Queue Number: ${widget.queueNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.date_range, color: buttonColor),
                    SizedBox(width: 8),
                    Text(
                      'Date: ${widget.date}',
                      style: TextStyle(
                        fontSize: 16,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Description, Disease, and Email
                Text(
                  'Description: ${widget.description}',
                  style: TextStyle(
                    fontSize: 16,
                    color: buttonColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Disease: ${widget.disease}',
                  style: TextStyle(
                    fontSize: 16,
                    color: buttonColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Email: ${widget.email}',
                  style: TextStyle(
                    fontSize: 16,
                    color: buttonColor,
                  ),
                ),
                SizedBox(height: 20),
                // Contact Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: widget.onTap,
                  
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text(
                    "Generate PDF",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to generate PDF for the appointment
  Future<void> _generatePDF(String appointmentId) async {
    // Implement your PDF generation logic here
    // Example: using the pdf and printing packages as shown previously
  }
}
