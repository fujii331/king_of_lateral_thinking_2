import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';

class QuestionInput extends HookWidget {
  final Question selectedQuestion;
  final List<Question> askingQuestions;
  final Quiz quiz;

  const QuestionInput({
    Key? key,
    required this.selectedQuestion,
    required this.askingQuestions,
    required this.quiz,
  }) : super(key: key);

  void _executeQuestion(
    BuildContext context,
    List<Question> askingQuestions,
    Question selectedQuestion,
    AudioCache soundEffect,
    double seVolume,
  ) {
    context.read(questionCountProvider).state++;
    context.read(replyProvider).state = selectedQuestion.reply;
    context.read(displayReplyFlgProvider).state = true;
    context.read(askedQuestionsProvider).state.add(selectedQuestion);
    context.read(remainingQuestionsProvider).state = context
        .read(remainingQuestionsProvider)
        .state
        .where((question) => question.id != selectedQuestion.id)
        .toList();

    context.read(askingQuestionsProvider).state = askingQuestions
        .where((question) => question.id != selectedQuestion.id)
        .toList();
    context.read(beforeWordProvider).state = selectedQuestion.asking;
    context.read(selectedQuestionProvider).state = dummyQuestion;

    if (selectedQuestion.hint != '') {
      soundEffect.play(
        'sounds/change.mp3',
        isNotification: true,
        volume: seVolume,
      );
    } else {
      soundEffect.play(
        'sounds/quiz_button.mp3',
        isNotification: true,
        volume: seVolume,
      );
    }

    // 正解を導く質問を行い、まだ回答がセットされていない場合判定実行
    if (quiz.correctAnswerQuestionIds.contains(selectedQuestion.id) &&
        context.read(finalAnswerProvider).state.id == 0) {
      // 重要な質問リストに追加
      List<int> importantQuestionedIds =
          context.read(importantQuestionedIdsProvider).state;

      importantQuestionedIds.add(selectedQuestion.id);
      context.read(importantQuestionedIdsProvider).state =
          importantQuestionedIds;

      for (Answer answer in quiz.answers) {
        bool judgeFlg = true;

        for (int questionId in answer.questionIds) {
          if (!importantQuestionedIds.contains(questionId)) {
            judgeFlg = false;
            break;
          }
        }

        if (judgeFlg) {
          context.read(finalAnswerProvider).state = answer;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * .35;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final String beforeWord = useProvider(beforeWordProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: EdgeInsets.only(
        top: height < 210 ? 11 : 16.5,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: height < 220 ? 4 : 7,
                bottom: height < 220 ? 5 : 7,
                right: 10,
                left: 10,
              ),
              width: MediaQuery.of(context).size.width * .86 > 650
                  ? 520
                  : MediaQuery.of(context).size.width * .60,
              height: height < 220 ? 58 : 67,
              decoration: BoxDecoration(
                color:
                    askingQuestions.isEmpty ? Colors.grey[400] : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blueGrey.shade700,
                ),
              ),
              child: DropdownButton(
                isExpanded: true,
                hint: Text(
                  beforeWord.isEmpty ? '' : beforeWord,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
                underline: Container(
                  color: Colors.white,
                ),
                value: selectedQuestion.id != 0 ? selectedQuestion : null,
                items: askingQuestions.map((Question question) {
                  return DropdownMenuItem(
                    value: question,
                    child: Text(question.asking),
                  );
                }).toList(),
                onChanged: (targetQuestion) {
                  context.read(displayReplyFlgProvider).state = false;
                  context.read(selectedQuestionProvider).state =
                      targetQuestion as Question;
                },
              ),
            ),
            SizedBox(
              width: 75,
              height: 40,
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text('質問！'),
                ),
                style: ElevatedButton.styleFrom(
                  primary: selectedQuestion.id != 0
                      ? Colors.blue.shade700
                      : Colors.blue.shade200,
                  textStyle: Theme.of(context).textTheme.button,
                  padding: const EdgeInsets.only(
                    bottom: 2,
                  ),
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    width: 2,
                    color: Colors.blue.shade800,
                  ),
                ),
                onPressed: selectedQuestion.id != 0
                    ? () {
                        _executeQuestion(
                          context,
                          askingQuestions,
                          selectedQuestion,
                          soundEffect,
                          seVolume,
                        );
                      }
                    : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
