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
              buildCustomLayout(),
              SizedBox(height: 20),
              AreaCoordinateCard(
                areaOfMarkedRegion: areaOfMarkedRegion,
                polygonCoordinates: polygonCoordinates,
              ), //In widget Section
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

  Widget _buildProjectDetailColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailText(
          "Project: $predefinedProjectName",
          Icons.folder_open,
        ),
        SizedBox(height: 10),
        _buildDetailText("Date: 1/1/2023", Icons.calendar_today),
      ],
    );
  }

  Widget _buildLocationDetailColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailText(
          "Location: $predefinedLocation",
          Icons.location_on,
        ),
        SizedBox(height: 10),
        _buildDetailText("State: $predefinedState", Icons.flag),
      ],
    );
  }

  Widget _buildDetailText(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Bgcolor),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[400],
      indent: 10,
      endIndent: 10,
    );
  }

  Widget buildCustomLayout() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Material(
        color: Frontcolor,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project: $predefinedProjectName",
                style: GoogleFonts.openSans(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildDivider(),
              _buildProjectDetailColumn(),
              _buildDivider(),
              _buildLocationDetailColumn(),
            ],
          ),
        ),
      ),
    );
  }
}
