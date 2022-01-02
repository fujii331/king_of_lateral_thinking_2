import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:king_of_lateral_thinking_2/models/analytics.model.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/modal_close_button.widget.dart';

class AnalyticsModal extends HookWidget {
  final Analytics data;

  const AnalyticsModal({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              '正解者の統計データ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 18,
            ),
            child: Text(
              'ヒント使用率',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'SawarabiGothic',
                color: Colors.blue.shade600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _analyticsItem(
                  'ヒント1',
                  data.hint1.toString() + '%',
                  false,
                ),
                _analyticsItem(
                  'ヒント2以上',
                  data.hint2.toString() + '%',
                  false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _analyticsItem(
                  'サブヒント',
                  data.subHint.toString() + '%',
                  false,
                ),
                _analyticsItem(
                  'ヒント未使用',
                  data.noHint.toString() + '%',
                  true,
                ),
              ],
            ),
          ),
          _analyticsCount(
            '関連語の入力回数',
            data.relatedWordCountYou.toString() + '回',
            data.relatedWordCountAll == 0
                ? '正解者なし'
                : data.relatedWordCountAll.toString() + '回',
          ),
          _analyticsCount(
            '質問回数',
            data.questionCountYou.toString() + '回',
            data.questionCountAll == 0
                ? '正解者なし'
                : data.questionCountAll.toString() + '回',
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              // '※「みんな」はヒント未使用者の平均\n※データは過去の特定集計期間のもの',
              '※「みんな」はヒント未使用者の平均',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'SawarabiGothic',
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const ModalCloseButton(),
        ],
      ),
    );
  }

  Widget _analyticsCount(
    String title,
    String itemYourCount,
    String itemAllCount,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'SawarabiGothic',
                color: Colors.blue.shade600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _analyticsItem(
                  'あなた',
                  itemYourCount,
                  false,
                ),
                _analyticsItem(
                  'みんな',
                  itemAllCount,
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsItem(
    String itemName,
    String itemInfo,
    bool colorFlg,
  ) {
    return Column(
      children: [
        Text(
          itemName,
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'SawarabiGothic',
            color: colorFlg ? Colors.orange.shade800 : Colors.grey.shade700,
          ),
        ),
        Text(
          itemInfo,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
