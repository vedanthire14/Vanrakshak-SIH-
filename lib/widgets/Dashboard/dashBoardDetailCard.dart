import 'package:flutter/material.dart';

//Custom Card For Dashboard Subtopics
class DashBoardDetailCard extends StatefulWidget {
  final String title;
  final String description;
  final Image image;
  final Function()? onTap;

  DashBoardDetailCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      // required this.onTap
      required this.onTap})
      : super(key: key);

  @override
  _DashBoardDetailCardState createState() => _DashBoardDetailCardState();
}

class _DashBoardDetailCardState extends State<DashBoardDetailCard>
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
      color: Frontcolor,
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
