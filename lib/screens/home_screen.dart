import 'package:flutter/material.dart';
import 'package:sih_practice/screens/appointment_list_screen.dart';
import 'package:sih_practice/screens/bed_add_screen.dart';

class HospitalListScreen extends StatelessWidget {
  final List<String> hospitals = ["Kiran Hospital", "Zydus Hospital"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Hospital"),
      ),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(hospitals[index]),
            leading: IconButton(onPressed: (){
              MaterialPageRoute(
                  builder: (context) => AddBedScreen(hospitalId: hospitals[index]),
                );
            }, icon: Icon(Icons.bed)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentListScreen(hospitalId: hospitals[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}