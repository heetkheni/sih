import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');
  final DatabaseReference _booksRef =
      FirebaseDatabase.instance.ref().child('items');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId = "uuyBQFeRm4aLJdwmd9p1w72Sj5A3";
  String? userName = "jenish korat";
  String? userEmail = "jenish@gmail.com";

  @override
  void initState() {
    super.initState();
    // _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    User? user = _auth.currentUser;

    if (user != null) {
      userId = user.uid;
      userEmail = user.email;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        userName = userDoc['name'];
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchBorrowedBooks() {
    return _ordersRef
        .orderByChild('userId')
        .equalTo(userId)
        .onValue
        .map((event) {
      List<Map<String, dynamic>> orders = [];
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null && snapshot.value is Map) {
        print('Orders data: ${snapshot.value}');
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          orders.add({
            'isbnId': value['isbnId'],
            'startDate': value['startDate'],
            'endDate': value['endDate'],
            'returnDate': value['returnDate'],
          });
        });
      }
      return orders;
    }).asyncMap((orders) async {
      List<Map<String, dynamic>> books = [];
      for (var order in orders) {
        DataSnapshot bookSnapshot = await _booksRef
            .orderByChild('isbn')
            .equalTo(order['isbnId'])
            .once()
            .then((event) => event.snapshot);

        if (bookSnapshot.value != null && bookSnapshot.value is Map) {
          Map<dynamic, dynamic> values =
              bookSnapshot.value as Map<dynamic, dynamic>;

          // Use the single map value directly
          books.add({
            'title': values['title'],
            'authors': values['authors'] is List
                ? (values['authors'] as List).join(', ')
                : values['authors'] ?? '',
            'thumbnail': values['thumbnail'] ?? '',
            'startDate': order['startDate'],
            'endDate': order['endDate'],
            'returnDate': order['returnDate'],
          });
        } else {
          print('No book found for ISBN: ${order['isbnId']}');
        }
      }
      print('Books: $books');
      return books;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: userId == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.blueGrey[50],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            userName != null && userName!.isNotEmpty
                                ? userName![0].toUpperCase()
                                : '',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              userEmail ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Help and Support'),
                    leading: Icon(Icons.help),
                    onTap: () {
                      // Handle Help and Support action
                    },
                  ),
                  ListTile(
                    title: Text('Terms and Conditions'),
                    leading: Icon(Icons.description),
                    onTap: () {
                      // Handle Terms and Conditions action
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Your Books',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _fetchBorrowedBooks(),
                    builder: (context, snapshot) {
                      print('Snapshot data: ${snapshot.data}');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error fetching data: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No orders yet'));
                      } else {
                        List<Map<String, dynamic>> borrowedBooks =
                            snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: borrowedBooks.length,
                          itemBuilder: (context, index) {
                            final book = borrowedBooks[index];
                            return Card(
                              margin: EdgeInsets.all(8.0),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: book['thumbnail'] != null &&
                                        book['thumbnail'].isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          book['thumbnail'],
                                          width: 80,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Placeholder(
                                        fallbackWidth: 80, fallbackHeight: 120),
                                title: Text(
                                  book['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(book['authors']),
                                    SizedBox(height: 4.0),
                                    Text('Start Date: ${book['startDate']}'),
                                    Text('End Date: ${book['endDate']}'),
                                    book['returnDate'] != null &&
                                            book['returnDate']!.isNotEmpty
                                        ? Text(
                                            'Returned on: ${book['returnDate']}')
                                        : Text('Not Returned'),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
