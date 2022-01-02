import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/quiz_list.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LectureLast extends HookWidget {
  final bool alreadyPlayed;
  final AudioCache soundEffect;
  final double seVolume;

  const LectureLast({
    Key? key,
    required this.alreadyPlayed,
    required this.soundEffect,
    required this.seVolume,
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
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '・質問は入力した言葉を必ず含むので、質問文からイメージしましょう。\n\n・関連語には「大きい」「関係」などの形容詞や名詞の他に「会えた」「起こる」などの述語になる言葉が選べることがあります。\n\n・解答を導く重要な質問を行った時は、いつもと違う音が鳴るので注意して聞いてみましょう。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    const Text(
                      '・一問目はヒントが使い放題なので、練習と思ってやってみましょう。\n\n・関連語の入力時に入力内容が隠れてしまう場合、問題一覧右上のメニューボタンから「入力時設定」を押して設定を変更してみて下さい。\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.yellow,
                        fontFamily: 'NotoSerifJP',
                        height: 1.7,
                      ),
                    ),
                    const Text(
                      'それでは、謎解きの王様2をお楽しみください！',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.7,
                      ),
                    ),
                    alreadyPlayed
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width: 115,
                                  height: 40,
                                  child: ElevatedButton(
                                    child: const Text('問題一覧へ'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade500,
                                      padding: const EdgeInsets.only(
                                        bottom: 2,
                                      ),
                                      shape: const StadiumBorder(),
                                      side: BorderSide(
                                        width: 2,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      soundEffect.play(
                                        'sounds/tap.mp3',
                                        isNotification: true,
                                        volume: seVolume,
                                      );
                                      context
                                          .read(alreadyPlayedQuizFlgProvider)
                                          .state = true;
                                      prefs.setBool('alreadyPlayedQuiz', true);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        QuizListScreen.routeName,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
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
