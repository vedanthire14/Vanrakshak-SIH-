// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:vanrakshak/resources/mainScreenSetup/mainscreendata.dart';
import 'package:vanrakshak/widgets/appbar/appbar.dart';
import 'package:vanrakshak/widgets/project/newProject.dart';
import 'package:vanrakshak/widgets/project/projectCard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context, <String>[
        'feature1',
        'feature2',
      ]);
    });
  }

  TextEditingController projectName = TextEditingController();
  TextEditingController projectLocation = TextEditingController();
  TextEditingController projectDescription = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDetails() async {
    return db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext original = context;
    MainScreenSetup mainScreenSetup = Provider.of<MainScreenSetup>(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: fetchUserDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 69, 170, 173),
                title: Text('Vanrakshak'),
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
              drawer: MyAppDrawer(),
              backgroundColor: Color.fromARGB(255, 239, 248, 222),
              body: SizedBox(
                height: 0,
                width: 0,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            mainScreenSetup.allProjectsIds = snapshot.data!["projectsID"];
            mainScreenSetup.allProjects = [];
            List<Future<void>> projectFutures = [];

            for (int i = 0; i < mainScreenSetup.allProjectsIds.length; i++) {
              // print(i);
              projectFutures.add(db
                  .collection("projects")
                  .doc(mainScreenSetup.allProjectsIds[i])
                  .get()
                  .then((value) {
                mainScreenSetup.allProjects.add(
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
              }));
            }

            return FutureBuilder<void>(
              future: Future.wait(projectFutures),
              builder:
                  (BuildContext context, AsyncSnapshot<void> projectSnapshot) {
                if (projectSnapshot.connectionState == ConnectionState.done) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173),
                      title: Text('Vanrakshak'),
                      centerTitle: true,
                      actions: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
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
                    drawer: MyAppDrawer(),
                    backgroundColor: Color.fromARGB(255, 239, 248, 222),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 35.0),
                          GestureDetector(
                            onTap: () {
                              _selectTimeSlotBottomSheet(context, 0, original);
                            },
                            child: CreateProjectWid(),
                          ),
                          Column(
                            children: mainScreenSetup.allProjects,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173),
                      title: Text('Vanrakshak'),
                      centerTitle: true,
                      actions: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image(
                                image: AssetImage('assets/main/logo.png')),
                          ),
                        )
                      ],
                    ),
                    drawer: MyAppDrawer(),
                    backgroundColor: Color.fromARGB(255, 239, 248, 222),
                    body: SizedBox(
                      height: 0,
                      width: 0,
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      splashColor: Color.fromARGB(255, 239, 248, 222),
      onTap: onTap,
      child: Card(
        color: Color.fromARGB(183, 235, 255, 243),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: color,
            ),
            SizedBox(height: 12.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectTimeSlotBottomSheet(
      BuildContext context, int index, BuildContext originalContext) async {
    MainScreenSetup mainScreenSetup =
        Provider.of<MainScreenSetup>(context, listen: false);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, //this is for bottam sheet
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/project/projectTile0.png',
                      height: 150)),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: const [10, 2],
                  strokeWidth: 1,
                  child: TextFormField(
                    controller: projectName,
                    decoration: InputDecoration(
                      labelText: 'Project Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add spacing
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: const [10, 2],
                  strokeWidth: 1,
                  child: TextFormField(
                    controller: projectLocation,
                    decoration: InputDecoration(
                      labelText: 'Project Location',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add spacing
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 55,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: const [10, 2],
                  strokeWidth: 1,
                  child: TextFormField(
                    controller: projectDescription,
                    maxLines: 8,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Project Description',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      mainScreenSetup.createNewProject(projectName.text,
                          projectLocation.text, projectDescription.text);
                      Navigator.of(originalContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
