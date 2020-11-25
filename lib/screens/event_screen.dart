import 'package:events_app_flutter/screens/login_screen.dart';
import 'package:events_app_flutter/shared/authentication.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_flutter/models/event_details.dart';

class EventScreen extends StatelessWidget {
  final Authentication auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              auth.logOut().then((result) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            },
          )
        ],
      ),
      body: EventList(),
    );
  }
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final Firestore db = Firestore.instance;
  List<EventDetail> details = [];

  Future<List<EventDetail>> getDetailsList() async {
    var data = await db.collection("events_details").getDocuments();
    if (data != null) {
      details = data.documents
          .map((document) => EventDetail.fromMap(document))
          .toList();
      int i = 0;
      details.forEach((detail) {
        detail.id = data.documents[i].documentID;
        i++;
      });
    }
    return details;
  }

  @override
  void initState() {
    if (mounted) {
      getDetailsList().then((data) => setState(() {
            details = data;
          }));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: details != null ? details.length : 0,
      itemBuilder: (context, position) {
        String sub =
            'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
        );
      },
    );
  }
}
