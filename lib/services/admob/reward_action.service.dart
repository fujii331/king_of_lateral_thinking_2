import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:king_of_lateral_thinking_2/models/quiz.model.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/quiz.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/comment_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_detail/hint/opened_sub_hint_modal.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/quiz_list/new_questions_reply_modal.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showNewQuestionsRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
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
          secondText: '新たな問題を取得できませんでした。\n再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
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
  });
  rewardAd.value = null;
}

void showHintRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  Quiz quiz,
  TextEditingController subjectController,
  TextEditingController relatedWordController,
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
          secondText: 'ヒントを取得できませんでした。\n再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
    onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      afterGotHint(
        context,
        quiz,
        subjectController,
        relatedWordController,
      );
    },
  );
  rewardAd.value = null;
}

void showSubHintRewardedAd(
  BuildContext context,
  ValueNotifier<RewardedAd?> rewardAd,
  List<String> subHints,
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
          secondText: 'サブヒントを取得できませんでした。\n再度お試しください。',
          closeButtonFlg: true,
        ),
      ).show();
    },
  );
  rewardAd.value!.setImmersiveMode(true);
  rewardAd.value!.show(
    onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      afterGotSubHint(
        context,
        subHints,
      );
    },
  );
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

void afterGotHint(
  BuildContext context,
  Quiz quiz,
  TextEditingController subjectController,
  TextEditingController relatedWordController,
) {
  final int hint = context.read(hintStatusProvider).state;

  final List<Question> askedQuestions =
      context.read(askedQuestionsProvider).state;

  final List<int> currentQuestionIds = askedQuestions.map((askedQuestion) {
    return askedQuestion.id;
  }).toList();

  AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    headerAnimationLoop: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: CommentModal(
      topText: hint == 0
          ? 'ヒント1解放！'
          : hint == 1
              ? 'ヒント2解放！'
              : 'ヒント3解放！',
      secondText: hint == 0
          ? '関連語を選択肢で選べるようになりました。'
          : hint == 1
              ? '質問を選択肢で選べるようになりました。'
              : '正解を導く質問のみ選べるようになりました。',
      closeButtonFlg: true,
    ),
  ).show();
  context.read(hintStatusProvider).state++;
  context.read(selectedQuestionProvider).state = dummyQuestion;
  context.read(displayReplyFlgProvider).state = false;
  if (hint >= 1) {
    context.read(beforeWordProvider).state = '↓質問を選択';
    if (hint == 1) {
      context.read(askingQuestionsProvider).state = _shuffle(quiz.questions
          .take(quiz.hintDisplayQuestionId)
          .where((question) => !currentQuestionIds.contains(question.id))
          .toList());
    } else if (hint == 2) {
      context.read(askingQuestionsProvider).state = quiz.questions
          .where((question) =>
              quiz.correctAnswerQuestionIds.contains(question.id) &&
              !currentQuestionIds.contains(question.id))
          .toList();
    }
    if (context.read(askingQuestionsProvider).state.isEmpty) {
      context.read(beforeWordProvider).state = 'もう質問はありません。';
    }
  } else {
    subjectController.text = '';
    relatedWordController.text = '';
    context.read(beforeWordProvider).state = '';
    context.read(askingQuestionsProvider).state = [];
    context.read(selectedSubjectProvider).state = '';
    context.read(selectedRelatedWordProvider).state = '';
  }
}

List<Question> _shuffle(List<Question> items) {
  var random = Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

void afterGotSubHint(
  BuildContext context,
  List<String> subHints,
) {
  context.read(subHintOpenedProvider).state = true;
  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: OpenedSubHintModal(
      subHints: subHints,
    ),
  ).show();
}
