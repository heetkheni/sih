import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih_practice/services/bed_service.dart';
import 'package:sih_practice/shared/color.dart';

class AvailableBedsScreen extends StatefulWidget {
  final String hospitalId;

  const AvailableBedsScreen({Key? key, required this.hospitalId}) : super(key: key);

  @override
  _AvailableBedsScreenState createState() => _AvailableBedsScreenState();
}

class _AvailableBedsScreenState extends State<AvailableBedsScreen> {
  final BedService _bedService = BedService();
  String _selectedBedType = 'General'; // Default bed type
  List<Map<String, dynamic>> _availableBeds = [];
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadAvailableBeds();
  }

  Future<void> _loadAvailableBeds() async {
    List<Map<String, dynamic>> beds = await _bedService.getAvailableBeds(widget.hospitalId, _selectedBedType);
    setState(() {
      _availableBeds = beds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Beds'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedBedType,
              items: ['General', 'Premium', 'Executive', 'Two-Sharing'].map((String bedType) {
                return DropdownMenuItem<String>(
                  value: bedType,
                  child: Text(bedType),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBedType = newValue!;
                  _loadAvailableBeds();
                });
              },
              decoration: InputDecoration(
                labelText: "Select Bed Type",
                filled: true,
                fillColor: backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _availableBeds.length,
              itemBuilder: (context, index) {
                final bed = _availableBeds[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        'Bed ID: ${bed['bedid']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: buttonColor,
                        ),
                      ),
                      subtitle: Text(
                        'Status: ${bed['status']}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => _bedService.bookBed(widget.hospitalId, bed['bedid'], auth.currentUser!.uid.toString()),
                        icon: Icon(Icons.local_hospital, color: buttonColor),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
