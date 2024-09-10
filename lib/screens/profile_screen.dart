import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:sih_practice/screens/auth/login_screen.dart';
import 'package:sih_practice/shared/color.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>>? userAppointments;
  String? uid;
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController medicalHistoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      _fetchUserData();
      _fetchUserAppointments();
    } else {
      print("No user is signed in");
    }
  }

  void _fetchUserData() async {
    if (uid != null) {
      DatabaseServices databaseServices = DatabaseServices(uid: uid);
      Map<String, dynamic>? data = await databaseServices.getUserData();
      if (data != null) {
        setState(() {
          userData = data;
          _populateControllers();
        });
      }
    }
  }

  void _fetchUserAppointments() async {
    if (uid != null) {
      DatabaseServices databaseServices = DatabaseServices(uid: uid);
      List<Map<String, dynamic>> appointments = await databaseServices.getUserAppointments();
      setState(() {
        userAppointments = appointments;
      });
    }
  }

  void _populateControllers() {
    nameController.text = userData?['name'] ?? '';
    emailController.text = userData?['email'] ?? '';
    dobController.text = userData?['dob'] ?? '';
    bloodGroupController.text = userData?['blood_group'] ?? '';
    phoneController.text = userData?['phone_no'] ?? '';
    medicalHistoryController.text = userData?['medical_history'] ?? '';
  }

  void _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseServices(uid: uid).userCollectionRef.doc(uid).update({
        'name': nameController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'blood_group': bloodGroupController.text,
        'phone_no': phoneController.text,
        'medical_history': medicalHistoryController.text,
      });
      setState(() {
        isEditing = false;
      });
    }
  }

  void _signOutFunction() async {
    FirebaseAuth.instance.signOut().then((val) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Widget _buildBloodGroupDropdown() {
    List<String> bloodGroups = [
      'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Group',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: buttonColor, // Use buttonColor
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: bloodGroupController.text.isNotEmpty
                  ? bloodGroupController.text
                  : null,
              onChanged: isEditing
                  ? (String? newValue) {
                      setState(() {
                        bloodGroupController.text = newValue ?? '';
                      });
                    }
                  : null,
              items: bloodGroups.map((String bloodGroup) {
                return DropdownMenuItem<String>(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.local_hospital, color: buttonColor), // Use buttonColor
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              hint: Text('Not selected'),
              disabledHint: Text(bloodGroupController.text.isEmpty
                  ? 'Not Provided'
                  : bloodGroupController.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, TextEditingController controller, bool isEditing, TextInputType keyboardType, IconData icon, {bool isDateField = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: buttonColor, // Use buttonColor
              ),
            ),
            SizedBox(height: 8),
            isEditing
                ? GestureDetector(
                    onTap: isDateField
                        ? () {
                            _selectDate(context);
                          }
                        : null,
                    child: AbsorbPointer(
                      absorbing: isDateField,
                      child: TextFormField(
                        controller: controller,
                        keyboardType: keyboardType,
                        decoration: InputDecoration(
                          prefixIcon: Icon(icon, color: buttonColor), // Use buttonColor
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          hintText: isDateField && controller.text.isEmpty
                              ? '(dd-MM-yyyy)'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Icon(icon, color: buttonColor), // Use buttonColor
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.text.isEmpty
                              ? 'Not Provided'
                              : controller.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: primaryColor, // Use primaryColor
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOutFunction,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoCard('Name', nameController, isEditing, TextInputType.text, Icons.person),
            _buildInfoCard('Email', emailController, isEditing, TextInputType.emailAddress, Icons.email),
            _buildInfoCard('Date of Birth', dobController, isEditing, TextInputType.datetime, Icons.calendar_today, isDateField: true),
            _buildBloodGroupDropdown(),
            _buildInfoCard('Phone Number', phoneController, isEditing, TextInputType.phone, Icons.phone),
            _buildInfoCard('Medical History', medicalHistoryController, isEditing, TextInputType.text, Icons.medical_services),
            const SizedBox(height: 15,),
            if (isEditing)
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text('Save Changes',style: TextStyle(color: backgroundColor),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            if (!isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                child: Text('Edit Profile',style: TextStyle(color: backgroundColor),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            SizedBox(height: 20),
          ]
        )
      ),
    );
  }
}


class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});

  final CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference appointmentsCollectionRef = FirebaseFirestore.instance.collection('appointments');

  // Fetch user data
  Future<Map<String, dynamic>?> getUserData() async {
    DocumentSnapshot doc = await userCollectionRef.doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  // Fetch appointments where the user ID matches
  Future<List<Map<String, dynamic>>> getUserAppointments() async {
    QuerySnapshot snapshot = await appointmentsCollectionRef
        .where('u_id', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}