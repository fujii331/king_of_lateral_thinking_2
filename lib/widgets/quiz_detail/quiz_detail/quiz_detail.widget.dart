import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_detail/question_input.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_detail/question_reply.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_detail/quiz_input_words.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_detail/quiz_sentence.widget.dart';

class QuizDetail extends HookWidget {
  final Quiz quiz;
  final TextEditingController subjectController;
  final TextEditingController relatedWordController;

  const QuizDetail({
    Key? key,
    required this.quiz,
    required this.subjectController,
    required this.relatedWordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Question selectedQuestion =
        useProvider(selectedQuestionProvider).state;

    final List<Question> askingQuestions =
        useProvider(askingQuestionsProvider).state;

    final String reply = useProvider(replyProvider).state;

    final bool displayReplyFlg = useProvider(displayReplyFlgProvider).state;
    final bool alwaysDisplayInput =
        useProvider(alwaysDisplayInputProvider).state;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: <Widget>[
          alwaysDisplayInput
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/background/back_neby.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : background('quiz_datail_tab_back.jpg'),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 85,
                  bottom: 16,
                  right: 16,
                  left: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    QuizSentence(
                      sentence: quiz.sentence,
                    ),
                    QuizInputWords(
                      quiz: quiz,
                      selectedQuestion: selectedQuestion,
                      askingQuestions: askingQuestions,
                      subjectController: subjectController,
                      relatedWordController: relatedWordController,
                    ),
                    QuestionInput(
                      selectedQuestion: selectedQuestion,
                      askingQuestions: askingQuestions,
                      quiz: quiz,
                    ),
                    QuestionReply(
                      displayReplyFlg: displayReplyFlg,
                      reply: reply,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
