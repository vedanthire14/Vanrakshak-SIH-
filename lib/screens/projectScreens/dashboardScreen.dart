import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vanrakshak/screens/mainScreens/mainScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.openSans(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectDetailRow(),
              _buildDivider(),
              _buildLocationDetailRow(),
              SizedBox(height: 20),
              _buildCoordinatesCard(),
              SizedBox(height: 20),
              _buildAreaCard(),
              SizedBox(height: 20),
              _buildFeatureCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailText("Project: $predefinedProjectName", Icons.folder_open),
        _buildDetailText("Date: 1/1/2023", Icons.calendar_today),
      ],
    );
  }

  Widget _buildLocationDetailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailText("Location: $predefinedLocation", Icons.location_on),
        _buildDetailText("State: $predefinedState", Icons.flag),
      ],
    );
  }

  Widget _buildDetailText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        SizedBox(width: 5),
        Text(text, style: GoogleFonts.openSans(fontSize: 18)),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey[400],
      indent: 1,
      endIndent: 1,
    );
  }

  Widget _buildCoordinatesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText("Co-Ordinates", Icons.map),
            SizedBox(height: 10),
            ...polygonCoordinates
                .map((coordinate) => Text(
                      coordinate,
                      style: GoogleFonts.openSans(fontSize: 16),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard() {
    return Card(
      elevation: 4,
      child: Row(
        children: [
          Expanded(
            child: Image.asset('assets/project/projectTile50.png',
                fit: BoxFit.cover), // Placeholder for your image
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Text(
              "Area: $areaOfMarkedRegion",
              style: GoogleFonts.openSans(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // to disable GridView's own scrolling
          crossAxisCount: 2, // number of cards per row
          crossAxisSpacing: 40,
          mainAxisSpacing: 10,
          children: [
            FeatureCard(
              title: 'Terrain Analysis',
              icon: Icons.terrain,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                )
              },
            ),
            FeatureCard(
              title: 'Tree Enumeration',
              icon: Icons.nature,
              onTap: () => {},
            ),
            FeatureCard(
              title: 'Species Classification',
              icon: Icons.category,
              onTap: () => {},
            ),
            FeatureCard(
              title: 'Soil Analysis',
              icon: Icons.landscape,
              onTap: () {},
            ),
            FeatureCard(
              title: 'Reallocation Suggestions',
              icon: Icons.compare_arrows,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(String pageName) {
    // Implement navigation logic here
    print('Navigating to $pageName');
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            // Set maximum width and height for the card
            maxWidth: 120,
            maxHeight: 120,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 35, color: Colors.green),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
