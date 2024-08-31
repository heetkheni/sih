import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});

  final CollectionReference userCollectionRef = FirebaseFirestore.instance.collection('users');

  // Method to save user data in Cloud Firestore
  Future<void> saveUserData(String fullName, String email, String token) async {
    try {
      await userCollectionRef.doc(uid).set({
        'name': fullName,
        'email': email,
        'uid': uid,
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),  // Optional: Add a timestamp of when the user was created
      });
      print("User data successfully saved!");
    } catch (e) {
      print("Failed to save user data: $e");
      // Optionally, handle the error in a way that's appropriate for your app, such as showing a dialog or message to the user.
    }
  }
}
