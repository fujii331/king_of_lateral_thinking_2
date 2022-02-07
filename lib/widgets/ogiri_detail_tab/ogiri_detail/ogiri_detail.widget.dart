import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_detail/ogiri_sentence.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_detail/ogiri_input_area.widget.dart';

class OgiriDetail extends HookWidget {
  final Ogiri ogiri;
  final TextEditingController answerController;
  final TextEditingController nickNameController;

  const OgiriDetail({
    Key? key,
    required this.ogiri,
    required this.answerController,
    required this.nickNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: Platform.isAndroid ? 90 : 120,
              bottom: 16,
              right: 16,
              left: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                OgiriSentence(
                  sentence: ogiri.sentence,
                ),
                QuizInputArea(
                  answerController: answerController,
                  nickNameController: nickNameController,
                  ogiriId: ogiri.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
