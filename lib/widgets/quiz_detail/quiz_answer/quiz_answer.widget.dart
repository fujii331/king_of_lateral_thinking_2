import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/execute_answer.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';

class QuizAnswer extends HookWidget {
  final int quizId;
  final ValueNotifier<InterstitialAd?> interstitialAd;

  const QuizAnswer({
    Key? key,
    required this.quizId,
    required this.interstitialAd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * .35;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final Answer finalAnswer = useProvider(finalAnswerProvider).state;
    final ValueNotifier<bool> enableAnswerButtonState = useState<bool>(true);
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    return Stack(
      children: <Widget>[
        background('answer_back.png'),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.3),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '今までの質問から\n導かれた解答',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height > 210 ? 28.0 : 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.shade700,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      top: 4,
                      bottom: 10,
                    ),
                    child: Text(
                      finalAnswer.answer,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.7,
                        fontFamily: 'NotoSerifJP',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 140,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text(
                      '解答して進む',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade700,
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: Colors.pink.shade800,
                      ),
                    ),
                    onPressed: enableAnswerButtonState.value
                        ? () async {
                            enableAnswerButtonState.value = false;
                            // 正解呼び出し
                            executeAnswer(
                              context,
                              soundEffect,
                              seVolume,
                              interstitialAd,
                              alreadyAnsweredIds,
                              quizId,
                              finalAnswer.comment,
                            );
                          }
                        : () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
