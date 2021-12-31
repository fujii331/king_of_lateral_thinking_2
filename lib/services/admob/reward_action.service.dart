import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/comment_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/new_questions_reply_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  int rewardNumber,
) {
  if (rewardAd.value == null) {
    return;
  }
  rewardAd.value!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (RewardedAd ad) {
      ad.dispose();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      ad.dispose();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
        body: const CommentModal(
          topText: '取得失敗',
          secondText: '報酬を取得できませんでした。\n電波の良いところで再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
    // 問題解放の場合
    if (rewardNumber == 1) {
      getNewQuestionsAction(context);
    }
  });
  rewardAd.value = null;
}

void createRewardedAd(
  ValueNotifier<RewardedAd?> rewardedAd,
  int _numRewardedLoadAttempts,
  int rewardNumber,
) {
  RewardedAd.load(
    // adUnitId: Platform.isAndroid
    //     ? rewardNumber == 1
    //         ? androidNewQuestionsRewardAdvid
    //         : androidHintRewardAdvid
    //     : rewardNumber == 1
    //         ? iosNewQuestionsRewardAdvid
    //         : iosHintRewardAdvid,
    adUnitId: RewardedAd.testAdUnitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        rewardedAd.value = ad;
        _numRewardedLoadAttempts = 0;
      },
      onAdFailedToLoad: (LoadAdError error) {
        rewardedAd.value = null;
        _numRewardedLoadAttempts += 1;
        if (_numRewardedLoadAttempts <= 3) {
          createRewardedAd(
            rewardedAd,
            _numRewardedLoadAttempts,
            rewardNumber,
          );
        }
      },
    ),
  );
}

Future rewardLoading(
  ValueNotifier<RewardedAd?> rewardedAd,
  int rewardNumber,
) async {
  int _numRewardedLoadAttempts = 0;
  createRewardedAd(
    rewardedAd,
    _numRewardedLoadAttempts,
    rewardNumber,
  );
  for (int i = 0; i < 15; i++) {
    if (rewardedAd.value != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
}

Future getNewQuestionsAction(
  BuildContext context,
) async {
  final int openQuizNumber = context.read(openingNumberProvider).state + 3;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setInt('openingNumber', openQuizNumber);

  context.read(openingNumberProvider).state = openQuizNumber;

  AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    headerAnimationLoop: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: NewQuestionsReplyModal(
      openQuizNumber: openQuizNumber,
    ),
  ).show();
}
