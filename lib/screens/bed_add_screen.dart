import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBedScreen extends StatefulWidget {
  final String hospitalId; // Pass the hospital ID to this screen

  const AddBedScreen({Key? key, required this.hospitalId}) : super(key: key);

  @override
  _AddBedScreenState createState() => _AddBedScreenState();
}

class _AddBedScreenState extends State<AddBedScreen> {
  final TextEditingController bedTypeController = TextEditingController();
  final TextEditingController numberOfBedsController = TextEditingController();
  String? selectedBedType;

  final List<String> bedTypes = [
    'General',
    'Premium',
    'Executive',
    'Two-Sharing',
  ];

  Future<void> addBeds() async {
    final String bedType = selectedBedType!;
    final int numberOfBeds = int.tryParse(numberOfBedsController.text) ?? 0;

    if (numberOfBeds > 0) {
      CollectionReference bedsCollection = FirebaseFirestore.instance
          .collection('hospitals')
          .doc(widget.hospitalId)
          .collection('beds');

      for (int i = 1; i <= numberOfBeds; i++) {
        String bedId = '${bedType.toLowerCase()}${i}'; // Example: general1, premium2
        await bedsCollection.doc(bedId).set({
          'bedid': bedId,
          'bed_type': bedType,
          'status': 'available',
          'allocated_to': null,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      // Clear input fields
      bedTypeController.clear();
      numberOfBedsController.clear();
      setState(() {
        selectedBedType = null;
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('$numberOfBeds $bedType beds added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter a valid number of beds.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Beds'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedBedType,
              hint: Text('Select Bed Type'),
              items: bedTypes.map((String bedType) {
                return DropdownMenuItem<String>(
                  value: bedType,
                  child: Text(bedType),
                );
              }).toList(),
                            onChanged: (String? newValue) {
                setState(() {
                  selectedBedType = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Bed Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: numberOfBedsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Beds',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: addBeds,
              child: Text('Add Beds'),
            ),
          ],
        ),
      ),
    );
  }
}

