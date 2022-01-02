import 'package:flutter/material.dart';

class LectureFigure extends StatelessWidget {
  final String imagePath;

  const LectureFigure({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
