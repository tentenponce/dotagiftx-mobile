import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';

abstract interface class DebouncerUtils {
  // The time to wait before running the action
  int get milliseconds;

  // Set the time to wait before running the action
  set milliseconds(int value);

  // Cancel the action
  void cancel();

  // Run the action after the time has passed
  void run(VoidCallback action);
}

@LazySingleton(as: DebouncerUtils)
class DebouncerUtilsImpl implements DebouncerUtils {
  Timer? _timer;

  @override
  int milliseconds = 1000;

  @override
  void cancel() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  void run(VoidCallback action) {
    cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
