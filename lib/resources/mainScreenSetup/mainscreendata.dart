import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vanrakshak/ChatbotScreen/ChatBot.dart';
import 'package:vanrakshak/screens/projectScreens/projectMainScreen.dart';
import 'package:vanrakshak/widgets/appbar/appbar.dart';
import 'package:vanrakshak/widgets/project/newProject.dart';
import 'package:vanrakshak/widgets/project/projectCard.dart';

class MainScreenSetup with ChangeNotifier {
  List<Widget> allProjects = [];
  List<dynamic> allProjectsIds = [];
  final db = FirebaseFirestore.instance;
  User? userData = FirebaseAuth.instance.currentUser;
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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"projectsID": allProjectsIds});

    db.collection("projects").doc(newProjectId).set({
      "title": title,
      "location": location,
      "description": description,
      "date": date,
      "progress": 0.0,
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
      "enum": {
        "treeCount": 0,
        "enumeratedImage": "",
      },
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
            floatingActionButton: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 69, 170, 173),
                onPressed: () {}),
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
          List<String> check = [];

          for (int i = 0; i < allProjectsIds.length; i++) {
            projectFutures.add(
              db.collection("projects").doc(allProjectsIds[i]).get().then(
                (value) {
                  if (!check.contains(allProjectsIds[i])) {
                    check.add(allProjectsIds[i]);
                    allProjects.add(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectMainScreen(
                                  projectID: allProjectsIds[i]),
                            ),
                          );
                        },
                        child: ProjectCard(
                          title: value.data()!["title"],
                          location: value.data()!["location"],
                          date: value.data()!["date"],
                          progress: double.parse(
                              value.data()!["progress"].toString()),
                          isMapped: value.data()!["isMapped"],
                          isEnumerated: value.data()!["isEnumerated"],
                          isSpecies: value.data()!["isSpecies"],
                          isReported: value.data()!["isReported"],
                        ),
                      ),
                    );
                  }
                },
              ),
            );

            // print(i);
          }

          return FutureBuilder<void>(
            future: Future.wait(projectFutures),
            builder:
                (BuildContext context, AsyncSnapshot<void> projectSnapshot) {
              if (projectSnapshot.connectionState == ConnectionState.done) {
                if (allProjects.length == 2 * allProjectsIds.length) {
                  allProjects = allProjects.sublist(0, allProjects.length ~/ 2);
                }
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Scaffold(
                      // floatingActionButton: CustomFAB(),
                      appBar: AppBar(
                        backgroundColor:
                            const Color.fromARGB(255, 69, 170, 173),
                        title: const Text('Vanrakshak'),
                        centerTitle: true,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: /* Your existing code for profile picture */
                                  Image(
                                      image:
                                          AssetImage('assets/main/logo.png')),
                            ),
                          ),
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
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatBotScreen(),
                              ));
                        },
                        child: Image.asset(
                          'assets/main/bhalu.gif', // Path to your robot GIF file
                          width: 150, // Adjust the size as needed
                          height: 150,
                        ),
                      ),
                    ),
                  ],
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

class CustomFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Robot Icon or Image
          Icon(Icons.android,
              size: 40), // Replace with a custom robot icon or image
          // Text Overlay
          Positioned(
            bottom: 5,
            child: Text(
              "Hi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      // Custom Shape
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
    );
  }
}
