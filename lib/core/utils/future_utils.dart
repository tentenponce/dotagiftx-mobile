import 'package:injectable/injectable.dart';

abstract interface class FutureUtils {
  /// Delays the execution of the future for the given [duration].
  Future<void> delayed(Duration duration);
}

@LazySingleton(as: FutureUtils)
class FutureUtilsImpl implements FutureUtils {
  @override
  Future<void> delayed(Duration duration) async {
    await Future<void>.delayed(duration);
  }
}
