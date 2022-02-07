import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_answer/analytics_modal.widget.dart';

class CorrectAnswerModal extends HookWidget {
  final String comment;
  final Analytics? data;

  const CorrectAnswerModal({
    Key? key,
    required this.comment,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .86 > 550 ? 30 : 0,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              '正解解説',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .33,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text('一覧へ'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade600,
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    onPressed: () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                data == null
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(left: 30),
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          child: const Text('統計'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade600,
                            padding: const EdgeInsets.only(
                              bottom: 2,
                            ),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              width: 2,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          onPressed: () {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 550
                                      ? 550
                                      : null,
                              body: AnalyticsModal(
                                data: data!,
                              ),
                            ).show();
                          },
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
