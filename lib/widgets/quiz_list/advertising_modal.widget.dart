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

class AdvertisingModal extends HookWidget {
  final int quizId;
  final BuildContext screenContext;

  const AdvertisingModal({
    Key? key,
    required this.quizId,
    required this.screenContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final ValueNotifier<RewardedAd?> rewardedAd = useState(null);

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text(
              '短い動画を見て3つの問題を取得しますか？',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'SawarabiGothic',
              ),
            ),
          ),
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
                  onPressed: () async {
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
                      1,
                    );
                    if (rewardedAd.value != null) {
                      showNewQuestionsRewardedAd(
                        screenContext,
                        rewardedAd,
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
                        width: MediaQuery.of(context).size.width * .86 > 550
                            ? 550
                            : null,
                        body: const CommentModal(
                          topText: '取得失敗',
                          secondText: '動画の読み込みに失敗しました。\n電波の良いところで再度お試しください。',
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
