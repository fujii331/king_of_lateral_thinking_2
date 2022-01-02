import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/admob/interstitial_action.service.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/get_analytics_data.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/questioned/correct_answer_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                    width: MediaQuery.of(context).size.width * .70,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.red.shade700,
                        width: 3,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
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
                              soundEffect.play(
                                'sounds/quiz_button.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );

                              if (interstitialAd.value != null) {
                                // 広告を表示する
                                showInterstitialAd(
                                  context,
                                  interstitialAd,
                                );
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                              } else {
                                // 広告読み込み
                                interstitialLoading(
                                  interstitialAd,
                                );
                                for (int i = 0; i < 7; i++) {
                                  if (i > 2 && interstitialAd.value != null) {
                                    break;
                                  }
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                }
                              }

                              final bool clearedFirst = !alreadyAnsweredIds
                                  .contains(quizId.toString());

                              if (clearedFirst) {
                                // 正解した問題を登録
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                context
                                    .read(alreadyAnsweredIdsProvider)
                                    .state
                                    .add(quizId.toString());
                                prefs.setStringList(
                                    'alreadyAnsweredIds',
                                    context
                                        .read(alreadyAnsweredIdsProvider)
                                        .state);
                              }

                              final Future<Analytics?> gotAnalyticsData =
                                  getAnalyticsData(
                                context,
                                quizId,
                                clearedFirst,
                              );

                              Analytics? data;

                              await gotAnalyticsData
                                  .then((value) => data = value);

                              context.read(playingQuizIdProvider).state = 0;

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.NO_HEADER,
                                headerAnimationLoop: false,
                                dismissOnTouchOutside: false,
                                dismissOnBackKeyPress: false,
                                animType: AnimType.SCALE,
                                width: MediaQuery.of(context).size.width * .86 >
                                        650
                                    ? 650
                                    : null,
                                body: CorrectAnswerModal(
                                  comment: finalAnswer.comment,
                                  data: data,
                                ),
                              ).show();
                            }
                          : () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
