import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_list_tab/ogiri_advertising_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_list_tab/ogiri_item.widget.dart';

class EachOgiriList extends HookWidget {
  final List<Ogiri> ogiriList;
  final bool enableBrowse;
  final int firstNo;
  final String targetWeekDay;

  const EachOgiriList({
    Key? key,
    required this.ogiriList,
    required this.enableBrowse,
    required this.firstNo,
    required this.targetWeekDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 400
        ? 360
        : MediaQuery.of(context).size.width * 0.9;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final ValueNotifier<bool> enableBrowseState = useState(enableBrowse);
    final double listHeight = MediaQuery.of(context).size.height - 230 > 660
        ? 660
        : MediaQuery.of(context).size.height - 230;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 90 : 120),
        child: Container(
          height: listHeight,
          width: width,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                    child: OgiriItem(
                      ogiri: ogiriList[index],
                      isOdd: index % 2 == 1,
                      ogiriNo: firstNo + index,
                    ),
                  );
                },
                itemCount: ogiriList.length,
              ),
              !enableBrowseState.value
                  ? Stack(
                      children: [
                        Opacity(
                          opacity: 0.80,
                          child: Container(
                            height: listHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/list_tile/tile_cover.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(3),
                            onTap: () {
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
                                width: MediaQuery.of(context).size.width * .86 >
                                        550
                                    ? 550
                                    : null,
                                body: OgiriAdvertisingModal(
                                  screenContext: context,
                                  targetWeekDay: targetWeekDay,
                                  enableBrowseState: enableBrowseState,
                                ),
                              ).show();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: listHeight,
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    'タップして閲覧制限を解除！',
                                    style: TextStyle(
                                      fontFamily: 'ZenAntiqueSoft',
                                      fontSize: 20,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 6.5
                                        ..color = Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'タップして閲覧制限を解除！',
                                    style: TextStyle(
                                      fontFamily: 'ZenAntiqueSoft',
                                      fontSize: 20,
                                      foreground: Paint()..color = Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
