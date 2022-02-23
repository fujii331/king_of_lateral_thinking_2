import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/ogiri_tutorial.screen.dart';
import 'package:king_of_lateral_thinking_2/screens/quiz_list.screen.dart';
import 'package:king_of_lateral_thinking_2/screens/tutorial_page.screen.dart';
import 'package:king_of_lateral_thinking_2/services/title/to_ogiri_list.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/title/sound_mode.widget.dart';

class TitleButton extends HookWidget {
  final ValueNotifier<bool> displayFlg;

  const TitleButton({
    Key? key,
    required this.displayFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final bool alreadyPlayedQuiz = useProvider(alreadyPlayedQuizProvider).state;
    final bool alreadyPlayedOgiri =
        useProvider(alreadyPlayedOgiriProvider).state;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Column(
        children: [
          _selectButton(
            context,
            '一人用水平思考',
            Colors.blue,
            const Icon(Icons.account_balance),
            soundEffect,
            1,
            seVolume,
            alreadyPlayedQuiz,
          ),
          const SizedBox(height: 25),
          _selectButton(
            context,
            '水平思考大喜利',
            Colors.pink,
            const Icon(Icons.question_answer),
            soundEffect,
            2,
            seVolume,
            alreadyPlayedOgiri,
          ),
          const SizedBox(height: 25),
          _selectButton(
            context,
            '　音量設定　　',
            Colors.lime,
            const Icon(Icons.music_note),
            soundEffect,
            3,
            seVolume,
            true,
          ),
        ],
      ),
    );
  }

  Widget _selectButton(
    BuildContext context,
    String label,
    MaterialColor color,
    Icon icon,
    AudioCache soundEffect,
    int buttonPuttern,
    double seVolume,
    bool alreadyPlayed,
  ) {
    return SizedBox(
      width: 190,
      height: 40,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.shade50,
            fontFamily: 'KaiseiOpti',
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color.shade800,
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 2,
            color: color.shade900,
          ),
        ),
        onPressed: () async {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );
          if (buttonPuttern == 1) {
            if (alreadyPlayed) {
              Navigator.of(context).pushNamed(
                QuizListScreen.routeName,
              );
            } else {
              Navigator.of(context).pushNamed(
                TutorialPageScreen.routeName,
                arguments: false,
              );
            }
          } else if (buttonPuttern == 2) {
            if (alreadyPlayed) {
              toOgiriList(context, false);
            } else {
              Navigator.of(context).pushNamed(
                OgiriTutorialScreen.routeName,
                arguments: false,
              );
            }
          } else if (buttonPuttern == 3) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.NO_HEADER,
              headerAnimationLoop: false,
              animType: AnimType.SCALE,
              width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
              body: SoundMode(soundEffect: soundEffect),
            ).show();
            // 分析データ作成用
            // for (int i = 37; i <= 60; i++) {
            //   DatabaseReference firebaseInstance = FirebaseDatabase.instance
            //       .ref()
            //       .child('analytics/' + i.toString());

            //   firebaseInstance.set({
            //     'hint1Count': 0,
            //     'hint2Count': 0,
            //     'hint3Count': 0,
            //     'subHintCount': 0,
            //     'relatedWordCount': 0,
            //     'questionCount': 0,
            //     'userCount': 0,
            //     'noHintCount': 0,
            //   });
            // }

            // 大喜利データ作成
            // for (int i = 1; i <= 69; i++) {
            //   DatabaseReference firebaseInstance = FirebaseDatabase.instance
            //       .ref()
            //       .child('ogiri/' + i.toString());

            //   final boya = boyaData[i - 1];

            //   firebaseInstance.push().set(
            //     {
            //       'answer': boya.answer,
            //       'nickName': boya.nickName,
            //       'dateInt': boya.dateInt,
            //       'goodCount': boya.goodCount,
            //       'allowed': 1,
            //     },
            //   );
            // }

            // for (int i = 1; i <= 69; i++) {
            //   DatabaseReference firebaseInstance = FirebaseDatabase.instance
            //       .ref()
            //       .child('ogiri/' + i.toString());

            //   final osama = osamaData[i - 1];

            //   firebaseInstance.push().set(
            //     {
            //       'answer': osama.answer,
            //       'nickName': osama.nickName,
            //       'dateInt': osama.dateInt,
            //       'goodCount': osama.goodCount,
            //       'allowed': 1,
            //     },
            //   );
            // }
          }
        },
      ),
    );
  }
}
