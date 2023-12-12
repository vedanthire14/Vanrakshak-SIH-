import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vanrakshak/screens/mainScreens/mainScreen.dart';
import 'package:fl_chart/fl_chart.dart';

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
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.openSans(
              color: Frontcolor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Bgcolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomContainer(),
              SizedBox(height: 20),
              AreaCoordinateCard(
                areaOfMarkedRegion: areaOfMarkedRegion,
                polygonCoordinates: polygonCoordinates,
              ),
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
              CustomCard(
                title: 'Tree Analysis',
                description: 'Description Here',
                image: Image.asset('assets/tree_png.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomCard(
                title: 'Terrain Analysis',
                description: 'Description Here',
                image: Image.asset('assets/tree_png.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomCard(
                title: 'Tree Enum',
                description: 'Description Here',
                image: Image.asset('assets/bar_graph.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomCard(
                title: 'Species',
                description: 'Description Here',
                image: Image.asset('assets/bar_graph.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomCard(
                title: 'Soil Analysis',
                description: 'Description Here',
                image: Image.asset('assets/bar_graph.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomCard(
                title: 'Reallocation',
                description: 'Description Here',
                image: Image.asset('assets/bar_graph.png'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
              ),
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
        _buildDetailText(
          "Project: $predefinedProjectName",
          Icons.folder_open,
        ),
        _buildDetailText("Date: 1/1/2023", Icons.calendar_today),
      ],
    );
  }

  Widget _buildLocationDetailRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDetailText(
          "Location: $predefinedLocation",
          Icons.location_on,
        ),
        _buildDetailText("State: $predefinedState", Icons.flag),
      ],
    );
  }

  Widget _buildDetailText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Bgcolor),
        SizedBox(width: 5),
        Text(text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(fontSize: 15)),
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

  Widget _buildCustomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project: $predefinedProjectName",
            style:
                GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildDivider(),
          _buildProjectDetailRow(),
          _buildDivider(),
          _buildLocationDetailRow(),
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String title;
  final String description;
  final Image image;
  final Function()? onTap;

  CustomCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      // required this.onTap
      required this.onTap})
      : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Color Bgcolor = Color.fromARGB(255, 39, 159, 130);
  final Color Frontcolor = Color.fromARGB(255, 239, 248, 222);
  final Color buttoncolor = Color.fromARGB(255, 69, 170, 173);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.1, end: 1.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildGraphImage() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 80,
            height: 100,
            child: Center(
              child: widget.image,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleDescription() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Bgcolor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreButton() {
    return InkWell(
      onTap: () {
        // Action on tap
        widget.onTap!();
        print('Explore tapped');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: buttoncolor, // Light green color for the button
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Tap to Explore',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildGraphImage(),
            SizedBox(width: 20.0),
            _buildTitleDescription(),
            SizedBox(width: 20.0),
            _buildExploreButton(),
          ],
        ),
      ),
    );
  }
}

class AreaCoordinateCard extends StatelessWidget {
  final String areaOfMarkedRegion;
  final List<String> polygonCoordinates;

  AreaCoordinateCard(
      {Key? key,
      required this.areaOfMarkedRegion,
      required this.polygonCoordinates})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildCoordinatesCard(),
            SizedBox(height: 10),
            _buildAreaCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesCard() {
    return Card(
      elevation: 2, // Reduced elevation for nested card
      child: Padding(
        padding: EdgeInsets.all(8.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText("Co-Ordinates", Icons.map),
            SizedBox(height: 6),
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
      elevation: 2, // Reduced elevation for nested card
      child: Row(
        children: [
          Expanded(
            child: Image.asset('assets/project/projectTile50.png',
                fit: BoxFit.cover), // Your image
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding for text
              child: Text(
                "Area: $areaOfMarkedRegion",
                style: GoogleFonts.openSans(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Text(
          text,
          style:
              GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
