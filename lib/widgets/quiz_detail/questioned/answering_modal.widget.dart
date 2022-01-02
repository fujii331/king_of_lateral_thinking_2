import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';

import '../../../providers/common.provider.dart';

class AnsweringModal extends HookWidget {
  final String imageNumber;

  const AnsweringModal({
    Key? key,
    required this.imageNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final Answer finalAnswer = useProvider(finalAnswerProvider).state;

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        displayFlg1.value = true;
        soundEffect.play(
          'sounds/answer.mp3',
          isNotification: true,
          volume: seVolume,
        );
        await Future.delayed(
          const Duration(seconds: 1),
        );
        displayFlg2.value = true;
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: Theme.of(context)
            .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
        child: SimpleDialog(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: displayFlg2.value ? 1 : 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width > 800
                            ? 650
                            : MediaQuery.of(context).size.width * .86,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white54,
                              blurRadius: 12.0,
                              spreadRadius: 0.1,
                              offset: Offset(4, 4),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                            top: 4,
                            bottom: 10,
                          ),
                          child: Text(
                            finalAnswer.answer,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              height: 1.7,
                              fontFamily: 'NotoSerifJP',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg1.value ? 1 : 0,
                    child: Image.asset(
                      'assets/images/answer_' + imageNumber + '.png',
                      height: 250,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
