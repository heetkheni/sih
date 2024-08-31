import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    labelStyle: TextStyle(
        color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 15),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)),
    // enabledBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: Colors.grey, width: 2)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 14),
      ),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ));
}



