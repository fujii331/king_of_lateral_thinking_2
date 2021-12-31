import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/input_mode_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/quiz_list_detail.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/quiz_list_pagination.widget.dart';

class QuizListScreen extends HookWidget {
  const QuizListScreen({Key? key}) : super(key: key);
  static const routeName = '/quiz-list';

  @override
  Widget build(BuildContext context) {
    final screenNo = useState<int>(0);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final int openingNumber = useProvider(openingNumberProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int numOfPages = ((openingNumber + 1) / 6).ceil();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: const Text(
          '問題一覧',
          style: TextStyle(
            fontFamily: 'KaiseiOpti',
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade800.withOpacity(0.5),
        actions: <Widget>[
          PopupMenuButton<int>(
            elevation: 20,
            shape: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 2,
              ),
            ),
            onSelected: (int result) {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              if (result == 1) {
                // Navigator.of(context).pushNamed(
                //   LectureTabScreen.routeName,
                //   arguments: true,
                // );
              } else if (result == 2) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  headerAnimationLoop: false,
                  animType: AnimType.SCALE,
                  width: MediaQuery.of(context).size.width * .86 > 650
                      ? 650
                      : null,
                  body: const InputModeModal(),
                ).show();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: Text('遊び方'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('入力時設定'),
              ),
            ],
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          background('quiz_list_background.jpg'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              QuizListDetail(
                openingNumber: openingNumber,
                screenNo: screenNo,
                numOfPages: numOfPages,
              ),
              const Spacer(),
              const SizedBox(height: 10),
              QuizListPagination(
                screenNo: screenNo,
                numOfPages: numOfPages,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
