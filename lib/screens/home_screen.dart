import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sih_practice/screens/appointment_add_screen.dart';
import 'package:sih_practice/screens/appointment_list_screen.dart';
import 'package:sih_practice/screens/bed_add_screen.dart';
import 'package:sih_practice/shared/color.dart';
import 'package:sih_practice/widgets/hospital_tile.dart';
import 'package:sih_practice/widgets/search_field.dart';

class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a list to hold hospital data
  List<Map<String, dynamic>> hospitals = [];

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  // Fetch hospitals from Firestore
  Future<void> fetchHospitals() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('hospitals').get();
      setState(() {
        hospitals = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_searching, color: buttonColor),
            SizedBox(width: 7),
            Text("Surat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: buttonColor)),
            Icon(Icons.arrow_downward, size: 15, color: buttonColor),
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Container(
                child: ModernSearchField(),
                color: primaryColor,
              ),
              height: 20,
            ),
          ),
          Expanded(
            flex: 9,
            child: hospitals.isEmpty
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
                : ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      // Extract the hospital data
                      final hospital = hospitals[index];
                      return HospitalTile(
                        hospitalName:hospital['name'] ,
                        hospitalId: hospital['h_id'],
                        //name: hospital['name'],
                        contact: hospital['contact'],
                        mail: hospital['email'],
                        address: hospital['address'], 
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddAppointmentScreen(hospitalId: hospital['h_id'], hospitalName: hospital['name'] )));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
