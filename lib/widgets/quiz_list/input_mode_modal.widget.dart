import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/modal_close_button.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/common.provider.dart';

class InputModeModal extends HookWidget {
  const InputModeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final bool alwaysDisplayInput =
        useProvider(alwaysDisplayInputProvider).state;
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
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: ElevatedButton(
              onPressed: () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('alwaysDisplayInput', false);
                context.read(alwaysDisplayInputProvider).state = false;
              },
              child: const Text('レイアウトを固定'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  right: 14,
                  left: 14,
                ),
                primary: alwaysDisplayInput
                    ? Colors.blue.shade200
                    : Colors.blue.shade400,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setBool('alwaysDisplayInput', true);
              context.read(alwaysDisplayInputProvider).state = true;
            },
            child: const Text('入力欄を常に表示'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.only(
                right: 14,
                left: 14,
              ),
              primary: alwaysDisplayInput
                  ? Colors.orange.shade600
                  : Colors.orange.shade200,
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: Text(
              alwaysDisplayInput
                  ? '関連語の入力時、常に入力欄が見えるように調整します。'
                  : '関連語の入力時、画面のレイアウトをそのまま固定します。',
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 54,
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              alwaysDisplayInput ? '※小さい端末向け\n　一部背景の変更あり' : '※大きい端末向け',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
          const SizedBox(height: 15),
          const ModalCloseButton(),
        ],
      ),
    );
  }
}
