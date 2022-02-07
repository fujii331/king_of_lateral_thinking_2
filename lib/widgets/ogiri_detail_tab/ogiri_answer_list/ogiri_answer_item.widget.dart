import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OgiriAnswerItem extends HookWidget {
  final ValueNotifier<List<OgiriAnswer>> ogiriAnswersState;
  final OgiriAnswer ogiriAnswer;
  final int ogiriId;
  final ValueNotifier<List<String>> goodListState;
  final ValueNotifier<bool> enablePushState;
  final ValueNotifier<bool> sortByDateState;

  const OgiriAnswerItem({
    Key? key,
    required this.ogiriAnswersState,
    required this.ogiriAnswer,
    required this.ogiriId,
    required this.goodListState,
    required this.enablePushState,
    required this.sortByDateState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final List<Ogiri> allOgiriList = useProvider(allOgiriListProvider).state;
    final String dateString = ogiriAnswer.dateInt.toString();

    final ValueNotifier<bool> goodDoneState = useState(false);
    final ValueNotifier<int> goodCountState = useState(0);

    final double width = MediaQuery.of(context).size.width;
    final bool widthOk = width > 330;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        goodCountState.value = ogiriAnswer.goodCount;
        goodDoneState.value =
            goodListState.value.contains(ogiriAnswer.answerId.toString());
      });
      return null;
    }, [ogiriAnswersState, sortByDateState.value]);

    return Container(
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blueGrey.shade700,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 6,
          bottom: 8,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  dateString.substring(0, 4) +
                      '/' +
                      dateString.substring(4, 6) +
                      '/' +
                      dateString.substring(6, 8),
                  style: TextStyle(
                    fontSize: widthOk ? 11 : 10,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  ogiriAnswer.nickName,
                  style: TextStyle(
                    fontSize: widthOk ? 13 : 11.5,
                    color: Colors.blueGrey.shade900,
                    fontFamily: 'ZenAntiqueSoft',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: IconButton(
                      iconSize: 20,
                      icon: Icon(
                        Icons.thumb_up,
                        color: goodDoneState.value
                            ? Colors.pink.shade400
                            : Colors.grey.shade400,
                      ),
                      onPressed: enablePushState.value
                          ? () async {
                              enablePushState.value = false;

                              soundEffect.play(
                                'sounds/' +
                                    (goodDoneState.value
                                        ? 'tap.mp3'
                                        : 'change.mp3'),
                                isNotification: true,
                                volume: seVolume,
                              );

                              final int addValue = goodDoneState.value ? -1 : 1;

                              goodCountState.value += addValue;

                              List<OgiriAnswer> updatedOgiriAnswers = [];

                              final List<Ogiri> updatedOgiriList =
                                  allOgiriList.map((eachOgiri) {
                                if (eachOgiri.id == ogiriId) {
                                  // 回答を更新
                                  updatedOgiriAnswers = eachOgiri.ogiriAnswers
                                      .map((eachOgiriAnswer) {
                                    if (eachOgiriAnswer.answerId ==
                                        ogiriAnswer.answerId) {
                                      return OgiriAnswer(
                                        answerId: eachOgiriAnswer.answerId,
                                        answer: eachOgiriAnswer.answer,
                                        nickName: eachOgiriAnswer.nickName,
                                        dateInt: eachOgiriAnswer.dateInt,
                                        goodCount: eachOgiriAnswer.goodCount +
                                            addValue,
                                      );
                                    } else {
                                      return eachOgiriAnswer;
                                    }
                                  }).toList();

                                  return Ogiri(
                                    id: eachOgiri.id,
                                    title: eachOgiri.title,
                                    sentence: eachOgiri.sentence,
                                    totalGoodCount:
                                        eachOgiri.totalGoodCount + addValue,
                                    ogiriAnswers: updatedOgiriAnswers,
                                  );
                                } else {
                                  return eachOgiri;
                                }
                              }).toList();

                              // 大喜利のリストを更新
                              ogiriAnswersState.value = updatedOgiriAnswers;
                              context.read(allOgiriListProvider).state =
                                  updatedOgiriList;

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (goodDoneState.value) {
                                goodListState.value
                                    .remove(ogiriAnswer.answerId.toString());
                              } else {
                                goodListState.value
                                    .add(ogiriAnswer.answerId.toString());
                              }

                              await prefs.setStringList(
                                'ogiri_' + ogiriId.toString(),
                                goodListState.value,
                              );

                              goodDoneState.value = !goodDoneState.value;

                              DatabaseReference firebaseInstance =
                                  FirebaseDatabase.instance.ref().child(
                                      'ogiri/' +
                                          ogiriId.toString() +
                                          '/' +
                                          ogiriAnswer.answerId.toString());

                              await firebaseInstance
                                  .get()
                                  .then((DataSnapshot? snapshot) async {
                                final Map firebaseData = snapshot!.value as Map;

                                FirebaseOgiriAnswer firebaseOgiriAnswer =
                                    FirebaseOgiriAnswer.fromJson(firebaseData);

                                await FirebaseDatabase.instance
                                    .ref()
                                    .child('ogiri/' +
                                        ogiriId.toString() +
                                        '/' +
                                        ogiriAnswer.answerId.toString())
                                    .set(
                                  {
                                    'answer': ogiriAnswer.answer,
                                    'nickName': ogiriAnswer.nickName,
                                    'dateInt': ogiriAnswer.dateInt,
                                    'goodCount': firebaseOgiriAnswer.goodCount +
                                        addValue,
                                    'allowed': 1,
                                  },
                                ).catchError((_) {
                                  // 何もしない
                                });
                              });

                              enablePushState.value = true;
                            }
                          : () {}),
                ),
                Text(
                  goodCountState.value.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                ogiriAnswer.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'ZenAntiqueSoft',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
