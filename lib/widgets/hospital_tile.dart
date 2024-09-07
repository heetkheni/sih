import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sih_practice/shared/color.dart'; // Assuming this file holds color constants like primaryColor and buttonColor

class HospitalTile extends StatefulWidget {
  final String hospitalId;
  final String hospitalName;
  final String address;
  final String contact;
  final String mail;
  final VoidCallback onTap;

  const HospitalTile({
    Key? key,
    required this.hospitalId,
    required this.hospitalName,
    required this.address,
    required this.contact,
    required this.mail, required this.onTap,
  }) : super(key: key);

  @override
  _HospitalTileState createState() => _HospitalTileState();
}

class _HospitalTileState extends State<HospitalTile> {
  int availableBeds = 0;

  @override
  void initState() {
    super.initState();
    _getAvailableBeds();
  }

  // Fetch the number of available beds from Firestore
  Future<void> _getAvailableBeds() async {
    QuerySnapshot bedSnapshot = await FirebaseFirestore.instance
        .collection('beds')
        .where('hospital_id', isEqualTo: widget.hospitalId)
        .where('status', isEqualTo: 'available')
        .get();

    setState(() {
      availableBeds = bedSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          onTap: widget.onTap,
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
                  // Hospital Name with a bold style
                  Text(
                    widget.hospitalName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Hospital Address
                  Text(
                    widget.address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Contact Information
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.white.withOpacity(0.7)),
                      SizedBox(width: 8),
                      Text(
                        'Contact: ${widget.contact}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.white.withOpacity(0.7)),
                      SizedBox(width: 8),
                      Text(
                        'Email: ${widget.mail}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Available Beds and Contact Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Available Bed Count
                      Container(
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade400,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "$availableBeds Available Beds",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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
                        onPressed: () {
                          // Add your contact logic here
                        },
                        icon: Icon(Icons.contact_phone, color: Colors.white),
                        label: Text(
                          "Contact",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
