import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_answer_list/ogiri_answer_list.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_detail_tab/ogiri_detail/ogiri_detail.widget.dart';

class OgiriDetailTabScreen extends HookWidget {
  static const routeName = '/ogiri-detail-tab';

  const OgiriDetailTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;
    final Ogiri ogiri = args[0] as Ogiri;
    final List<String> goodList = args[1] as List<String>;

    final screenNo = useState<int>(0);
    final pageController = usePageController(initialPage: 0, keepPage: true);

    final String ogiriNickName = useProvider(ogiriNickNameProvider).state;

    final answerController = useTextEditingController();
    final nickNameController = useTextEditingController(text: ogiriNickName);
    final ValueNotifier<bool> sortByDateState = useState<bool>(true);
    final ValueNotifier<List<OgiriAnswer>> ogiriAnswersState =
        useState(ogiri.ogiriAnswers);
    final ValueNotifier<List<String>> goodListState = useState(goodList);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        ogiriAnswersState.value.sort((a, b) => b.dateInt.compareTo(a.dateInt));
      });
      return null;
    }, const []);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/ogiri_detail_back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x15555555),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            ogiri.title,
            style: const TextStyle(
              fontFamily: 'ZenAntiqueSoft',
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.deepPurple.shade500.withOpacity(0.7),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.yellow.shade200,
          unselectedItemColor: Colors.grey.shade200,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: 'お題',
              backgroundColor: Colors.purple.shade800.withOpacity(0.9),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt),
              label: '回答一覧',
              backgroundColor: Colors.purple.shade800.withOpacity(0.9),
            ),
          ],
          onTap: (int selectIndex) {
            screenNo.value = selectIndex;
            pageController.animateToPage(
              selectIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          },
          currentIndex: screenNo.value,
        ),
        body: PageView(
          controller: pageController,
          // ページ切り替え時に実行する処理
          onPageChanged: (index) {
            screenNo.value = index;
          },
          children: [
            OgiriDetail(
              ogiri: ogiri,
              answerController: answerController,
              nickNameController: nickNameController,
            ),
            OgiriAnswerList(
              ogiriAnswersState: ogiriAnswersState,
              ogiriId: ogiri.id,
              goodListState: goodListState,
              sortByDateState: sortByDateState,
            )
          ],
        ),
      ),
    );
  }
}
