import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';

class Questioned extends HookWidget {
  final int quizId;

  const Questioned({
    Key? key,
    required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * .35;
    final List<Question> askedQuestions =
        useProvider(askedQuestionsProvider).state;

    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: Platform.isAndroid ? 93 : 115,
          bottom: Platform.isAndroid ? 15 : 20,
          right: 25,
          left: 25,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  children: [
                    askedQuestions.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(13),
                            child: Text(
                              '質問をすることでここに聞いた質問と返答が追加されていきます。',
                              style: TextStyle(
                                fontSize: height > 210 ? 18 : 16,
                                color: Colors.black54,
                                fontFamily: 'NotoSerifJP',
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                ),
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        minLeadingWidth: 5,
                                        dense: true,
                                        leading: Text(
                                          'Q:',
                                          style: TextStyle(
                                            fontSize:
                                                height > 210 ? 18.0 : 16.0,
                                            color: Colors.black,
                                            fontFamily: 'NotoSerifJP',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        title: Text(
                                          askedQuestions[index].asking,
                                          style: TextStyle(
                                            fontSize: height > 210 ? 18 : 16,
                                            color: Colors.black,
                                            fontFamily: 'NotoSerifJP',
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        minLeadingWidth: 5,
                                        dense: true,
                                        leading: Text(
                                          'A:',
                                          style: TextStyle(
                                            fontSize:
                                                height > 210 ? 18.0 : 16.0,
                                            color: Colors.red.shade800,
                                            fontFamily: 'NotoSerifJP',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        title: Text(
                                          askedQuestions[index].reply,
                                          style: TextStyle(
                                            fontSize: height > 210 ? 18 : 16,
                                            color: Colors.black,
                                            fontFamily: 'NotoSerifJP',
                                          ),
                                        ),
                                      ),
                                      askedQuestions[index].hint != ''
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18),
                                              child: Text(
                                                askedQuestions[index].hint,
                                                style: TextStyle(
                                                  fontSize:
                                                      height > 210 ? 15 : 15,
                                                  color: Colors.orange.shade900,
                                                  fontFamily: 'NotoSerifJP',
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: height > 210 ? 25 : 15,
                                      ),
                                    ],
                                  );
                                },
                                itemCount: askedQuestions.length,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
