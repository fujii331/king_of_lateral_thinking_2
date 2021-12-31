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

    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(
              top: height > 620 ? 5 : 0,
              bottom: height > 620 ? 10 : 15,
              left: 5,
              right: 5),
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
          padding: const EdgeInsets.only(bottom: 13, right: 5),
          child: const Text(
            '近日公開！お楽しみに',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ),
        onTap: null,
      ),
    );
  }
}
