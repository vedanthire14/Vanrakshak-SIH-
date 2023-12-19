import 'package:flutter/material.dart';

class TerrainAnalysis extends StatelessWidget {
  final String projectTitle;
  final String location;
  final String date;
  final String textTitle;

  TerrainAnalysis({
    required this.projectTitle,
    required this.location,
    required this.date,
    required this.textTitle,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color.fromARGB(255, 39, 159, 130);
    final Color frontColor = const Color.fromARGB(255, 239, 248, 222);
    final Color tealColor = Colors.teal; // Define teal color

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0), // Increase the height of the AppBar
        child: AppBar(
          backgroundColor: bgColor,
          title: Align(
            alignment: Alignment.center, // Center align the text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 28, // Specify a height for the projectTitle
                  child: Text(
                    projectTitle,
                    style: TextStyle(
                      color: frontColor,
                      fontSize: 28.0, // Increase the font size     
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 15, // Specify a height for the location
                      child: Text(
                        location,
                        style: TextStyle(
                          color: frontColor,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 20, // Specify a height for the date
                      child: Text(
                        date,
                        style: TextStyle(
                          color: frontColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // Remove back button
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16), // Add spacing between AppBar and image
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 150,
                width: 60, // Adjust width as needed
                child: Image.asset(
                  "assets/project/dashboard4.png",
                  fit: BoxFit.contain, // Changed to BoxFit.contain
                ),
              ),
              SizedBox(height: 10), // Spacing between image and title
              Text(
                textTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: tealColor, // Use teal color for text
                  fontSize: 20.0, // Adjust font size as needed
                ),
              ),
              // Add other content here...
            ],
          ),
        ),
      ),
    );
  }
}
