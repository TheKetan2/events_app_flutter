import 'package:events_app_flutter/models/favorite.dart';
import 'package:events_app_flutter/screens/login_screen.dart';
import 'package:events_app_flutter/shared/authentication.dart';
import 'package:events_app_flutter/shared/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app_flutter/models/event_details.dart';

class EventScreen extends StatelessWidget {
  final String uid;
  final Authentication auth = Authentication();

  EventScreen({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("from event screen $uid");
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
      body: EventList(
        uid: uid,
      ),
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;

  const EventList({Key key, this.uid}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final Firestore db = Firestore.instance;
  List<EventDetail> details = [];
  List<Favorite> favorites = [];

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
      FireStoreHelper.getUserFavorites(widget.uid).then((data) => {
            setState(() {
              favorites = data;
            })
          });
    }

    // FireStoreHelper.
    super.initState();
  }

  bool isUserFavorite(String eventId) {
    Favorite favorite = favorites.firstWhere(
        (element) => element.eventId == eventId,
        orElse: () => null);
    if (favorite == null)
      return false;
    else
      return true;
  }

  void toggleFavorite(EventDetail ed) async{
 if (isUserFavorite(ed.id)) {
 Favorite favourite = favorites
 .firstWhere((Favorite f) => (f.eventId == ed.id));
 String favId = favourite.eventId;
 await FireStoreHelper.deleteFavorite(favId);
 }
 else {
 await FireStoreHelper.addFavorite(ed, widget.uid);
 }
 List<Favorite> updatedFavourites =
 await FireStoreHelper.getUserFavorites(widget.uid);
 setState(() {
 favorites = updatedFavourites;
 });
 }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: details != null ? details.length : 0,
      itemBuilder: (context, position) {
        Color starColor =
            isUserFavorite(details[position].id) ? Colors.amber : Colors.grey;
        String sub =
            'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
          trailing: IconButton(
            icon: Icon(
              Icons.star,
              color: starColor,
            ),
            onPressed: () {
              toggleFavorite(details[position]);
            },
          ),
        );
      },
    );
  }
}
