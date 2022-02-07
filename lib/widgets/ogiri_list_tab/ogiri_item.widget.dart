import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/ogiri_detail_tab.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OgiriItem extends HookWidget {
  final Ogiri ogiri;
  final bool isOdd;
  final int ogiriNo;

  const OgiriItem({
    Key? key,
    required this.ogiri,
    required this.isOdd,
    required this.ogiriNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final double height = MediaQuery.of(context).size.height;
    final bool heightOk = height > 580;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 2,
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/list_tile/tile_' +
              (isOdd ? 'odd' : 'even') +
              '.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            soundEffect.play(
              'sounds/tap.mp3',
              isNotification: true,
              volume: seVolume,
            );

            SharedPreferences prefs = await SharedPreferences.getInstance();

            final List<String> goodList =
                prefs.getStringList('ogiri_' + ogiri.id.toString()) ?? [];

            Navigator.of(context)
                .pushNamed(OgiriDetailTabScreen.routeName, arguments: [
              ogiri,
              goodList,
            ]);
          },
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 6.5),
              child: Text(
                'お題' + ogiriNo.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: heightOk ? 18 : 16,
                  color: Colors.deepOrange.shade800,
                  fontFamily: 'ZenAntiqueSoft',
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5.5),
              child: Text(
                ogiri.title,
                style: TextStyle(
                  fontSize: heightOk ? 19 : 17,
                  color: Colors.grey.shade900,
                  fontFamily: 'ZenAntiqueSoft',
                ),
              ),
            ),
            trailing: SizedBox(
              width: 65,
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 23,
                        width: 10,
                        child: Icon(
                          Icons.list,
                          color: Colors.grey.shade900,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        height: 23,
                        width: 10,
                        child: Icon(
                          Icons.thumb_up,
                          color: Colors.pink.shade700,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const SizedBox(height: 1),
                      SizedBox(
                        height: 22,
                        width: 40,
                        child: Text(
                          ogiri.ogiriAnswers.length.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      SizedBox(
                        height: 22,
                        width: 40,
                        child: Text(
                          ogiri.totalGoodCount.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
