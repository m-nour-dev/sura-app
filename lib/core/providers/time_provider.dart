import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time_provider.g.dart';

@riverpod
Stream<DateTime> timeTick(TimeTickRef ref) {
  // Emit current time immediately
  final controller = StreamController<DateTime>();
  controller.add(DateTime.now());

  // Then emit every minute at the start of the next minute
  final timer = Timer.periodic(const Duration(minutes: 1), (_) {
    if (!controller.isClosed) {
      controller.add(DateTime.now());
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
}
