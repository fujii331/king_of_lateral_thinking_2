import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:king_of_lateral_thinking_2/models/ogiri.model.dart';

final openingNumberProvider = StateProvider((ref) => 0);
final alreadyPlayedQuizProvider = StateProvider((ref) => false);
final alreadyPlayedOgiriProvider = StateProvider((ref) => false);
final alreadyAnsweredIdsProvider = StateProvider((ref) => <String>[]);
final enableBrowseOgiriListProvider = StateProvider((ref) => <String>[]);
final allOgiriListProvider = StateProvider((ref) => <Ogiri>[]);
final ogiriNickNameProvider = StateProvider((ref) => '');
