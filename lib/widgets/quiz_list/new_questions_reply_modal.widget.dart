import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';

class NewQuestionsReplyModal extends HookWidget {
  final int openQuizNumber;

  const NewQuestionsReplyModal({
    Key? key,
    required this.openQuizNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '新たな問題で遊べるようになりました！',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 90,
            height: 40,
            child: ElevatedButton(
              child: const Text('閉じる'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade600,
                padding: const EdgeInsets.only(
                  bottom: 2,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.red.shade700,
                ),
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                Navigator.pop(context);

                if (openQuizNumber == 15 || openQuizNumber == 30) {
                  AppReview.requestReview.then(
                    (_) {},
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
