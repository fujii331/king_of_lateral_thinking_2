import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/services/admob/reward_action.service.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/comment_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/loading_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/modal_do_not_watch_button.widget.dart';

class SubHintModal extends HookWidget {
  final BuildContext screenContext;
  final List<String> subHints;
  final int quizId;

  const SubHintModal({
    Key? key,
    required this.screenContext,
    required this.subHints,
    required this.quizId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final ValueNotifier<RewardedAd?> rewardedAd = useState(null);

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            quizId == 1 ? '短い動画を見ずにサブヒントを取得しますか？' : '短い動画を見てサブヒントを取得しますか？',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'SawarabiGothic',
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            '謎を解く鍵となる情報を取得できます。',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'SawarabiGothic',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '※自分の力でもっと考えたい人におすすめ',
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'SawarabiGothic',
            ),
          ),
          quizId == 1
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '※問1は動画を見ずにサブヒントを取得できます！',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'SawarabiGothic',
                      color: Colors.orange.shade900,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 15),
          Wrap(
            children: [
              const ModalDoNotWatchButton(),
              const SizedBox(width: 30),
              SizedBox(
                width: 70,
                height: 40,
                child: ElevatedButton(
                  child: const Text('見る'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade600,
                    padding: const EdgeInsets.only(
                      bottom: 2,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      width: 2,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  onPressed: quizId == 1
                      ? () {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          Navigator.pop(context);
                          afterGotSubHint(
                            screenContext,
                            subHints,
                          );
                        }
                      : () async {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          // ロード中モーダルの表示
                          showDialog<int>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const LoadingModal();
                            },
                          );
                          // 広告のロード
                          await rewardLoading(
                            rewardedAd,
                            2,
                          );
                          if (rewardedAd.value != null) {
                            showSubHintRewardedAd(
                              screenContext,
                              rewardedAd,
                              subHints,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              dismissOnTouchOutside: true,
                              dismissOnBackKeyPress: true,
                              showCloseIcon: true,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 550
                                      ? 550
                                      : null,
                              body: const CommentModal(
                                topText: '取得失敗',
                                secondText:
                                    '動画の読み込みに失敗しました。\n電波の良いところで再度お試しください。',
                                closeButtonFlg: true,
                              ),
                            ).show();
                          }
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
