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
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Container(
        height: 50,
        alignment: Alignment.center,
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
            padding: const EdgeInsets.only(bottom: 11, left: 5, right: 5),
            child: Text(
              '問' + quizNum.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white60,
              ),
            ),
          ),
          title: Container(
            padding: const EdgeInsets.only(bottom: 11, right: 5),
            child: const Text(
              '問題準備中！',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 20,
              ),
            ),
          ),
          onTap: null,
        ),
      ),
    );
  }
}
