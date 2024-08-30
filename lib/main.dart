import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   Platform.isAndroid
      ? Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCtE-sSxUzNI215kHLeBIyS_5YaG8vTQ8s",
              appId: "1:659896139542:android:f8a966f2da268ec4129a37",
              messagingSenderId: "659896139542",
              projectId: "sihpractice-b1168"))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: const Text("Hello")),
      ),
    ));
  }
}
