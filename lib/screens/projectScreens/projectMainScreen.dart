// // ignore_for_file: file_names, library_private_types_in_public_api
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vanrakshak/resources/projectScreens/enumerationScreenData.dart';
// import 'package:vanrakshak/resources/projectScreens/mappingScreenData.dart';
// import 'package:vanrakshak/screens/projectScreens/dashboardScreen.dart';

// class ProjectMainScreen extends StatefulWidget {
//   final String projectID;
//   const ProjectMainScreen({Key? key, required this.projectID})
//       : super(key: key);

//   @override
//   _ProjectMainScreenState createState() => _ProjectMainScreenState();
// }

// class _ProjectMainScreenState extends State<ProjectMainScreen> {
//   bool isMapDataFulfilled = true;
//   bool loading = true;
//   Map<String, dynamic>? projectDetails;
//   @override
//   void initState() {
//     FirebaseFirestore.instance
//         .collection("projects")
//         .doc(widget.projectID)
//         .get()
//         .then((value) {
//       setState(() {
//         projectDetails = value.data();
//         loading = false;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MapScreenData mapScreenData = Provider.of<MapScreenData>(context);
//     EnumScreenData enumScreenData = Provider.of<EnumScreenData>(context);
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 239, 248, 222),
//       body: (loading)
//           ? const Center(
//               child: CircularProgressIndicator(
//                   color: Color.fromARGB(255, 69, 170, 173)),
//             )
//           : DefaultTabController(
//               length: 4,
//               initialIndex: 0,
//               child: Scaffold(
//                 appBar: PreferredSize(
//                   preferredSize: const Size(double.infinity, 170),
//                   child: ClipRRect(
//                     clipBehavior: Clip.hardEdge,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20),
//                     ),
//                     child: AppBar(
//                       elevation: 8,
//                       automaticallyImplyLeading: false,
//                       backgroundColor: const Color.fromARGB(255, 39, 159, 130),
//                       flexibleSpace: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(300),
//                             bottomRight: Radius.circular(30),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15.0, right: 15.0, top: 15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 projectDetails!["title"],
//                                 style: const TextStyle(
//                                   decoration: TextDecoration.underline,
//                                   decorationStyle: TextDecorationStyle.solid,
//                                   decorationColor:
//                                       const Color.fromARGB(255, 239, 248, 222),
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 projectDetails!["location"],
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       const Color.fromARGB(255, 239, 248, 222),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Text(
//                                 "(" + projectDetails!["date"] + ")",
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       const Color.fromARGB(255, 239, 248, 222),
//                                 ),
//                               ),
//                               Divider(
//                                 color: const Color.fromARGB(255, 239, 248, 222),
//                                 thickness: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       bottom: const TabBar(
//                         indicatorColor: Colors.white,
//                         indicatorWeight: 5,
//                         labelColor: Colors.white,
//                         unselectedLabelColor:
//                             const Color.fromARGB(255, 239, 248, 222),
//                         tabs: [
//                           Tab(
//                             text: "Map",
//                           ),
//                           Tab(
//                             text: "Enum",
//                           ),
//                           Tab(
//                             text: "Species",
//                           ),
//                           Tab(
//                             text: "Report",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 body: TabBarView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     (loading)
//                         ? Container()
//                         : mapScreenData.mapPage(
//                             projectDetails, context, widget.projectID),
//                     (loading)
//                         ? Container()
//                         : enumScreenData.enumScreen(
//                             projectDetails, context, widget.projectID),
//                     if (isMapDataFulfilled)
//                       const Center(
//                         child: Text('Species Content'),
//                       )
//                     else
//                       _disabledTabContent(),
//                     if (isMapDataFulfilled)
//                       DashBoardScreen()
//                     else
//                       _disabledTabContent(),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _disabledTabContent() {
//     return const Center(
//       child: Text('Please .'),
//     );
//   }
// }

// ignore_for_file: file_names, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vanrakshak/resources/projectScreens/enumerationScreenData.dart';
import 'package:vanrakshak/resources/projectScreens/mappingScreenData.dart';
import 'package:vanrakshak/screens/projectScreens/dashboardScreen.dart';

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
    EnumScreenData enumScreenData = Provider.of<EnumScreenData>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 248, 222),
      appBar: _buildAppBar(),
      body: (loading)
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 69, 170, 173)))
          : _buildTabController(mapScreenData, enumScreenData),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120), // Increased height
      child: AppBar(
        elevation: 6,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 39, 159, 130),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (projectDetails != null) ...[
                  // Check for null
                  Text(
                    projectDetails!["title"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${projectDetails!["location"]} (${projectDetails!["date"]})",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabController(
      MapScreenData mapScreenData, EnumScreenData enumScreenData) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _buildTabBar(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            (loading)
                ? Container()
                : mapScreenData.mapPage(
                    projectDetails, context, widget.projectID),
            (loading)
                ? Container()
                : enumScreenData.enumScreen(
                    projectDetails, context, widget.projectID),
            isMapDataFulfilled
                ? const Center(child: Text('Species Content'))
                : _disabledTabContent(),
            isMapDataFulfilled ? DashBoardScreen() : _disabledTabContent(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60), // Height of the TabBar
      child: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 239, 248, 222),
        bottom: TabBar(
          indicatorColor: Color.fromARGB(255, 39, 159, 130),
          indicatorWeight: 3,
          labelColor: Color.fromARGB(255, 39, 159, 130),
          unselectedLabelColor: Color.fromARGB(255, 39, 159, 130),
          tabs: [
            Tab(text: "Map"),
            Tab(text: "Enum"),
            Tab(text: "Species"),
            Tab(text: "Report"),
          ],
          labelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _disabledTabContent() {
    return const Center(
      child: Text('This section is currently unavailable.'),
    );
  }
}
