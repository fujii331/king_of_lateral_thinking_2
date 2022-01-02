import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/admob/interstitial_action.service.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/get_analytics_data.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_answer/correct_answer_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void executeAnswer(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ValueNotifier<InterstitialAd?> interstitialAd,
  List<String> alreadyAnsweredIds,
  int quizId,
  String finalAnswerComment,
) async {
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
  } else {
    // 広告読み込み
    interstitialLoading(
      interstitialAd,
    );
    for (int i = 0; i < 7; i++) {
      if (i > 2 && interstitialAd.value != null) {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  final bool clearedFirst = !alreadyAnsweredIds.contains(quizId.toString());

  if (clearedFirst) {
    // 正解した問題を登録
    SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read(alreadyAnsweredIdsProvider).state.add(quizId.toString());
    prefs.setStringList(
        'alreadyAnsweredIds', context.read(alreadyAnsweredIdsProvider).state);
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
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: CorrectAnswerModal(
      comment: finalAnswerComment,
      data: data,
    ),
  ).show();
}
