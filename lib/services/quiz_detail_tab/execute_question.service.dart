import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';

void executeQuestion(
  BuildContext context,
  List<Question> askingQuestions,
  Question selectedQuestion,
  AudioCache soundEffect,
  double seVolume,
  Quiz quiz,
) {
  context.read(questionCountProvider).state++;
  context.read(replyProvider).state = selectedQuestion.reply;
  context.read(displayReplyFlgProvider).state = true;
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

  if (selectedQuestion.hint == '') {
    soundEffect.play(
      'sounds/quiz_button.mp3',
      isNotification: true,
      volume: seVolume,
    );
  }

  // 正解を導く質問を行った場合、判定実行
  if (quiz.correctAnswerQuestionIds.contains(selectedQuestion.id)) {
    bool gotFinalAnswer = false;
    // 重要な質問リストに追加
    List<int> importantQuestionedIds =
        context.read(importantQuestionedIdsProvider).state;

    importantQuestionedIds.add(selectedQuestion.id);
    context.read(importantQuestionedIdsProvider).state = importantQuestionedIds;

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
        gotFinalAnswer = true;

        break;
      }
    }

    if (gotFinalAnswer) {
      soundEffect.play(
        'sounds/got_final_answer.mp3',
        isNotification: true,
        volume: seVolume,
      );
      if (context.read(finalAnswerProvider).state.questionIds.length > 1) {
        selectedQuestion = Question(
          id: selectedQuestion.id,
          asking: selectedQuestion.asking,
          reply: selectedQuestion.reply,
          hint: 'ピンポイントの質問ですね。',
        );
      }
    } else {
      soundEffect.play(
        'sounds/change.mp3',
        isNotification: true,
        volume: seVolume,
      );
    }
  }

  context.read(askedQuestionsProvider).state.add(selectedQuestion);
}
