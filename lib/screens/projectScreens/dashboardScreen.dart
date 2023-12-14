import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vanrakshak/widgets/Dashboard/dashBoardDetailCard.dart';
import 'package:vanrakshak/widgets/Dashboard/areaCoordinateCard.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final String predefinedProjectName = "Vanrakshak";
  final String predefinedLocation = "Hyderabad";
  final String predefinedState = "Telangana";
  final String areaOfMarkedRegion = "12345";
  final List<String> polygonCoordinates = ["12345", "12345", "12345", "12345"];
  final Color Bgcolor = Color.fromARGB(255, 39, 159, 130);
  final Color Frontcolor = Color.fromARGB(255, 239, 248, 222);
  final Color buttoncolor = Color.fromARGB(255, 69, 170, 173);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Frontcolor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              DashBoardDetailCard(
                  location: "Hyderabad",
                  state: "Telangana",
                  coordinate1: "12345",
                  coordinate2: "12345",
                  coordinate3: "12345",
                  coordinate4: "12345",
                  acres: "22",
                  metersSquared: "22"),

              // AreaCoordinateCard(
              //   areaOfMarkedRegion: areaOfMarkedRegion,
              //   polygonCoordinates: polygonCoordinates,
              // ), //In widget Section
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  Text("Details :",
                      style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  DashboardCard(
                      title: "Trial",
                      image: Image.asset('assets/project/projectTile50.png'),
                      description: 'Description Here',
                      additionalText: 'Additional Text Here',
                      MainTitle: "TREE ANALYSIS",
                      onTap: () {}),
                  DashboardCard(
                      title: "Trial",
                      image: Image.asset(
                        'assets/project/projectTile50.png',
                      ),
                      description: 'Description Here',
                      additionalText: 'Additional Text Here',
                      MainTitle: "TREE ENUMERATION",
                      onTap: () {}),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  DashboardCard(
                      title: "Trial",
                      image: Image.asset(
                        'assets/project/projectTile50.png',
                        fit: BoxFit.fill,
                      ),
                      description: 'Description Here',
                      additionalText: 'Additional Text Here',
                      MainTitle: "SPECIES ANALYSIS",
                      onTap: () {}),
                  DashboardCard(
                      title: "Trial",
                      image: Image.asset(
                        'assets/project/projectTile50.png',
                      ),
                      description: 'Description Here',
                      additionalText: 'Additional Text Here',
                      MainTitle: "TREE REALLOCATION",
                      onTap: () {}),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
