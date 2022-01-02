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

  const QuizItem({
    Key? key,
    required this.quiz,
    required this.cannotPlay,
  }) : super(key: key);

  void toQuizDetail(
    BuildContext context,
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

    Navigator.of(context)
        .pushNamed(QuizDetailTabScreen.routeName, arguments: quiz);
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<String> alreadyAnsweredIds =
        useProvider(alreadyAnsweredIdsProvider).state;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
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
                        toQuizDetail(context);
                      },
                child: ListTile(
                  leading: Container(
                    padding:
                        const EdgeInsets.only(bottom: 11, left: 5, right: 5),
                    child: Text(
                      '問' + quiz.id.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.pink.shade100,
                      ),
                    ),
                  ),
                  title: Container(
                    padding: const EdgeInsets.only(bottom: 11, right: 5),
                    child: Text(
                      quiz.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey.shade100,
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
