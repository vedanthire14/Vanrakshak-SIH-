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
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    MapScreenData mapScreenData = Provider.of<MapScreenData>(context);
    EnumScreenData enumScreenData = Provider.of<EnumScreenData>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: (loading)
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 69, 170, 173)))
            : _buildTabView(mapScreenData, enumScreenData),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
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
                  Text(
                    projectDetails!["title"],
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${projectDetails!["location"]} (${projectDetails!["date"]})",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
                _buildTabBar(),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          // Set the height to zero to remove any default bottom padding or borders
          preferredSize: Size.zero,
          child: Container(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    const double indicatorWidth = 300;
    const double indicatorHeight = 40;
    const double topBottomPadding = (60 - indicatorHeight) / 2;

    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Material(
        type:
            MaterialType.transparency, // Set the material type to transparency
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 239, 248, 222),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: TabBar(
            indicatorColor:
                Colors.transparent, // Set indicator color to transparent
            indicator: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - indicatorWidth) / 8,
              topBottomPadding,
              (MediaQuery.of(context).size.width - indicatorWidth) / 8,
              topBottomPadding,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.teal,
            tabs: const [
              Tab(text: "Map"),
              Tab(text: "Enum"),
              Tab(text: "Species"),
              Tab(text: "Report"),
            ],
            labelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTabView(
      MapScreenData mapScreenData, EnumScreenData enumScreenData) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        (loading)
            ? Container()
            : mapScreenData.mapPage(projectDetails, context, widget.projectID),
        (loading)
            ? Container()
            : enumScreenData.enumScreen(
                projectDetails, context, widget.projectID),
        isMapDataFulfilled
            ? const Center(child: Text('Species Content'))
            : _disabledTabContent(),
        isMapDataFulfilled ? const DashBoardScreen() : _disabledTabContent(),
      ],
    );
  }

  Widget _disabledTabContent() {
    return const Center(
      child: Text('This section is currently unavailable.'),
    );
  }
}
