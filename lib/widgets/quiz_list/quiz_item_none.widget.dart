import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizItemNone extends HookWidget {
  final int quizNum;

  const QuizItemNone({
    Key? key,
    required this.quizNum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final bool heightOk = height > 580;

    return Padding(
      padding: EdgeInsets.only(top: heightOk ? 14 : 9),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blueGrey.shade800,
            width: 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(
              bottom: 11,
              left: heightOk ? 5 : 0,
              right: heightOk ? 5 : 0,
            ),
            child: Text(
              '問' + quizNum.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: heightOk ? 20 : 18,
                color: Colors.white60,
              ),
            ),
          ),
          title: Container(
            padding: EdgeInsets.only(
              bottom: 11,
              right: heightOk ? 5 : 0,
            ),
            child: Text(
              '問題準備中！',
              style: TextStyle(
                color: Colors.white60,
                fontSize: heightOk ? 20 : 18,
              ),
            ),
          ),
          onTap: null,
        ),
      ),
    );
  }
}
