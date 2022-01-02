import 'package:hooks_riverpod/hooks_riverpod.dart';

final openingNumberProvider = StateProvider((ref) => 0);
final alreadyPlayedQuizFlgProvider = StateProvider((ref) => false);
final alwaysDisplayInputProvider = StateProvider((ref) => false);
final alreadyAnsweredIdsProvider = StateProvider((ref) => <String>[]);
