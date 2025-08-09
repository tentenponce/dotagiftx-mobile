import 'package:dotagiftx_mobile/core/utils/future_utils.dart';
import 'package:injectable/injectable.dart';

abstract interface class RetryUtils {
  static const int defaultRetry = 3;
  static const int defaultDelayInSeconds = 5;
  static const Duration defaultDelay = Duration(seconds: defaultDelayInSeconds);

  /// Invokes the [action] and retries if it fails
  /// after certain retries.
  ///
  /// Support customizing action when error encountered in each attempt, as well as the delay between each retry.
  ///
  /// - [action] The action to be invoked
  /// - [onError] The custom action to be invoked when error encountered
  /// - [onUpdateDelay] The custom delay to be used before the next invocation of [action] when an error encountered
  /// - [maxRetry] The maximum number of retries
  /// - [delay] The delay between each retry
  Future<T?> invoke<T>({
    required Future<T> Function() action,
    void Function(Object error)? onError,
    Duration Function(int retryCount)? onUpdateDelay,
    bool Function(Object error)? retryIf,
    int maxRetry,
    Duration delay,
  });
}

@LazySingleton(as: RetryUtils)
class RetryUtilsImpl implements RetryUtils {
  final FutureUtils _futureUtils;

  RetryUtilsImpl(this._futureUtils);

  @override
  Future<T?> invoke<T>({
    required Future<T> Function() action,
    void Function(Object error)? onError,
    Duration Function(int retryCount)? onUpdateDelay,
    bool Function(Object error)? retryIf,
    int maxRetry = RetryUtils.defaultRetry,
    Duration delay = RetryUtils.defaultDelay,
  }) async {
    T? result;
    var retryCounter = 0;
    Object? error;
    StackTrace? stackTrace;

    while (retryCounter < maxRetry) {
      try {
        result = await action();

        // break loop if action is success
        break;
      } catch (e, st) {
        // check if we need to retry
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }

        retryCounter++;

        error = e;
        stackTrace = st;

        final effectiveDelay = onUpdateDelay?.call(retryCounter) ?? delay;

        await _futureUtils.delayed(effectiveDelay);

        // handle errors optionally
        if (onError != null) {
          onError(e);
        }
      }
    }

    // if there's an error and max retry reached
    if (error != null && stackTrace != null && retryCounter >= maxRetry) {
      Error.throwWithStackTrace(error, stackTrace);
    }

    return result;
  }
}
