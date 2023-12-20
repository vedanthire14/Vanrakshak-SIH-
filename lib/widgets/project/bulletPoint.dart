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
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 69, 170, 173),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          Title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          Detail,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}


class BulletPointDashboard extends StatelessWidget {
  final String title;
  final String detail;

  BulletPointDashboard({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.only(right: 10, top: 5),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 69, 170, 173),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' '), // Space between title and detail
                  TextSpan(
                    text: detail,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

