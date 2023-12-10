// ignore_for_file: file_names, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanrakshak/resources/projectScreens/mappingScreenData.dart';
import 'package:vanrakshak/screens/projectScreens/enumerationScreen.dart';

class ProjectMainScreen extends StatefulWidget {
  final String projectID;
  const ProjectMainScreen({Key? key, required this.projectID})
      : super(key: key);

  @override
  _ProjectMainScreenState createState() => _ProjectMainScreenState();
}

class _ProjectMainScreenState extends State<ProjectMainScreen> {
  bool isMapDataFulfilled = true;
  bool loading = true;
  Map<String, dynamic>? projectDetails;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("projects")
        .doc(widget.projectID)
        .get()
        .then((value) {
      setState(() {
        projectDetails = value.data();
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapScreenData mapScreenData = Provider.of<MapScreenData>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 248, 222),
      body: (loading)
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 69, 170, 173)),
            )
          : DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size(double.infinity, 200),
                  child: AppBar(
                    backgroundColor: const Color.fromARGB(255, 69, 170, 173),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            projectDetails!["title"],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            projectDetails!["description"],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.projectID,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    bottom: const TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 5,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          text: "Map",
                        ),
                        Tab(
                          text: "Enum",
                        ),
                        Tab(
                          text: "Species",
                        ),
                        Tab(
                          text: "Report",
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: (loading)
                      ? []
                      : [
                          (loading)
                              ? Container()
                              : mapScreenData.mapPage(
                                  projectDetails, context, widget.projectID),
                          EnumerationScreen(
                            onDataFulfilled: () {
                              setState(() {
                                isMapDataFulfilled = true;
                              });
                            },
                          ),
                          if (isMapDataFulfilled)
                            const Center(
                              child: Text('Species Content'),
                            )
                          else
                            _disabledTabContent(),
                          if (isMapDataFulfilled)
                            const Center(
                              child: Text('Report Content'),
                            )
                          else
                            _disabledTabContent(),
                        ],
                ),
              ),
            ),
    );
  }

  Widget _disabledTabContent() {
    return const Center(
      child: Text('Please .'),
    );
  }
}
