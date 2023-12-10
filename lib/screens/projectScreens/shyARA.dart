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
          preferredSize: const Size.fromHeight(200),
          child: AppBar(
            title: Container(
              height: 200,
              child: const Column(
                children: [
                  Text('ShyARA'),
                  Text('ShyARA'),
                  Text('ShyARA'),
                  Text('ShyARA'),
                  Text('ShyARA')
                ],
              ),
            ),
            bottom: TabBar(
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
            MapScreen(
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
              Center(
                child: Text('Species Content'),
              )
            else
              _disabledTabContent(),
            // Screen 4
            if (isMapDataFulfilled)
              Center(
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
    return Center(
      child: Text('Please .'),
    );
  }
}
