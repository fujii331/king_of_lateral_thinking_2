import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/quiz_detail_tab.screen.dart';

class QuizItem extends HookWidget {
  final Quiz quiz;
  final bool cannotPlay;
  final ValueNotifier<bool> updateFlgState;

  const QuizItem({
    Key? key,
    required this.quiz,
    required this.cannotPlay,
    required this.updateFlgState,
  }) : super(key: key);

  void toQuizDetail(
    BuildContext context,
    ValueNotifier<bool> updateFlg,
  ) {
    if (context.read(playingQuizIdProvider).state != quiz.id) {
      context.read(remainingQuestionsProvider).state = quiz.questions;
      context.read(askedQuestionsProvider).state = [];
      context.read(hintStatusProvider).state = 0;
      context.read(subHintOpenedProvider).state = false;
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(playingQuizIdProvider).state = quiz.id;
      context.read(relatedWordCountProvider).state = 0;
      context.read(questionCountProvider).state = 0;
      context.read(importantQuestionedIdsProvider).state = [];
      context.read(finalAnswerProvider).state = dummyAnswer;
    }

    context.read(replyProvider).state = '';
    context.read(displayReplyFlgProvider).state = false;
    context.read(selectedSubjectProvider).state = '';
    context.read(selectedRelatedWordProvider).state = '';

    if (context.read(hintStatusProvider).state < 2) {
      context.read(askingQuestionsProvider).state = [];
      context.read(beforeWordProvider).state = '';
    }

    // Navigator.of(context)
    //     .pushNamed(QuizDetailTabScreen.routeName, arguments: quiz);
    pushWithReloadByReturn(context, updateFlgState);
  }

  void pushWithReloadByReturn(
    BuildContext context,
    ValueNotifier<bool> updateFlgState,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => QuizDetailTabScreen(
          quiz: quiz,
        ),
      ),
    );

    if (result != null && result) {
      updateFlgState.value = !updateFlgState.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    final double height = MediaQuery.of(context).size.height;
    final bool heightOk = height > 580;

    return Padding(
      padding: EdgeInsets.only(top: heightOk ? 14 : 9),
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blueGrey.shade600,
                width: 1,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/list_tile/tile_' +
                    (quiz.difficulty + 0).toString() +
                    '.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: cannotPlay
                    ? null
                    : () {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        toQuizDetail(
                          context,
                          updateFlgState,
                        );
                      },
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.only(
                      bottom: Platform.isAndroid ? 11 : 8,
                      left: heightOk ? 5 : 0,
                      right: heightOk ? 5 : 0,
                    ),
                    child: Text(
                      '問' + quiz.id.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: heightOk ? 20 : 18,
                        color: Colors.pink.shade100,
                        fontFamily: 'KaiseiOpti',
                      ),
                    ),
                  ),
                  title: Container(
                    padding: EdgeInsets.only(
                      bottom: Platform.isAndroid ? 11 : 8,
                      right: heightOk ? 5 : 0,
                    ),
                    child: Text(
                      quiz.title,
                      style: TextStyle(
                        fontSize: heightOk ? 20 : 18,
                        color: Colors.blueGrey.shade100,
                        fontFamily: 'KaiseiOpti',
                      ),
                    ),
                  ),
                  trailing: Container(
                    padding:
                        EdgeInsets.only(bottom: quiz.difficulty == 0 ? 11 : 9),
                    width: 70,
                    child: quiz.difficulty == 0
                        ? Text(
                            '練習用',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange.shade200,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'KaiseiOpti',
                            ),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 22,
                                color: Colors.yellow.shade400,
                              ),
                              quiz.difficulty > 1
                                  ? Icon(
                                      Icons.star,
                                      size: 22,
                                      color: Colors.yellow.shade500,
                                    )
                                  : Container(),
                              quiz.difficulty > 2
                                  ? Icon(
                                      Icons.star,
                                      size: 22,
                                      color: Colors.yellow.shade600,
                                    )
                                  : Container(),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          alreadyAnsweredIds.contains(quiz.id.toString())
              ? Container(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Clear!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.yellow.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
