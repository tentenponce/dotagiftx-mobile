import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';

mixin CubitErrorMixin<State> on BaseCubit<State> {
  Logger get logger;

  Future<void> cubitHandler<R>(
    Future<R> Function() call,
    Future<void> Function(R resp) onSuccess, {
    Future<void> Function(Object? e)? onError,
  }) async {
    logger.log(LogLevel.info, 'Calling... $call');
    try {
      final response = await call();

      if (!isClosed) {
        logger.log(LogLevel.info, 'Success calling: $call');
        await onSuccess(response);
      }
    } catch (e, st) {
      if (!isClosed) {
        onError != null
            ? await onError(e)
            : await defaultErrorHandler(call, e, st);
      }
    }
  }

  Future<T?> defaultErrorHandler<T extends Object?>(
    Future<T?> Function() call,
    Object? exception,
    StackTrace? stackTrace,
  ) {
    // TODO(tenten): Implement default error handler
    logger.log(LogLevel.error, 'Failed calling: $call', exception, stackTrace);
    return Future.value(null);
  }
}
