import 'package:events_app_flutter/screens/event_screen.dart';
import 'package:events_app_flutter/screens/launch_Screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future testData() async {
    print("hi");
    Firestore db = Firestore.instance;
    var data = await db.collection("events_details").getDocuments();
    var details = data.documents.toList();
    print(details.length);
    details.forEach((element) {
      print("document id ***" + element.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LaunchScreen(),
    );
  }
}
