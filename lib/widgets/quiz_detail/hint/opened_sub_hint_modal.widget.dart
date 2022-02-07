import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/modal_close_button.widget.dart';

class OpenedSubHintModal extends HookWidget {
  final List<String> subHints;

  const OpenedSubHintModal({
    Key? key,
    required this.subHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '謎を解く鍵となる情報',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'SawarabiGothic',
            ),
          ),
          const SizedBox(height: 20),
          _subHintRow(context, subHints[0]),
          const SizedBox(height: 20),
          _subHintRow(context, subHints[1]),
          const SizedBox(height: 20),
          _subHintRow(context, subHints[2]),
          const SizedBox(height: 25),
          const ModalCloseButton(),
        ],
      ),
    );
  }

  Widget _subHintRow(
    BuildContext context,
    String subHintText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '・ ',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'SawarabiGothic',
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .86 > 550
              ? 380
              : MediaQuery.of(context).size.width * .50,
          child: Text(
            subHintText,
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'SawarabiGothic',
            ),
          ),
        ),
      ],
    );
  }
}
