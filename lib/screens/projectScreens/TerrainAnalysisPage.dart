import 'package:flutter/material.dart';
import 'package:vanrakshak/widgets/Dashboard/DashBoardFinal.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';

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
    final Color tealColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          projectTitle,
          style: TextStyle(color: frontColor, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  location,
                  style: TextStyle(color: frontColor, fontSize: 18.0),
                ),
                
                Text(
                  date,
                  style: TextStyle(color: frontColor, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 150,
                width: 60,
                child: Image.asset(
                  "assets/project/dashboard4.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Text(
                textTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: tealColor,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10),
              Divider( color: tealColor, ),
              SizedBox( height: 10, ),

               DashBoardFinalCardd(titles: ["Ok", "OK", "Ok"], details: ["Ok", "OK", "Ok"], coordinates: ["123456", "123456", "123456","123456"]),


            ],
          ),
        ),
      ),
    );
  }
}
