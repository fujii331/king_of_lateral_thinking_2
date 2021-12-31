import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/data/quiz_data_original.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/advertising_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/quiz_item.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/quiz_item_none.widget.dart';

class QuizListDetail extends HookWidget {
  final int openingNumber;
  final ValueNotifier<int> screenNo;
  final int numOfPages;

  const QuizListDetail({
    Key? key,
    required this.openingNumber,
    required this.screenNo,
    required this.numOfPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    const List<Quiz> quizData = quizDataOriginal;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Container(
      height: 455,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      child: Stack(
        children: [
          ListView.builder(
            itemBuilder: (ctx, index) {
              int quizNumber = index + 6 * (screenNo.value);
              return quizNumber < openingNumber
                  ? QuizItem(
                      quiz: quizData[quizNumber],
                      cannotPlay: false,
                    )
                  : openingNumber < quizData.length
                      ? QuizItem(
                          quiz: quizData[quizNumber],
                          cannotPlay: true,
                        )
                      : quizNumber == quizData.length
                          ? QuizItemNone(quizNum: openingNumber + 1)
                          : Container();
            },
            itemCount:
                screenNo.value + 1 == numOfPages && openingNumber % 6 == 0
                    ? 3
                    : 6,
          ),
          screenNo.value + 1 == numOfPages && openingNumber != quizData.length
              ? Opacity(
                  opacity: 0.85,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: openingNumber % 6 == 0 ? 88 : 275,
                      left: 5,
                      right: 5,
                    ),
                    child: InkWell(
                      onTap: () => {
                        soundEffect.play(
                          'sounds/hint.mp3',
                          isNotification: true,
                          volume: seVolume,
                        ),
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.QUESTION,
                          headerAnimationLoop: false,
                          animType: AnimType.BOTTOMSLIDE,
                          width: MediaQuery.of(context).size.width * .86 > 650
                              ? 650
                              : null,
                          body: AdvertisingModal(
                            quizId: openingNumber,
                            screenContext: context,
                          ),
                        )..show(),
                      },
                      child: Container(
                        height: 169,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'タップして問題を開放！',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
