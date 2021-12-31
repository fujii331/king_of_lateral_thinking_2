class Question {
  final int id;
  final String asking;
  final String reply;
  final String hint;

  const Question({
    required this.id,
    required this.asking,
    required this.reply,
    required this.hint,
  });
}

class Answer {
  final int id;
  final List<int> questionIds;
  final String answer;
  final String comment;

  const Answer({
    required this.id,
    required this.questionIds,
    required this.answer,
    required this.comment,
  });
}

class Quiz {
  final int id;
  final String title;
  final String sentence;
  final List<String> subjects;
  final List<String> relatedWords;
  final List<Question> questions;
  final List<Answer> answers;
  final int hintDisplayQuestionId;
  final List<int> correctAnswerQuestionIds;
  final List<String> subHints;
  final int difficulty;

  const Quiz({
    required this.id,
    required this.title,
    required this.sentence,
    required this.subjects,
    required this.relatedWords,
    required this.questions,
    required this.answers,
    required this.hintDisplayQuestionId,
    required this.correctAnswerQuestionIds,
    required this.subHints,
    required this.difficulty,
  });
}
