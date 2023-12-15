import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SpeciesScreenData extends ChangeNotifier {
  bool loading = false;

  void uploadDroneVideo(String projectID) async {
    final operationImageRef = FirebaseStorage.instance
        .ref()
        .child("DroneVideos/${projectID}_____DroneVideo");
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path!);

    try {
      loading = true;
      notifyListeners();
      operationImageRef
          .putFile(file)
          .snapshotEvents
          .listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            // notifyListeners();
            break;
          case TaskState.paused:
            // ...
            break;
          case TaskState.success:
            String link = await operationImageRef.getDownloadURL();
            FirebaseFirestore.instance
                .collection("projects")
                .doc(projectID)
                .update({
              "isSpecies": true,
              "droneVideoLink": link,
            });
            loading = false;
            notifyListeners();
            break;
          case TaskState.canceled:
            loading = false;
            notifyListeners();
            break;
          case TaskState.error:
            loading = false;
            notifyListeners();
            break;
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  SingleChildScrollView speciesScreen(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    final screenSize = MediaQuery.of(context).size;
    if (snapshot!["isSpecies"]) {
      return SingleChildScrollView(
          child: Center(
        child: Text("Hogaya"),
      ));
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Text("Nahi Hua"),
        ),
      );
    }
  }
}
