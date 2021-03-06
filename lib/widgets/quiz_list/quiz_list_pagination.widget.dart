import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizListPagination extends HookWidget {
  final ValueNotifier<int> screenNo;
  final int numOfPages;

  const QuizListPagination({
    Key? key,
    required this.screenNo,
    required this.numOfPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          screenNo.value == 0
              ? _dummyBox()
              : _pagingButton(context, screenNo, 0, '<<'),
          screenNo.value == 0
              ? _dummyBox()
              : _pagingButton(context, screenNo, screenNo.value - 1, '<'),
          screenNo.value == numOfPages - 1
              ? _dummyBox()
              : _pagingButton(context, screenNo, screenNo.value + 1, '>'),
          screenNo.value == numOfPages - 1
              ? _dummyBox()
              : _pagingButton(context, screenNo, numOfPages - 1, '>>'),
        ],
      ),
    );
  }

  Widget _pagingButton(
    BuildContext context,
    ValueNotifier<int> screenNo,
    int toScreenNo,
    String icon,
  ) {
    return ElevatedButton(
      onPressed: () => {
        screenNo.value = toScreenNo,
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Text(
          icon,
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey.shade300.withOpacity(0.3),
        textStyle: Theme.of(context).textTheme.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _dummyBox() {
    return const SizedBox(width: 64);
  }
}
