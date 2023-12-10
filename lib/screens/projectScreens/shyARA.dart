import 'package:flutter/material.dart';
import 'package:vanrakshak/screens/projectScreens/enumerationScreen.dart';
import 'package:vanrakshak/screens/projectScreens/satelliteMapping.dart';

class ShyARA extends StatefulWidget {
  const ShyARA({Key? key}) : super(key: key);

  @override
  _ShyARAState createState() => _ShyARAState();
}

class _ShyARAState extends State<ShyARA> {
  bool isMapDataFulfilled = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 200),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 69, 170, 173),
            flexibleSpace: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Project Name",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Project Description",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Project ID",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
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
          children: [
            // Screen 1
            const MapScreen(
              projectID: "projectID",
            ),
            // Screen 2
            EnumerationScreen(
              onDataFulfilled: () {
                setState(() {
                  isMapDataFulfilled = true;
                });
              },
            ),
            // Screen 3
            if (isMapDataFulfilled)
              const Center(
                child: Text('Species Content'),
              )
            else
              _disabledTabContent(),
            // Screen 4
            if (isMapDataFulfilled)
              const Center(
                child: Text('Report Content'),
              )
            else
              _disabledTabContent(),
          ],
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
