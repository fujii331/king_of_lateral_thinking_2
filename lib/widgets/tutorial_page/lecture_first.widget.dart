import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LectureFirst extends HookWidget {
  const LectureFirst({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(0, 0, 0, 0.6),
            ),
            width: MediaQuery.of(context).size.width * .92,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'アプリをダウンロードしていただきありがとうございます！\n',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    Text(
                      '「謎解きの王様2　一人用水平思考クイズ」',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade200,
                        height: 1.7,
                      ),
                    ),
                    const Text(
                      'は、ウミガメのスープに代表される水平思考クイズを一人で遊べるように作成したものです。',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    const Text(
                      '\n前作「謎解きの王様」を遊んでくださった方はありがとうございます！\n今回のテーマはハロウィンで、様々な意見をもとにゲームシステムもいくつか変更しています。\n\nでは、画面をスワイプするか「→」を押して操作説明に移りましょう。',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
