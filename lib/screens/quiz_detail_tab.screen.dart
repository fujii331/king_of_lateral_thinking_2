import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/services/admob/interstitial_action.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/hint/hint_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/hint/opened_sub_hint_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/hint/sub_hint_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/questioned/questioned.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_answer/quiz_answer.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/quiz_detail/quiz_detail.widget.dart';

class QuizDetailTabScreen extends HookWidget {
  static const routeName = '/quiz-detail-tab';

  final Quiz quiz;

  const QuizDetailTabScreen({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  // const QuizDetailTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    // final Quiz quiz = ModalRoute.of(context)?.settings.arguments as Quiz;

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);
    final bool subHintOpened = useProvider(subHintOpenedProvider).state;
    final int hintStatus = useProvider(hintStatusProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final ValueNotifier<int> workHintState = useState<int>(0);

    final subjectController = useTextEditingController();
    final relatedWordController = useTextEditingController();

    final Answer finalAnswer = useProvider(finalAnswerProvider).state;

    final bool enableAnswer = finalAnswer.id != 0;

    final ValueNotifier<InterstitialAd?> interstitialAd = useState(null);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // 広告読み込み
        interstitialLoading(
          interstitialAd,
        );
      });
      return null;
    }, const []);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/images/background/quiz_datail_tab_back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x15555555),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            quiz.title,
            style: const TextStyle(
              fontFamily: 'KaiseiOpti',
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade800.withOpacity(0.6),
          actions: <Widget>[
            IconButton(
              iconSize: 22,
              icon: Icon(
                subHintOpened ? Icons.info : Icons.lightbulb,
                color: Colors.orange.shade400,
              ),
              onPressed: subHintOpened
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        headerAnimationLoop: false,
                        animType: AnimType.SCALE,
                        width: MediaQuery.of(context).size.width * .86 > 550
                            ? 550
                            : null,
                        body: OpenedSubHintModal(
                          subHints: quiz.subHints,
                        ),
                      ).show();
                    }
                  : () {
                      soundEffect.play(
                        'sounds/hint.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        animType: AnimType.BOTTOMSLIDE,
                        width: MediaQuery.of(context).size.width * .86 > 550
                            ? 550
                            : null,
                        body: SubHintModal(
                          screenContext: context,
                          subHints: quiz.subHints,
                          quizId: quiz.id,
                        ),
                      ).show();
                    },
            ),
            IconButton(
              icon: const Icon(
                Icons.lightbulb,
                color: Colors.yellow,
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/hint.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                workHintState.value = hintStatus;
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.QUESTION,
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  width: MediaQuery.of(context).size.width * .86 > 550
                      ? 550
                      : null,
                  body: HintModal(
                    screenContext: context,
                    quiz: quiz,
                    subjectController: subjectController,
                    relatedWordController: relatedWordController,
                    workHintValue: workHintState.value,
                  ),
                ).show();
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.yellow.shade200,
          unselectedItemColor: Colors.grey.shade200,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: '質問',
              backgroundColor: Colors.indigo.shade700.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt),
              label: '質問済',
              backgroundColor: Colors.indigo.shade700.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.campaign,
                color:
                    enableAnswer ? Colors.pink.shade300 : Colors.grey.shade700,
              ),
              label: '解答',
              backgroundColor: Colors.indigo.shade700.withOpacity(0.5),
            ),
          ],
          onTap: (int selectIndex) {
            if (selectIndex != 2 || enableAnswer) {
              screenNo.value = selectIndex;
              pageController.animateToPage(
                selectIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
            }
          },
          currentIndex: screenNo.value,
        ),
        body: PageView(
            controller: pageController,
            // ページ切り替え時に実行する処理
            onPageChanged: (index) {
              if (index != 2 || enableAnswer) {
                screenNo.value = index;
              }
            },
            children: enableAnswer
                ? [
                    QuizDetail(
                      quiz: quiz,
                      subjectController: subjectController,
                      relatedWordController: relatedWordController,
                    ),
                    Questioned(
                      quizId: quiz.id,
                    ),
                    QuizAnswer(
                      quizId: quiz.id,
                      interstitialAd: interstitialAd,
                    ),
                  ]
                : [
                    QuizDetail(
                      quiz: quiz,
                      subjectController: subjectController,
                      relatedWordController: relatedWordController,
                    ),
                    Questioned(
                      quizId: quiz.id,
                    ),
                  ]),
      ),
    );
  }
}
