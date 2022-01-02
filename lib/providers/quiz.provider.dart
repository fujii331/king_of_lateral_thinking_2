import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';

final remainingQuestionsProvider = StateProvider((ref) => <Question>[]);
final askedQuestionsProvider = StateProvider((ref) => <Question>[]);
final hintStatusProvider = StateProvider((ref) => 0);
final subHintOpenedProvider = StateProvider((ref) => false);
final playingQuizIdProvider = StateProvider((ref) => 0);
final relatedWordCountProvider = StateProvider((ref) => 0);
final questionCountProvider = StateProvider((ref) => 0);

final selectedQuestionProvider = StateProvider((ref) => dummyQuestion);
final replyProvider = StateProvider((ref) => '');
final beforeWordProvider = StateProvider((ref) => '');
final displayReplyFlgProvider = StateProvider((ref) => false);
final selectedSubjectProvider = StateProvider((ref) => '');
final selectedRelatedWordProvider = StateProvider((ref) => '');
final askingQuestionsProvider = StateProvider((ref) => <Question>[]);
final importantQuestionedIdsProvider = StateProvider((ref) => <int>[]);
final finalAnswerProvider = StateProvider((ref) => dummyAnswer);

const dummyQuestion = Question(asking: '', id: 0, reply: '', hint: '');
const dummyAnswer = Answer(id: 0, questionIds: [], answer: '', comment: '');
