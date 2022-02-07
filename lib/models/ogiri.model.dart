import 'package:firebase_database/firebase_database.dart';

class OgiriAnswer {
  final String answerId;
  final String answer;
  final String nickName;
  final int dateInt;
  final int goodCount;

  const OgiriAnswer({
    required this.answerId,
    required this.answer,
    required this.nickName,
    required this.dateInt,
    required this.goodCount,
  });
}

class Ogiri {
  final int id;
  final String title;
  final String sentence;
  final int totalGoodCount;
  final List<OgiriAnswer> ogiriAnswers;

  const Ogiri({
    required this.id,
    required this.title,
    required this.sentence,
    required this.totalGoodCount,
    required this.ogiriAnswers,
  });
}

class FirebaseOgiriAnswer {
  final String answer;
  final String nickName;
  final int dateInt;
  final int goodCount;
  final int allowed;

  const FirebaseOgiriAnswer({
    required this.answer,
    required this.nickName,
    required this.dateInt,
    required this.goodCount,
    required this.allowed,
  });

  factory FirebaseOgiriAnswer.fromJson(Map json) {
    return FirebaseOgiriAnswer(
      answer: json['answer'] as String,
      nickName: json['nickName'] as String,
      dateInt: json['dateInt'] as int,
      goodCount: json['goodCount'] as int,
      allowed: json['allowed'] as int,
    );
  }
}
