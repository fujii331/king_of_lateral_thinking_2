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

    return Stack(
      children: [
        Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xFFFFFFFF),
                quiz.difficulty == 1
                    ? const Color.fromARGB(240, 182, 235, 235)
                    : quiz.difficulty == 2
                        ? const Color.fromARGB(240, 156, 192, 219)
                        : quiz.difficulty == 3
                            ? const Color.fromARGB(240, 218, 151, 164)
                            : const Color(0xF2FFFFFF),
                quiz.difficulty == 1
                    ? const Color.fromARGB(240, 96, 235, 235)
                    : quiz.difficulty == 2
                        ? const Color.fromARGB(240, 84, 170, 236)
                        : quiz.difficulty == 3
                            ? const Color.fromARGB(240, 252, 96, 127)
                            : const Color(0xF2FFFFFF),
              ],
              stops: const [
                0.5,
                0.7,
                0.9,
              ],
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.only(bottom: 13, left: 5, right: 5),
              child: Text(
                '問' + quiz.id.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pink.shade700,
                ),
              ),
            ),
            title: Container(
              padding: const EdgeInsets.only(bottom: 13, right: 5),
              child: Text(
                quiz.title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(
                bottom: 13,
              ),
              width: 70,
              child: quiz.difficulty == 0
                  ? Text(
                      '練習用',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange.shade900,
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
          ),
        ),
        alreadyAnsweredIds.contains(quiz.id.toString())
            ? Container(
                padding: const EdgeInsets.only(
                  top: 7,
                  left: 10,
                ),
                child: Text(
                  'Clear!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
