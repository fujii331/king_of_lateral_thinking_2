import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void firstSetting(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  context.read(openingNumberProvider).state =
      prefs.getInt('openingNumber') ?? 9;

  // 音量設定
  final double? bgmVolume = prefs.getDouble('bgmVolume');
  final double? seVolume = prefs.getDouble('seVolume');
  final bool alreadyPlayeFlg = prefs.getInt('openingNumber') != null;

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
    'sounds/correct_answer.mp3',
    'sounds/tap.mp3',
    'sounds/cancel.mp3',
    'sounds/quiz_button.mp3',
    'sounds/hint.mp3',
    'sounds/change.mp3',
    'sounds/fault.mp3',
    'sounds/finish.mp3',
    'sounds/funny.mp3',
    'sounds/push.mp3',
    'sounds/ready.mp3',
    'sounds/start.mp3',
    'sounds/think.mp3',
    'sounds/wrong_answer.mp3',
  ]);

  // 遊び方に誘導するかの判定
  final bool? alreadyPlayedQuiz = prefs.getBool('alreadyPlayedQuiz');

  if (alreadyPlayedQuiz != null || alreadyPlayeFlg) {
    context.read(alreadyPlayedQuizFlgProvider).state = true;
  }

  // 入力時設定
  context.read(displayInputFlgProvider).state =
      prefs.getBool('displayInputFlg') ?? false;

  // 正解済みの問題を設定
  if (prefs.getStringList('alreadyAnsweredIds') == null) {
    prefs.setStringList('alreadyAnsweredIds', []);
  }
  context.read(alreadyAnsweredIdsProvider).state =
      prefs.getStringList('alreadyAnsweredIds')!;
}
