import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_answer_list/ogiri_answer_item.widget.dart';

class OgiriAnswerList extends HookWidget {
  final ValueNotifier<List<OgiriAnswer>> ogiriAnswersState;
  final int ogiriId;
  final ValueNotifier<List<String>> goodListState;
  final ValueNotifier<bool> sortByDateState;

  const OgiriAnswerList({
    Key? key,
    required this.ogiriAnswersState,
    required this.ogiriId,
    required this.goodListState,
    required this.sortByDateState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final ValueNotifier<bool> enablePushState = useState(true);

    return Stack(
      children: <Widget>[
        background('ogiri_answer_list_back.jpg'),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              top: Platform.isAndroid ? 93 : 120,
              bottom: Platform.isAndroid ? 15 : 20,
              right: 12,
              left: 12,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 90,
                      height: 40,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('新着'),
                            SizedBox(width: 10),
                            Icon(
                              Icons.sort,
                              size: 20,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: sortByDateState.value
                              ? Colors.lightGreen.shade800
                              : Colors.lightGreen.shade300,
                          padding: const EdgeInsets.only(
                            bottom: 2,
                          ),
                          side: BorderSide(
                            width: 4,
                            color: sortByDateState.value
                                ? Colors.lightGreen.shade900
                                : Colors.lightGreen.shade600,
                          ),
                        ),
                        onPressed: !sortByDateState.value
                            ? () {
                                soundEffect.play(
                                  'sounds/tap.mp3',
                                  isNotification: true,
                                  volume: seVolume,
                                );

                                ogiriAnswersState.value.sort(
                                    (a, b) => b.dateInt.compareTo(a.dateInt));

                                sortByDateState.value = true;
                              }
                            : () {},
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('いいね'),
                            SizedBox(width: 5),
                            Icon(
                              Icons.sort,
                              size: 20,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: !sortByDateState.value
                              ? Colors.deepOrange.shade500
                              : Colors.deepOrange.shade200,
                          padding: const EdgeInsets.only(
                            bottom: 2,
                          ),
                          side: BorderSide(
                            width: 4,
                            color: !sortByDateState.value
                                ? Colors.deepOrange.shade600
                                : Colors.deepOrange.shade300,
                          ),
                        ),
                        onPressed: sortByDateState.value
                            ? () {
                                soundEffect.play(
                                  'sounds/tap.mp3',
                                  isNotification: true,
                                  volume: seVolume,
                                );

                                ogiriAnswersState.value.sort((a, b) =>
                                    b.goodCount.compareTo(a.goodCount));

                                sortByDateState.value = false;
                              }
                            : () {},
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 15),
                        child: OgiriAnswerItem(
                          ogiriAnswersState: ogiriAnswersState,
                          ogiriAnswer: ogiriAnswersState.value[index],
                          ogiriId: ogiriId,
                          goodListState: goodListState,
                          enablePushState: enablePushState,
                          sortByDateState: sortByDateState,
                        ),
                      );
                    },
                    itemCount: ogiriAnswersState.value.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
