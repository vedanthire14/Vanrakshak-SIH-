import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselCard extends StatelessWidget {
  final List<dynamic> imgList;
  final List<List<dynamic>> details;

  CarouselCard({required this.imgList, required this.details});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        // viewportFraction: 0.5,
        height: MediaQuery.of(context).size.height * 0.6,
        autoPlay: true,
        // aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: imgList.asMap().map((index, url) => MapEntry(index, Builder(
        builder: (BuildContext context) {
          return Card(
            elevation: 10,
            color:  Colors.white,
            margin: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Container for image with fixed height  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity, // Expand the image to the full width
                      height: 200, // Adjust this value for image position
                    ),
                  ),
                ),
                // Container for text
                SizedBox(height: 10),
                Text("SEQUENTIAL IMAGE", textAlign: TextAlign.center, style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:  Colors.teal),),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: details[index].map((detail) => Text(detail, textAlign: TextAlign.center, style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ))).values.toList(),
    );
  }
}
