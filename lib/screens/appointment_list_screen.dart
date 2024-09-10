// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sih_practice/screens/appointment_add_screen.dart';

// class AppointmentListScreen extends StatefulWidget {
//   @override
//   _AppointmentListScreenState createState() => _AppointmentListScreenState();
// }

// class _AppointmentListScreenState extends State<AppointmentListScreen> {
//   late CollectionReference appointmentRef;
//   late String currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize appointmentRef to the "appointments" collection
//     appointmentRef = FirebaseFirestore.instance.collection('appointments');
//     // Fetch current user ID from FirebaseAuth
//     currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Appointments"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => AddAppointmentScreen(),
//               //   ),
//               // );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: appointmentRef
//             .where('u_id', isEqualTo: currentUserId)
//             .orderBy('priority', descending: true)
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             final appointments = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: appointments.length,
//               itemBuilder: (context, index) {
//                 final appointment = appointments[index];
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   elevation: 4,
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Patient Name: ${appointment['patient_name'] ?? 'N/A'}',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Status: ${appointment['status'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'Priority: ${appointment['priority'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'Queue Number: ${appointment['queue_number'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Contact: ${appointment['contact_info'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Date: ${appointment['created_at'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Description: ${appointment['description'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Disease: ${appointment['disease'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Email: ${appointment['email'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Hospital ID: ${appointment['hospital_id'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Hospital Name: ${appointment['hospital_name'] ?? 'N/A'}',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sih_practice/widgets/appointment_tile.dart';

class AppointmentListScreen extends StatefulWidget {
  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> with SingleTickerProviderStateMixin {
  late CollectionReference appointmentRef;
  late String currentUserId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    appointmentRef = FirebaseFirestore.instance.collection('appointments');
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        actions: [
          
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(status: 'waiting'),
          _buildAppointmentList(status: 'completed'),
        ],
      ),
    );
  }

  Widget _buildAppointmentList({required String status}) {
  return StreamBuilder(
    stream: appointmentRef
        .where('u_id', isEqualTo: currentUserId)
        .where('status', isEqualTo: status)
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
            return AppointmentTile(
              patientName: appointment['patient_name'] ?? 'N/A',
              status: appointment['status'] ?? 'N/A',
              priority: appointment['priority'] ?? 'N/A',
              queueNumber: appointment['queue_number'] ?? 'N/A',
              contactInfo: appointment['contact_info'] ?? 'N/A',
              date: appointment['created_at'] ?? 'N/A',
              description: appointment['description'] ?? 'N/A',
              disease: appointment['disease'] ?? 'N/A',
              email: appointment['email'] ?? 'N/A',
              hospitalId: appointment['hospital_id'] ?? 'N/A',
              hospitalName: appointment['hospital_name'] ?? 'N/A',
              onTap: () {
                // Pass the appointment details to the PDF generation function
                _generateAppointmentPDF(appointment);
              }, appointmentId: appointment['appointment_id'],
            );
          },
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}


 Future<void> _generateAppointmentPDF(QueryDocumentSnapshot appointment) async {
  final pdf = pw.Document();

  // Safe handling of field types
  String patientName = appointment['patient_name']?.toString() ?? 'N/A';
  String status = appointment['status']?.toString() ?? 'N/A';
  int? priority = appointment['priority'] is String
      ? int.tryParse(appointment['priority']) // Convert from String to int
      : appointment['priority'] as int?;
  int? queueNumber = appointment['queue_number'] is String
      ? int.tryParse(appointment['queue_number']) // Convert from String to int
      : appointment['queue_number'] as int?;
  String contactInfo = appointment['contact_info']?.toString() ?? 'N/A';
  String date = appointment['created_at']?.toString() ?? 'N/A';
  String description = appointment['description']?.toString() ?? 'N/A';
  String disease = appointment['disease']?.toString() ?? 'N/A';
  String email = appointment['email']?.toString() ?? 'N/A';
  String hospitalId = appointment['hospital_id']?.toString() ?? 'N/A';
  String hospitalName = appointment['hospital_name']?.toString() ?? 'N/A';

  // Build the PDF content
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Patient Name: $patientName', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Status: $status'),
            pw.Text('Priority: ${priority?.toString() ?? 'N/A'}'), // Convert int to String
            pw.Text('Queue Number: ${queueNumber?.toString() ?? 'N/A'}'), // Convert int to String
            pw.SizedBox(height: 8),
            pw.Text('Contact: $contactInfo'),
            pw.Text('Date: $date'),
            pw.Text('Description: $description'),
            pw.Text('Disease: $disease'),
            pw.Text('Email: $email'),
            pw.Text('Hospital ID: $hospitalId'),
            pw.Text('Hospital Name: $hospitalName'),
          ],
        );
      },
    ),
  );

  // Show the print preview
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => await pdf.save());
}


}