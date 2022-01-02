import 'package:flutter/material.dart';

class QuizSentence extends StatelessWidget {
  final String sentence;

  const QuizSentence({
    Key? key,
    required this.sentence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.all(5),
      height: height * .35 < 240
          ? height * .33
          : height * .35 > 320
              ? 320
              : height * .40,
      width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
      child: Container(
        height: height * .35 < 240
            ? height * .33
            : height * .35 > 320
                ? 320
                : height * .40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blueGrey.shade700,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white54.withOpacity(0.5),
              blurRadius: 9.0,
              spreadRadius: 0.6,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            top: 4,
            bottom: 10,
          ),
          child: Text(
            sentence,
            style: height * .35 > 230
                ? const TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    height: 1.7,
                    fontFamily: 'NotoSerifJP',
                  )
                : const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                    height: 1.6,
                    fontFamily: 'NotoSerifJP',
                  ),
          ),
        ),
      ),
    );
  }
}
