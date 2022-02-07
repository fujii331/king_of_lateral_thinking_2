import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/ogiri_list_tab.screen.dart';
import 'package:king_of_lateral_thinking_2/services/title/to_ogiri_list.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OgiriTutorialScreen extends HookWidget {
  const OgiriTutorialScreen({Key? key}) : super(key: key);
  static const routeName = '/ogiri-tutorial';

  @override
  Widget build(BuildContext context) {
    final bool alreadyPlayed =
        ModalRoute.of(context)?.settings.arguments as bool;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '水平思考大喜利とは',
          style: TextStyle(
            fontFamily: 'YujiSyuku',
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
                    context.read(alreadyPlayedOgiriProvider).state = true;
                    prefs.setBool('alreadyPlayedOgiri', true);
                    toOgiriList(context, true);
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
          background('lecture_back.png'),
          Padding(
            padding: EdgeInsets.only(top: Platform.isAndroid ? 90 : 120),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(0, 0, 0, 0.6),
                ),
                height: MediaQuery.of(context).size.height * .9 > 630
                    ? 630
                    : MediaQuery.of(context).size.height * .9,
                width: MediaQuery.of(context).size.width * .92,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'こちらは前作「謎解きの王様」で出てきた69問の水平思考クイズを使って遊ぶモードです。\n',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: 'NotoSerifJP',
                            height: 1.7,
                          ),
                        ),
                        Text(
                          '全く同じ問題文で他にどんな面白い答えが浮かぶのか？',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade200,
                            height: 1.7,
                          ),
                        ),
                        const Text(
                          'というテーマで、皆さんに答えを募集しています。\n\n・この問題文ならこっちの答えの方が納得しない？\n・この回答はお笑いセンスがあって面白い！\nといったような回答を募集しています。',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: 'NotoSerifJP',
                            height: 1.7,
                          ),
                        ),
                        const Text(
                          '\nオンライン上の誰でも自分が作った回答を閲覧することができるので、みんながいいねしたくなるような回答を投稿してみましょう！',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: 'NotoSerifJP',
                            height: 1.7,
                          ),
                        ),
                        Text(
                          '\n※問題の本来の答えが気になる方は前作「謎解きの王様」をプレイしてみてください！',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey.shade300,
                            height: 1.7,
                          ),
                        ),
                        alreadyPlayed
                            ? Container()
                            : Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Center(
                                    child: SizedBox(
                                      width: 130,
                                      height: 40,
                                      child: ElevatedButton(
                                        child: const Text('大喜利一覧へ'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green.shade600,
                                          padding: const EdgeInsets.only(
                                            bottom: 2,
                                          ),
                                          shape: const StadiumBorder(),
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          soundEffect.play(
                                            'sounds/tap.mp3',
                                            isNotification: true,
                                            volume: seVolume,
                                          );
                                          context
                                              .read(alreadyPlayedOgiriProvider)
                                              .state = true;
                                          prefs.setBool(
                                              'alreadyPlayedOgiri', true);
                                          toOgiriList(context, true);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
