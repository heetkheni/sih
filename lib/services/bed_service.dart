import 'package:cloud_firestore/cloud_firestore.dart';

class BedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch available beds based on type
  Future<List<Map<String, dynamic>>> getAvailableBeds(String hospitalId, String bedType) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('hospitals')
        .doc(hospitalId)
        .collection('beds')
        .where('bed_type', isEqualTo: bedType)
        .where('status', isEqualTo: 'available')
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Book a bed
  Future<void> bookBed(String hospitalId, String bedId, String userId) async {
    await _firestore
        .collection('hospitals')
        .doc(hospitalId)
        .collection('beds')
        .doc(bedId)
        .update({
          'status': 'occupied',
          'allocated_to': userId,
        });
  }
}
