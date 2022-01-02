import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TitleWord extends HookWidget {
  final ValueNotifier<bool> displayFlg;

  const TitleWord({
    Key? key,
    required this.displayFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30.0),
            height: 265,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: <Widget>[
                            Text(
                              '謎解きの王様2',
                              style: TextStyle(
                                fontFamily: 'KaiseiOpti',
                                fontSize: 45,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 7
                                  ..color = Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              '謎解きの王様2',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontFamily: 'YuseiMagic',
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: <Color>[
                                      Colors.yellow.shade300,
                                      Colors.orange.shade300,
                                      Colors.pink.shade200,
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(
                                      0.0,
                                      100.0,
                                      250.0,
                                      70.0,
                                    ),
                                  ),
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(8.0, 8.0),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Stack(
                          children: <Widget>[
                            Text(
                              '一人用水平思考クイズ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'KaiseiOpti',
                                fontSize: 23.5,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 8
                                  ..color = Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              '一人用水平思考クイズ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: 'KaiseiOpti',
                                fontSize: 23.0,
                                foreground: Paint()..color = Colors.white,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
