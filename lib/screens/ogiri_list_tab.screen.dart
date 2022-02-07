import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';
import 'package:king_of_lateral_thinking_2/providers/common.provider.dart';
import 'package:king_of_lateral_thinking_2/providers/player.provider.dart';
import 'package:king_of_lateral_thinking_2/screens/ogiri_tutorial.screen.dart';
import 'package:king_of_lateral_thinking_2/widgets/common/background.widget.dart';
import 'package:king_of_lateral_thinking_2/widgets/ogiri_list_tab/each_ogiri_list.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OgiriListTabScreen extends HookWidget {
  const OgiriListTabScreen({Key? key}) : super(key: key);
  static const routeName = '/ogiri-list-tab';

  @override
  Widget build(BuildContext context) {
    // 曜日（月：1、日：7）
    final int weekday = DateTime.now().weekday;

    final screenNo = useState<int>(weekday - 1);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final List<String> enableBrowseOgiriList =
        useProvider(enableBrowseOgiriListProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final pageController =
        usePageController(initialPage: weekday - 1, keepPage: true);
    final List<Ogiri> allOgiriList = useProvider(allOgiriListProvider).state;
    final List<Ogiri> ogiriListMonday = allOgiriList.take(10).toList();
    final List<Ogiri> ogiriListTuesday =
        allOgiriList.skip(10).take(10).toList();
    final List<Ogiri> ogiriListWednesday =
        allOgiriList.skip(20).take(10).toList();
    final List<Ogiri> ogiriListThursday =
        allOgiriList.skip(30).take(10).toList();
    final List<Ogiri> ogiriListFriday = allOgiriList.skip(40).take(10).toList();
    final List<Ogiri> ogiriListSaturday =
        allOgiriList.skip(50).take(10).toList();
    final List<Ogiri> ogiriListSunday = allOgiriList.skip(60).take(9).toList();

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // 大喜利を閲覧できる場合、判定に入る
        if (enableBrowseOgiriList.isNotEmpty) {
          // 日時
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // 日時
          final String todayString =
              DateFormat('yyyy/MM/dd').format(DateTime.now());
          final String dataString =
              prefs.getString('dataString') ?? todayString;

          if (dataString != todayString) {
            // 大喜利を閲覧できても日にちが変わっていたらリセット
            prefs.setString('dataString', todayString);
            prefs.setStringList('enableBrowseOgiriList', []);
            context.read(enableBrowseOgiriListProvider).state = [];
          }
        }
      });
      return null;
    }, const []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: const Text(
          '大喜利一覧',
          style: TextStyle(
            fontFamily: 'YujiSyuku',
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade500.withOpacity(0.6),
        actions: <Widget>[
          IconButton(
            iconSize: 28,
            icon: Icon(
              Icons.help,
              color: Colors.grey.shade100,
              size: 27,
            ),
            onPressed: () {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              Navigator.of(context).pushNamed(
                OgiriTutorialScreen.routeName,
                arguments: true,
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.yellow.shade300,
        unselectedItemColor: Colors.grey.shade400,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.bedtime),
            label: '月',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_fire_department),
            label: '火',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            // icon: const SizedBox.shrink(),
            icon: const Icon(Icons.water),
            label: '水',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.park),
            label: '木',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.attach_money),
            label: '金',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.terrain),
            label: '土',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.wb_sunny),
            label: '日',
            backgroundColor: Colors.purple.shade900.withOpacity(0.8),
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
      body: Stack(
        children: [
          background('ogiri_list_background.jpg'),
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              screenNo.value = index;
            },
            children: [
              EachOgiriList(
                ogiriList: ogiriListMonday,
                enableBrowse:
                    enableBrowseOgiriList.contains('1') || weekday == 1,
                firstNo: 1,
                targetWeekDay: '1',
              ),
              EachOgiriList(
                ogiriList: ogiriListTuesday,
                enableBrowse:
                    enableBrowseOgiriList.contains('2') || weekday == 2,
                firstNo: 11,
                targetWeekDay: '2',
              ),
              EachOgiriList(
                ogiriList: ogiriListWednesday,
                enableBrowse:
                    enableBrowseOgiriList.contains('3') || weekday == 3,
                firstNo: 21,
                targetWeekDay: '3',
              ),
              EachOgiriList(
                ogiriList: ogiriListThursday,
                enableBrowse:
                    enableBrowseOgiriList.contains('4') || weekday == 4,
                firstNo: 31,
                targetWeekDay: '4',
              ),
              EachOgiriList(
                ogiriList: ogiriListFriday,
                enableBrowse:
                    enableBrowseOgiriList.contains('5') || weekday == 5,
                firstNo: 41,
                targetWeekDay: '5',
              ),
              EachOgiriList(
                ogiriList: ogiriListSaturday,
                enableBrowse:
                    enableBrowseOgiriList.contains('6') || weekday == 6,
                firstNo: 51,
                targetWeekDay: '6',
              ),
              EachOgiriList(
                ogiriList: ogiriListSunday,
                enableBrowse:
                    enableBrowseOgiriList.contains('7') || weekday == 7,
                firstNo: 61,
                targetWeekDay: '7',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
