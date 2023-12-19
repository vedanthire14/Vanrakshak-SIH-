import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselCard extends StatelessWidget {
  final List<String> imgList;
  final List<List<String>> details;

  CarouselCard({required this.imgList, required this.details});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: imgList.asMap().map((index, url) => MapEntry(index, Builder(
        builder: (BuildContext context) {
          return Card(
            margin: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(url, fit: BoxFit.cover, width: 1000),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details[index].map((detail) => Text(detail)).toList(),
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
