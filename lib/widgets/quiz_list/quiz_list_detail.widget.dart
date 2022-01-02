import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/data/quiz_data_original.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
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
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;
    final int openingNumber = useProvider(openingNumberProvider).state;
    final bool allQuizCleared = alreadyAnsweredIds.length >= openingNumber;

    final double width = MediaQuery.of(context).size.width > 400
        ? 360
        : MediaQuery.of(context).size.width * 0.9;

    return Container(
      height: 465,
      width: width,
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
              ? Container(
                  margin: EdgeInsets.only(
                    top: openingNumber % 6 == 0 ? 93 : 275,
                  ),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueGrey.shade600,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.80,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/list_tile/tile_cover.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: allQuizCleared
                              ? () {
                                  soundEffect.play(
                                    'sounds/hint.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  );
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.QUESTION,
                                    headerAnimationLoop: false,
                                    animType: AnimType.BOTTOMSLIDE,
                                    width: MediaQuery.of(context).size.width *
                                                .86 >
                                            650
                                        ? 650
                                        : null,
                                    body: AdvertisingModal(
                                      quizId: openingNumber,
                                      screenContext: context,
                                    ),
                                  ).show();
                                }
                              : () {},
                          child: allQuizCleared
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 465,
                                  child: Stack(
                                    children: <Widget>[
                                      Text(
                                        'タップして問題を開放！',
                                        style: TextStyle(
                                          fontFamily: 'KaiseiOpti',
                                          fontSize: 20,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 6.5
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'タップして問題を開放！',
                                        style: TextStyle(
                                          fontFamily: 'KaiseiOpti',
                                          fontSize: 20,
                                          foreground: Paint()
                                            ..color = Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                      !allQuizCleared
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 465,
                                child: Stack(
                                  children: <Widget>[
                                    Text(
                                      'すべての問題をクリアしよう！',
                                      style: TextStyle(
                                        fontFamily: 'KaiseiOpti',
                                        fontSize: 20,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 6.5
                                          ..color = Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'すべての問題をクリアしよう！',
                                      style: TextStyle(
                                        fontFamily: 'KaiseiOpti',
                                        fontSize: 20,
                                        foreground: Paint()
                                          ..color = Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
