import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/admob/interstitial_action.service.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/get_analytics_data.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/questioned/answering_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/questioned/correct_answer_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnswerDisplayButton extends HookWidget {
  final int quizId;

  const AnswerDisplayButton({
    Key? key,
    required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> importantQuestionedIds =
        useProvider(importantQuestionedIdsProvider).state;
    final Answer finalAnswer = useProvider(finalAnswerProvider).state;
    final ValueNotifier<bool> enableAnswerButtonState = useState<bool>(true);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;
    final ValueNotifier<InterstitialAd?> interstitialAd = useState(null);

    return SizedBox(
      width: 160,
      height: 40,
      child: ElevatedButton(
        child: Text(
          finalAnswer.id != 0
              ? '正解はこれだ！'
              : importantQuestionedIds.isNotEmpty
                  ? 'あと少し...'
                  : '質問していこう',
        ),
        style: ElevatedButton.styleFrom(
          primary: finalAnswer.id != 0
              ? Colors.pink.shade700
              : Colors.orange.shade200,
          padding: const EdgeInsets.only(
            bottom: 2,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 2,
            color: finalAnswer.id != 0
                ? Colors.pink.shade800
                : Colors.orange.shade300,
          ),
        ),
        onPressed: finalAnswer.id != 0 && enableAnswerButtonState.value
            ? () async {
                enableAnswerButtonState.value = false;
                // 正解呼び出し
                soundEffect.play(
                  'sounds/quiz_button.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                // 広告読み込み
                interstitialLoading(
                  interstitialAd,
                );

                await Future.delayed(
                  const Duration(milliseconds: 600),
                );

                showDialog<int>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AnsweringModal(
                      imageNumber: (Random().nextInt(2) + 1).toString(),
                    );
                  },
                );

                await Future.delayed(
                  const Duration(seconds: 5),
                );

                soundEffect.play(
                  'sounds/correct_answer.mp3',
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
                }

                Navigator.pop(context);

                final bool clearedFirst =
                    !alreadyAnsweredIds.contains(quizId.toString());

                if (clearedFirst) {
                  // 正解した問題を登録
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  context
                      .read(alreadyAnsweredIdsProvider)
                      .state
                      .add(quizId.toString());
                  prefs.setStringList('alreadyAnsweredIds',
                      context.read(alreadyAnsweredIdsProvider).state);
                }

                final Future<Analytics?> gotAnalyticsData = getAnalyticsData(
                  context,
                  quizId,
                  clearedFirst,
                );

                Analytics? data;

                await gotAnalyticsData.then((value) => data = value);

                context.read(playingQuizIdProvider).state = 0;

                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  headerAnimationLoop: false,
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  animType: AnimType.SCALE,
                  width: MediaQuery.of(context).size.width * .86 > 650
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
    );
  }
}
