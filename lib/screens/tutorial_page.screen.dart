import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/quiz_list.screen.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/tutorial_page/lecture_figure.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/tutorial_page/lecture_first.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/tutorial_page/lecture_last.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialPageScreen extends HookWidget {
  const TutorialPageScreen({Key? key}) : super(key: key);
  static const routeName = '/tutorial-page';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayed =
        ModalRoute.of(context)?.settings.arguments as bool;
    final PageController pageController =
        usePageController(initialPage: 0, keepPage: true);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final ValueNotifier<double> notifier = useState(0);

    final List<Widget> childrenWidget = <Widget>[
      const LectureFirst(),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_1.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_2.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_3.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_4.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_5.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_6.png'),
      const LectureFigure(imagePath: 'assets/images/lecture/lecture_7.png'),
      LectureLast(
        alreadyPlayed: alreadyPlayed,
        soundEffect: soundEffect,
        seVolume: seVolume,
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '遊び方',
          style: TextStyle(
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
          alreadyPlayed
              ? Container()
              : TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    soundEffect.play(
                      'sounds/tap.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    context.read(alreadyPlayedQuizFlgProvider).state = true;
                    prefs.setBool('alreadyPlayedQuiz', true);
                    Navigator.of(context).pushReplacementNamed(
                      QuizListScreen.routeName,
                    );
                  },
                  child: const Text(
                    "skip",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          background('quiz_list_background.jpg'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 90),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    notifier.value = index.toDouble();
                  },
                  children: childrenWidget,
                ),
              ),
              const SizedBox(height: 15),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade800,
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: SlidingIndicator(
                      indicatorCount: childrenWidget.length,
                      notifier: notifier,
                      activeIndicator: const Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      inActiveIndicator: Icon(
                        Icons.circle,
                        color: Colors.grey.shade400,
                      ),
                      margin: 8,
                      inactiveIndicatorSize: 12,
                      activeIndicatorSize: 14,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.white.withOpacity(0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: notifier.value != 0
                                ? const Text(
                                    '←',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 15),
                            child: notifier.value != childrenWidget.length - 1
                                ? const Text(
                                    '→',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Platform.isAndroid ? 0 : 30),
            ],
          ),
        ],
      ),
    );
  }
}
