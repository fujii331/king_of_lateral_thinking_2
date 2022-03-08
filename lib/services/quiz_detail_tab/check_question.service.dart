import 'dart:math';

// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/data/restriction_words.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';

void checkQuestions(
  BuildContext context,
  String subject,
  String relatedWord,
  List<Question> remainingQuestions,
  List<String> allSubjects,
  List<Question> askingQuestions,
) {
  // 質問文のうち、関連語が含まれていて、関連語から始まっていない質問を抽出
  final List<Question> includeRelatedWordQuestions = remainingQuestions
      .where((question) => question.asking
          // 主語以外で判定
          .substring(question.asking.indexOf('は') + 1)
          .contains(relatedWord))
      .toList();

  // 対象の関連語では質問が見つからなかった場合
  // 質問が5個以上見つかった場合
  // 使用禁止用語を使っていた場合
  if (includeRelatedWordQuestions.isEmpty ||
      includeRelatedWordQuestions.length > 5 ||
      restrictionWords.contains(relatedWord)) {
    // 選択した主語から始まる質問を抽出
    final enableQuestionsCount = remainingQuestions
        .where((question) => question.asking.startsWith(subject))
        .toList()
        .length;

    if (enableQuestionsCount == 0) {
      context.read(beforeWordProvider).state = 'その主語ではもう質問できないようです。';
    } else {
      final randomNumber = Random().nextInt(3);
      if (randomNumber == 0) {
        context.read(beforeWordProvider).state = '質問が見つかりませんでした。';
      } else {
        context.read(beforeWordProvider).state =
            'その主語を使う質問は' + enableQuestionsCount.toString() + '個あります。';
      }
    }

    context.read(askingQuestionsProvider).state = [];
  } else {
    // 該当の関連語を使用する質問が見つかった場合
    // 抽出した質問のうち、選択した主語から始まる質問を抽出
    final List<Question> includeSubjectQuestions = includeRelatedWordQuestions
        .where((question) => question.asking.startsWith(subject))
        .toList();

    // 対象の主語では質問が見つからなかった場合
    if (includeSubjectQuestions.isEmpty) {
      context.read(beforeWordProvider).state = '主語だけ変えれば質問できそう！';
      context.read(askingQuestionsProvider).state = [];
    } else {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(beforeWordProvider).state = '↓質問を選択';
      context.read(askingQuestionsProvider).state = includeSubjectQuestions;
    }
  }
}

void submitData(
  BuildContext context,
  Quiz quiz,
  List<Question> remainingQuestions,
  Question selectedQuestion,
  List<Question> askingQuestions,
  ValueNotifier<String> subjectData,
  ValueNotifier<String> relatedWordData,
  int hintStatus,
  String enteredSubject,
  String enteredRelatedWord,
) {
  if (subjectData.value != enteredSubject ||
      relatedWordData.value != enteredRelatedWord) {
    // 前回の言葉を初期化
    context.read(beforeWordProvider).state = '';
    // 返答を非表示にする
    context.read(displayReplyFlgProvider).state = false;

    // 主語か関連語が空白だったら初期化
    if (enteredSubject.isEmpty || enteredRelatedWord.isEmpty) {
      context.read(selectedQuestionProvider).state = dummyQuestion;
      context.read(askingQuestionsProvider).state = [];

      return;
    }

    // 関連語入力回数を増やす
    if (relatedWordData.value != enteredRelatedWord) {
      context.read(relatedWordCountProvider).state++;
    }
    // ヒントを使っていなかったらサーバーに保存
    // if (quiz.id > 37 && hintStatus == 0) {
    //   FirebaseDatabase.instance
    //       .ref()
    //       .child('input_words/' +
    //           quiz.id.toString() +
    //           '/' +
    //           enteredSubject +
    //           '/' +
    //           enteredRelatedWord)
    //       .push()
    //       .set(
    //     {
    //       'time': DateTime.now().toString(),
    //     },
    //   );
    // }

    subjectData.value = enteredSubject;
    relatedWordData.value = enteredRelatedWord;
  }
  checkQuestions(
    context,
    enteredSubject,
    enteredRelatedWord,
    remainingQuestions,
    quiz.subjects,
    askingQuestions,
  );
}
