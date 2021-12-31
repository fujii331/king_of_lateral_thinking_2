import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';

class ModalCloseButton extends HookWidget {
  const ModalCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return SizedBox(
      width: 90,
      height: 40,
      child: ElevatedButton(
        child: const Text('閉じる'),
        style: ElevatedButton.styleFrom(
          primary: Colors.red.shade600,
          padding: const EdgeInsets.only(
            bottom: 3,
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
        },
      ),
    );
  }
}
