import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/comment_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OgiriSubmitModal extends HookWidget {
  final BuildContext screenContext;
  final TextEditingController answerController;
  final TextEditingController nickNameController;
  final int ogiriId;

  const OgiriSubmitModal({
    Key? key,
    required this.screenContext,
    required this.answerController,
    required this.nickNameController,
    required this.ogiriId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final ValueNotifier<bool> enablePush = useState(true);

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '投稿前確認',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            child: Text(
              '回答',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'ZenAntiqueSoft',
                color: Colors.orange.shade700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.90),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blueGrey.shade700,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                  top: 0,
                  bottom: 10,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    answerController.text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      height: 1.7,
                      fontFamily: 'ZenAntiqueSoft',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            child: Text(
              'ニックネーム',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'ZenAntiqueSoft',
                color: Colors.pink.shade700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.pink.shade800,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              nickNameController.text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.7,
                fontFamily: 'ZenAntiqueSoft',
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            child: const Text(
              '※製作陣による確認作業を行います。内容によっては掲載されない場合もあることを予めご了承下さい。',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                height: 1.7,
                fontFamily: 'NotoSerifJP',
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 120,
            height: 40,
            child: ElevatedButton(
              child: const Text('回答を投稿'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade600,
                padding: const EdgeInsets.only(
                  bottom: 2,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.red.shade700,
                ),
              ),
              onPressed: enablePush.value
                  ? () async {
                      enablePush.value = false;
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      FirebaseDatabase.instance
                          .ref()
                          .child('ogiri/' + ogiriId.toString())
                          .push()
                          .set(
                        {
                          'answer': answerController.text,
                          'nickName': nickNameController.text,
                          'dateInt': int.parse(DateFormat('yyyyMMddHHmmss')
                              .format(DateTime.now())),
                          'goodCount': 0,
                          'allowed': 0,
                        },
                      ).then((_) async {
                        // ニックネームを保持
                        screenContext.read(ogiriNickNameProvider).state =
                            nickNameController.text;

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        prefs.setString(
                            'ogiriNickName', nickNameController.text);
                        // 提出が来たのを確認用
                        FirebaseDatabase.instance
                            .ref()
                            .child('ogiri_submitted/' + ogiriId.toString())
                            .push()
                            .set(
                          {
                            'answer': answerController.text,
                            'nickName': nickNameController.text,
                            'dateInt': int.parse(DateFormat('yyyyMMddHHmmss')
                                .format(DateTime.now())),
                          },
                        ).catchError((_) {
                          // 何もしない
                        });

                        answerController.text = '';

                        Navigator.pop(context);

                        AwesomeDialog(
                          context: screenContext,
                          dialogType: DialogType.NO_HEADER,
                          headerAnimationLoop: false,
                          animType: AnimType.SCALE,
                          width: MediaQuery.of(screenContext).size.width * .86 >
                                  650
                              ? 650
                              : null,
                          body: const CommentModal(
                            topText: '回答を投稿しました！',
                            secondText: '製作陣による確認の後に追加致します！\nしばしお待ちください。',
                            closeButtonFlg: true,
                          ),
                        ).show();
                      }).catchError((_) {
                        Navigator.pop(context);

                        AwesomeDialog(
                          context: screenContext,
                          dialogType: DialogType.NO_HEADER,
                          headerAnimationLoop: false,
                          dismissOnTouchOutside: true,
                          dismissOnBackKeyPress: true,
                          showCloseIcon: true,
                          animType: AnimType.SCALE,
                          width: MediaQuery.of(screenContext).size.width * .86 >
                                  550
                              ? 550
                              : null,
                          body: const CommentModal(
                            topText: '投稿失敗',
                            secondText: '回答の投稿に失敗しました。\n電波の良いところで再度お試しください。',
                            closeButtonFlg: true,
                          ),
                        ).show();
                      });
                    }
                  : () {},
            ),
          ),
        ],
      ),
    );
  }
}
