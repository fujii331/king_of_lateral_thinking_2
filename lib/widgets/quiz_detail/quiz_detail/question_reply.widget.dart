import 'package:flutter/material.dart';

class QuestionReply extends StatelessWidget {
  final bool displayReplyFlg;
  final String reply;

  const QuestionReply({
    Key? key,
    required this.displayReplyFlg,
    required this.reply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: size.height * .35 < 210 ? 12 : 16.5,
      ),
      child: Container(
        height: size.height * .35 < 200 ? 66 : 80,
        width: size.width * .86 > 650 ? 650 : size.width * .86,
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(0.8),
          border: Border.all(
            color: Colors.indigo.shade700,
            width: 5,
          ),
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: displayReplyFlg ? 1 : 0,
          child: Text(
            reply,
            style: TextStyle(
              fontSize: size.height * .35 > 200 ? 18 : 16,
              color: Colors.white,
              fontFamily: 'NotoSerifJP',
            ),
          ),
        ),
      ),
    );
  }
}
