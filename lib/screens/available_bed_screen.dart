import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih_practice/services/bed_service.dart';

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
      ),
      body: Column(
        children: [
          DropdownButton<String>(
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _availableBeds.length,
              itemBuilder: (context, index) {
                final bed = _availableBeds[index];
                return ListTile(
                  title: Text('Bed ID: ${bed['bedid']}'),
                  subtitle: Text('Status: ${bed['status']}'),
                  trailing: IconButton(
                    onPressed: () => _bedService.bookBed(widget.hospitalId,bed['bedid'],auth.currentUser!.uid.toString()),
                    icon: Icon(Icons.book),
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
