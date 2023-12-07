import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vanrakshak/widgets/project/projectCard.dart';

class MainScreenSetup with ChangeNotifier {
  List<Widget> allProjects = [];
  List<dynamic> allProjectsIds = [];
  final db = FirebaseFirestore.instance;
  final userData = FirebaseAuth.instance.currentUser;
  var uuid = const Uuid();

  void createNewProject(String title, String location, String description) {
    String date = DateTime.now().toString().substring(0, 10);
    allProjects.add(
      ProjectCard(
        title: title,
        location: location,
        date: date,
        progress: 0,
        isMapped: false,
        isEnumerated: false,
        isSpecies: false,
        isReported: false,
      ),
    );
    notifyListeners();
    String newProjectId = uuid.v1();
    allProjectsIds.add(newProjectId);

    db
        .collection("users")
        .doc(userData!.uid)
        .update({"projectsID": allProjectsIds});

    db.collection("projects").doc(newProjectId).set({
      "title": title,
      "location": location,
      "description": description,
      "date": date,
      "progress": 100.0, // 100% hard
      "isMapped": false,
      "isEnumerated": false,
      "isSpecies": false,
      "isReported": false,
      "userId": userData!.uid,
      "map": {
        "coordinatesList": [],
        "centerCoordinate": "",
        "areaAcres": "",
        "areaMeters": "",
        "satelliteImageWithPolygon": "",
        "satelliteImageWithPolygonMasked": "",
        "elevationList": [],
      },
      "enum": {},
      "species": {},
      "report": {},
      "droneVideoLink": "",
    });
    // print(userData!.uid);
  }
}
