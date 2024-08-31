import 'package:flutter/material.dart';
import 'package:sih_practice/screens/available_bed_screen.dart';
import 'package:sih_practice/screens/home_screen.dart';
import 'package:sih_practice/screens/profile_screen.dart';
import 'package:sih_practice/screens/stock_add_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HospitalListScreen(),
    StockAddScreen(hospitalId: "Kiran Hospital"),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Adjust to your app's color scheme
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}