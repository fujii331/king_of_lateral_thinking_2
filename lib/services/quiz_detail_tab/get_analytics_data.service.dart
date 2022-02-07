import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';

Future<Analytics?> getAnalyticsData(
  BuildContext context,
  int quizId,
  bool clearedFirst,
) async {
  final int hint = context.read(hintStatusProvider).state;

  final int relatedWordCountValue =
      context.read(relatedWordCountProvider).state;

  final int questionCountValue = context.read(questionCountProvider).state;

  final bool subHintOpened = context.read(subHintOpenedProvider).state;

  final bool noHintFlg = hint == 0 && !subHintOpened;

  int hint1Count = hint > 0 ? 1 : 0;
  int hint2Count = hint > 1 ? 1 : 0;
  int hint3Count = hint > 2 ? 1 : 0;
  int subHintCount = subHintOpened ? 1 : 0;
  int relatedWordCount = noHintFlg ? relatedWordCountValue : 0;
  int questionCount = noHintFlg ? questionCountValue : 0;
  int userCount = 1;
  int noHintCount = noHintFlg ? 1 : 0;

  DatabaseReference firebaseInstance =
      FirebaseDatabase.instance.ref().child('analytics/' + quizId.toString());

  Analytics? data;

  await firebaseInstance.get().then((DataSnapshot? snapshot) {
    if (snapshot != null) {
      final Map? firebaseData = snapshot.value as Map;

      hint1Count += firebaseData!['hint1Count'] as int;

      hint2Count += firebaseData['hint2Count'] as int;
      hint3Count += firebaseData['hint3Count'] as int;
      subHintCount += firebaseData['subHintCount'] as int;

      relatedWordCount += firebaseData['relatedWordCount'] as int;
      questionCount += firebaseData['questionCount'] as int;

      userCount += firebaseData['userCount'] as int;

      noHintCount += firebaseData['noHintCount'] as int;

      data = Analytics(
        hint1: (100 * (hint1Count / userCount)).round(),
        hint2: (100 * (hint2Count / userCount)).round(),
        noHint: (100 * (noHintCount / userCount)).round(),
        subHint: (100 * (subHintCount / userCount)).round(),
        relatedWordCountAll:
            noHintCount == 0 ? 0 : (relatedWordCount / noHintCount).round(),
        relatedWordCountYou: relatedWordCountValue,
        questionCountAll:
            noHintCount == 0 ? 0 : (questionCount / noHintCount).round(),
        questionCountYou: questionCountValue,
        userCount: userCount,
        noHintCount: noHintCount,
      );

      if (clearedFirst) {
        firebaseInstance.set({
          'hint1Count': hint1Count,
          'hint2Count': hint2Count,
          'hint3Count': hint3Count,
          'subHintCount': subHintCount,
          'relatedWordCount': relatedWordCount,
          'questionCount': questionCount,
          'userCount': userCount,
          'noHintCount': noHintCount,
        });
      }
    }
  }).onError((error, stackTrace) =>
      // 何もしない
      null);

  // 固定値用
  // final gotAnalyticsData = ANALYTICS_DATA[quizId - 1];
  // data = Analytics(
  //   hint1: gotAnalyticsData.hint1,
  //   hint2: gotAnalyticsData.hint2,
  //   noHint: gotAnalyticsData.noHint,
  //   subHint: gotAnalyticsData.subHint,
  //   relatedWordCountAll: gotAnalyticsData.relatedWordCountAll,
  //   relatedWordCountYou: relatedWordCountValue,
  //   questionCountAll: gotAnalyticsData.questionCountAll,
  //   questionCountYou: questionCountValue,
  // );

  return data;
}
