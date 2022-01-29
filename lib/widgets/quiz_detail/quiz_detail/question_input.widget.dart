import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/execute_question.service.dart';

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
                bottom: height < 220 ? 5 : 6,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54.withOpacity(0.4),
                    blurRadius: 4.0,
                    spreadRadius: 0.2,
                    offset: const Offset(1, 1),
                  )
                ],
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
                        executeQuestion(
                          context,
                          askingQuestions,
                          selectedQuestion,
                          soundEffect,
                          seVolume,
                          quiz,
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
