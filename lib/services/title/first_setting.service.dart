import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/data/ogiri_data.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void firstSetting(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  context.read(openingNumberProvider).state =
      prefs.getInt('openingNumber') ?? 6;

  // 音量設定
  final double? bgmVolume = prefs.getDouble('bgmVolume');
  final double? seVolume = prefs.getDouble('seVolume');

  if (bgmVolume != null) {
    context.read(bgmVolumeProvider).state = bgmVolume;
  } else {
    prefs.setDouble('bgmVolume', 0.2);
  }
  if (seVolume != null) {
    context.read(seVolumeProvider).state = seVolume;
  } else {
    prefs.setDouble('seVolume', 0.5);
  }

  context
      .read(bgmProvider)
      .state
      .setVolume(context.read(bgmVolumeProvider).state);

  context.read(soundEffectProvider).state.loadAll([
    'sounds/answer.mp3',
    'sounds/cancel.mp3',
    'sounds/change.mp3',
    'sounds/correct_answer.mp3',
    'sounds/got_final_answer.mp3',
    'sounds/hint.mp3',
    'sounds/nice_question.mp3',
    'sounds/quiz_button.mp3',
    'sounds/tap.mp3',
  ]);

  // 遊び方に誘導するかの判定
  final bool? alreadyPlayedQuiz = prefs.getBool('alreadyPlayedQuiz');

  if (alreadyPlayedQuiz != null) {
    context.read(alreadyPlayedQuizProvider).state = true;
  }

  final bool? alreadyPlayedOgiri = prefs.getBool('alreadyPlayedOgiri');

  if (alreadyPlayedOgiri != null) {
    context.read(alreadyPlayedOgiriProvider).state = true;
  }

  // 大喜利閲覧可否
  context.read(enableBrowseOgiriListProvider).state =
      prefs.getStringList('enableBrowseOgiriList') ?? [];

  // 正解済みの問題を設定
  if (prefs.getStringList('alreadyAnsweredIds') == null) {
    prefs.setStringList('alreadyAnsweredIds', []);
  }
  context.read(alreadyAnsweredIdsProvider).state =
      // [
      //   '1',
      //   '2',
      //   '3',
      //   '4',
      //   '5',
      //   '6',
      //   '7',
      //   '8',
      //   '9',
      //   '10',
      //   '11',
      //   '12',
      //   '13',
      //   '14',
      //   '15',
      //   '16',
      //   '17',
      //   '18',
      //   '19',
      //   '20',
      //   '21',
      //   '22',
      //   '23',
      //   '24',
      //   '25',
      //   '26',
      //   '27',
      //   '28',
      //   '29',
      //   '30'
      // ];
      prefs.getStringList('alreadyAnsweredIds')!;

  // 日時
  if (prefs.getString('dataString') == null) {
    final String todayString = DateFormat('yyyy/MM/dd').format(DateTime.now());

    prefs.setString('dataString', todayString);
  }

  // 大喜利ニックネーム
  context.read(ogiriNickNameProvider).state =
      prefs.getString('ogiriNickName') ?? '';

  // 大喜利パターン
  List<String> ogiriPattern = prefs.getStringList('ogiriPattern') ?? [];

  if (ogiriPattern.isEmpty) {
    for (int i = 0; i < 69; i++) {
      ogiriPattern.add(i.toString());
    }

    ogiriPattern.shuffle();
    prefs.setStringList('ogiriPattern', ogiriPattern);
  }

  final List<Ogiri> allOgiriList = ogiriPattern.map((String stringOrderNo) {
    final Ogiri targetOgiri = ogiriData[int.parse(stringOrderNo)];
    return Ogiri(
      id: targetOgiri.id,
      title: targetOgiri.title,
      sentence: targetOgiri.sentence,
      totalGoodCount: 0,
      ogiriAnswers: [],
    );
  }).toList();

  // 大喜利のリストを設定
  context.read(allOgiriListProvider).state = allOgiriList;
}
