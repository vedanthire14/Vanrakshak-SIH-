import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vanrakshak/widgets/appbar/appbar.dart';
import 'package:vanrakshak/widgets/project/newProject.dart';
import 'package:vanrakshak/widgets/project/projectCard.dart';

class MainScreenSetup with ChangeNotifier {
  List<Widget> allProjects = [];
  List<dynamic> allProjectsIds = [];
  final db = FirebaseFirestore.instance;
  final userData = FirebaseAuth.instance.currentUser;
  var uuid = const Uuid();
  bool loading = false;

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

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDetails() async {
    return db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> userProjects(
      Future Function(
              BuildContext context, int index, BuildContext originalContext)
          selectTimeSlotBottomSheet,
      BuildContext originalContext) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: fetchUserDetails(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 69, 170, 173),
              title: const Text('Vanrakshak'),
              centerTitle: true,
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image(image: AssetImage('assets/main/logo.png')),
                  ),
                )
              ],
            ),
            drawer: const MyAppDrawer(),
            backgroundColor: const Color.fromARGB(255, 239, 248, 222),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          );
        } else if (snapshot.hasError) {
          // print('Error: ${snapshot.error}');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 69, 170, 173),
              title: const Text('Vanrakshak'),
              centerTitle: true,
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image(image: AssetImage('assets/main/logo.png')),
                  ),
                )
              ],
            ),
            drawer: const MyAppDrawer(),
            backgroundColor: const Color.fromARGB(255, 239, 248, 222),
            body: const Center(
              child: Text("Error Occured"),
            ),
          );
        } else {
          allProjectsIds = snapshot.data!["projectsID"];
          allProjects = [];
          List<Future<void>> projectFutures = [];

          for (int i = 0; i < allProjectsIds.length; i++) {
            // print(i);
            projectFutures.add(
              db.collection("projects").doc(allProjectsIds[i]).get().then(
                (value) {
                  allProjects.add(
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ProjectDetailScreen(
                        //       progress: double.parse(
                        //           value.data()!["progress"].toString()),
                        //       projectID: homePageSetup.allProjectsIds[i],
                        //     ),
                        //   ),
                        // );
                      },
                      child: ProjectCard(
                        title: value.data()!["title"],
                        location: value.data()!["location"],
                        date: value.data()!["date"],
                        progress:
                            double.parse(value.data()!["progress"].toString()),
                        isMapped: value.data()!["isMapped"],
                        isEnumerated: value.data()!["isEnumerated"],
                        isSpecies: value.data()!["isSpecies"],
                        isReported: value.data()!["isReported"],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return FutureBuilder<void>(
            future: Future.wait(projectFutures),
            builder:
                (BuildContext context, AsyncSnapshot<void> projectSnapshot) {
              if (projectSnapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 69, 170, 173),
                    title: const Text('Vanrakshak'),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: (snapshot.data!["profilePic"] == "")
                              ? Image.asset('assets/main/logo.png')
                              : Image.network(
                                  snapshot.data!["profilePic"],
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                      )
                    ],
                  ),
                  drawer: const MyAppDrawer(),
                  backgroundColor: const Color.fromARGB(255, 239, 248, 222),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 35.0),
                        GestureDetector(
                          onTap: () {
                            selectTimeSlotBottomSheet(
                                context, 0, originalContext);
                          },
                          child: const CreateProjectWid(),
                        ),
                        Column(
                          children: allProjects,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 69, 170, 173),
                    title: const Text('Vanrakshak'),
                    centerTitle: true,
                    actions: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child:
                              Image(image: AssetImage('assets/main/logo.png')),
                        ),
                      )
                    ],
                  ),
                  drawer: const MyAppDrawer(),
                  backgroundColor: const Color.fromARGB(255, 239, 248, 222),
                  body: const SizedBox(
                    height: 0,
                    width: 0,
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
