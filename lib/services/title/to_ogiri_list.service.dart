import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/ogiri_list_tab.screen.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/comment_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/loading_modal.widget.dart';

void toOgiriList(
  BuildContext context,
  bool isTutorial,
) async {
  // ロード中モーダルの表示
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingModal();
    },
  );

  DatabaseReference firebaseInstance =
      FirebaseDatabase.instance.ref().child('ogiri/');

  Map ogiriData = {};

  await firebaseInstance.get().then((DataSnapshot? snapshot) async {
    if (snapshot != null) {
      List snapshotData = snapshot.value as List;
      final firebaseData = snapshotData.where((data) => data != null).toList();

      int currentOgiriId = 1;

      for (Map eachOgiriIdData in firebaseData) {
        List<OgiriAnswer> ogiriAnswers = [];
        int totalGoodCount = 0;

        eachOgiriIdData.forEach((key, data) {
          FirebaseOgiriAnswer firebaseOgiriAnswer =
              FirebaseOgiriAnswer.fromJson(data);

          if (firebaseOgiriAnswer.allowed == 1) {
            totalGoodCount += firebaseOgiriAnswer.goodCount;

            ogiriAnswers.add(
              OgiriAnswer(
                answerId: key,
                answer: firebaseOgiriAnswer.answer,
                nickName: firebaseOgiriAnswer.nickName,
                dateInt: firebaseOgiriAnswer.dateInt,
                goodCount: firebaseOgiriAnswer.goodCount,
              ),
            );
          }
        });

        ogiriData[currentOgiriId.toString()] = [ogiriAnswers, totalGoodCount];
        currentOgiriId++;
      }

      final List<Ogiri> allOgiriList =
          context.read(allOgiriListProvider).state.map((value) {
        final List targetOgiri = ogiriData[value.id.toString()];

        return Ogiri(
          id: value.id,
          title: value.title,
          sentence: value.sentence,
          totalGoodCount: targetOgiri[1],
          ogiriAnswers: targetOgiri[0],
        );
      }).toList();

      // 大喜利のリストを設定
      context.read(allOgiriListProvider).state = allOgiriList;

      Navigator.pop(context);

      if (isTutorial) {
        Navigator.of(context).pushReplacementNamed(
          OgiriListTabScreen.routeName,
        );
      } else {
        Navigator.of(context).pushNamed(
          OgiriListTabScreen.routeName,
        );
      }
    }
  }).catchError((_) {
    Navigator.pop(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: true,
      showCloseIcon: true,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: const CommentModal(
        topText: '情報取得失敗',
        secondText: '大喜利の取得に失敗しました。\n電波の良いところで再度お試しください。',
        closeButtonFlg: true,
      ),
    ).show();
  });
}
