import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/quiz_list.screen.dart';
import 'package:king_of_lateral_thinking_2/screens/tutorial_page.screen.dart';
import 'package:king_of_lateral_thinking_2/widgets/title/sound_mode.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final bool alreadyPlayedQuizFlg =
        useProvider(alreadyPlayedQuizFlgProvider).state;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Column(
        children: [
          _selectButton(
            context,
            '　遊ぶ　',
            Colors.lightBlue,
            const Icon(Icons.account_balance),
            soundEffect,
            1,
            seVolume,
            alreadyPlayedQuizFlg,
          ),
          const SizedBox(height: 25),
          _selectButton(
            context,
            '音量設定',
            Colors.lime,
            const Icon(Icons.music_note),
            soundEffect,
            2,
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
    bool alreadyPlayedFlg,
  ) {
    return SizedBox(
      width: 140,
      height: 40,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            color: Colors.blueGrey.shade50,
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
            if (alreadyPlayedFlg) {
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
            AwesomeDialog(
              context: context,
              dialogType: DialogType.NO_HEADER,
              headerAnimationLoop: false,
              animType: AnimType.SCALE,
              width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
              body: SoundMode(soundEffect: soundEffect),
            ).show();
            // 分析データ作成用
            // for (int i = 1; i <= 36; i++) {
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
            // 問題解放リセット
            const int openQuizNumber = 6;

            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setInt('openingNumber', openQuizNumber);

            context.read(openingNumberProvider).state = openQuizNumber;
          }
        },
      ),
    );
  }
}
