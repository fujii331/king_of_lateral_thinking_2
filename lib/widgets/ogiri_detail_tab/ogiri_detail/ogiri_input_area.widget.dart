import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_detail/ogiri_submit_modal.widget.dart';

class QuizInputArea extends HookWidget {
  final TextEditingController answerController;
  final TextEditingController nickNameController;
  final int ogiriId;

  const QuizInputArea({
    Key? key,
    required this.answerController,
    required this.nickNameController,
    required this.ogiriId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final bool enableSubmit =
        answerController.text != '' && nickNameController.text != '';

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .86 > 550
            ? 550
            : MediaQuery.of(context).size.width * .86,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                'お題への回答',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.yellow.shade300,
                  fontFamily: 'ZenAntiqueSoft',
                ),
              ),
            ),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                fillColor: const Color(0xf9fff4ff),
                filled: true,
                hintText: '120字以内で入力',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.pink.shade700,
                    width: 3,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.pink.shade800,
                    width: 3,
                  ),
                ),
              ),
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(120),
              ],
              controller: answerController,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'ニックネーム',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.pink.shade100,
                  fontFamily: 'ZenAntiqueSoft',
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 3),
                  width: 160,
                  height: 31,
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: '12字以内で入力',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.pink.shade200,
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Colors.blueGrey.shade200,
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(12),
                    ],
                    controller: nickNameController,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text('投稿！'),
                    style: ElevatedButton.styleFrom(
                      primary: enableSubmit
                          ? Colors.pink.shade500
                          : Colors.pink.shade200,
                      padding: const EdgeInsets.only(
                        bottom: 2,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: Colors.pink.shade600,
                      ),
                    ),
                    onPressed: enableSubmit
                        ? () {
                            soundEffect.play(
                              'sounds/tap.mp3',
                              isNotification: true,
                              volume: seVolume,
                            );

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              dismissOnTouchOutside: true,
                              dismissOnBackKeyPress: true,
                              showCloseIcon: true,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 550
                                      ? 550
                                      : null,
                              body: OgiriSubmitModal(
                                screenContext: context,
                                answerController: answerController,
                                nickNameController: nickNameController,
                                ogiriId: ogiriId,
                              ),
                            ).show();
                          }
                        : () {},
                  ),
                ),
                const Spacer(),
                const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
