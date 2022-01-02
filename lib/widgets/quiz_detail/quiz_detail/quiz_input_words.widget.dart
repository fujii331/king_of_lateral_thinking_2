import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/quiz_detail_tab/check_question.service.dart';

class QuizInputWords extends HookWidget {
  final Quiz quiz;
  final Question selectedQuestion;
  final List<Question> askingQuestions;
  final TextEditingController subjectController;
  final TextEditingController relatedWordController;

  const QuizInputWords({
    Key? key,
    required this.quiz,
    required this.selectedQuestion,
    required this.askingQuestions,
    required this.subjectController,
    required this.relatedWordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode subjectFocusNode = useFocusNode();
    final FocusNode relatedWordFocusNode = useFocusNode();

    final List<Question> remainingQuestions =
        useProvider(remainingQuestionsProvider).state;

    final int hintStatus = useProvider(hintStatusProvider).state;

    final String? selectedSubject = useProvider(selectedSubjectProvider).state;
    final String? selectedRelatedWord =
        useProvider(selectedRelatedWordProvider).state;

    final ValueNotifier<String> subjectData = useState<String>('');
    final ValueNotifier<String> relatedWordData = useState<String>('');

    subjectFocusNode.addListener(() {
      if (!subjectFocusNode.hasFocus) {
        submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          subjectData,
          relatedWordData,
          hintStatus,
          subjectController.text.trim(),
          relatedWordController.text.trim(),
        );
      }
    });

    relatedWordFocusNode.addListener(() {
      if (!relatedWordFocusNode.hasFocus) {
        submitData(
          context,
          quiz,
          remainingQuestions,
          selectedQuestion,
          askingQuestions,
          subjectData,
          relatedWordData,
          hintStatus,
          subjectController.text.trim(),
          relatedWordController.text.trim(),
        );
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .35 < 210 ? 6 : 12,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // 主語の入力
            _wordSelectForQuestion(
              context,
              selectedSubject,
              selectedSubjectProvider,
              '主語',
              hintStatus,
              quiz.subjects,
              subjectController,
              remainingQuestions,
              selectedQuestion,
              askingQuestions,
              subjectData,
              relatedWordData,
            ),
            const Text(
              'は',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
            // 関連語の入力
            hintStatus < 1
                ? _wordForQuestion(
                    context,
                    '関連語',
                    relatedWordController,
                    relatedWordFocusNode,
                  )
                : _wordSelectForQuestion(
                    context,
                    selectedRelatedWord,
                    selectedRelatedWordProvider,
                    '関連語',
                    hintStatus,
                    quiz.relatedWords,
                    relatedWordController,
                    remainingQuestions,
                    selectedQuestion,
                    askingQuestions,
                    subjectData,
                    relatedWordData,
                  ),
            const Text(
              '...？',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wordForQuestion(
    BuildContext context,
    String text,
    TextEditingController controller,
    FocusNode _focusNode,
  ) {
    final height = MediaQuery.of(context).size.height * .35;

    return Container(
      width: MediaQuery.of(context).size.width * .86 > 650
          ? 250
          : MediaQuery.of(context).size.width * .30,
      height: height < 210 ? 52 : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blueGrey.shade700,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white54.withOpacity(0.3),
            blurRadius: 2.0,
            spreadRadius: 0.1,
            offset: const Offset(1, 1),
          )
        ],
      ),
      child: TextField(
        textAlignVertical: height < 210 ? TextAlignVertical.bottom : null,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: text,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blueGrey.shade700,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue.shade800,
              width: 3.0,
            ),
          ),
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(10),
        ],
        controller: controller,
        focusNode: _focusNode,
      ),
    );
  }

  Widget _wordSelectForQuestion(
    BuildContext context,
    String? selectedWord,
    StateProvider<String> selectedWordProvider,
    String displayHint,
    int hintStatus,
    List<String> wordList,
    TextEditingController controller,
    List<Question> remainingQuestions,
    Question selectedQuestion,
    List<Question> askingQuestions,
    ValueNotifier<String> subjectData,
    ValueNotifier<String> relatedWordData,
  ) {
    final height = MediaQuery.of(context).size.height * .35;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 10,
      ),
      width: MediaQuery.of(context).size.width * .86 > 650
          ? 250
          : MediaQuery.of(context).size.width * .305,
      height: height < 210 ? 50 : 63,
      decoration: BoxDecoration(
        color: hintStatus < 2 ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.circular(16),
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
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: DropdownButton(
          isExpanded: true,
          hint: Text(
            displayHint,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          underline: Container(
            color: Colors.white,
          ),
          value: selectedWord != '' ? selectedWord : null,
          items: hintStatus < 2
              ? wordList.map((String word) {
                  return DropdownMenuItem(
                    value: word,
                    child: Text(word),
                  );
                }).toList()
              : null,
          onChanged: (targetSubject) {
            controller.text = context.read(selectedWordProvider).state =
                targetSubject as String;
            submitData(
              context,
              quiz,
              remainingQuestions,
              selectedQuestion,
              askingQuestions,
              subjectData,
              relatedWordData,
              hintStatus,
              subjectController.text.trim(),
              relatedWordController.text.trim(),
            );
          },
        ),
      ),
    );
  }
}
