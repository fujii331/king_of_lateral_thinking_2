import 'package:flutter/material.dart';

Widget background(String imageName) {
  return Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/common_back.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Opacity(
        opacity: 0.7,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/' + imageName),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  );
}
