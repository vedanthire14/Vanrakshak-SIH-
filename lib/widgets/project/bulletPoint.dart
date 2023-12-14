import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final String Title;
  final String Detail;

  BulletPoint({required this.Title, required this.Detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.teal,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Text(Title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text(Detail, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
