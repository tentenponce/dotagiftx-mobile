import 'dart:async';

import 'package:dotagiftx_mobile/core/logging/logger.dart';
import 'package:dotagiftx_mobile/core/utils/string_utils.dart';
import 'package:dotagiftx_mobile/data/core/dio/api_exceptions.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';

mixin CubitErrorMixin<State> on BaseCubit<State> {
  void Function()? showErrorDialog;
  void Function(String? message, String? code)? showApiErrorDialog;

  Logger get logger;

  Future<void> cubitHandler<R>(
    Future<R> Function() call,
    Future<void> Function(R resp) onSuccess, {
    Future<void> Function(Object? e, StackTrace? st)? onError,
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
            ? await onError(e, st)
            : await defaultErrorHandler(e, call: call, stackTrace: st);
      }
    }
  }

  Future<T?> defaultErrorHandler<T extends Object?>(
    Object? exception, {
    Future<T?> Function()? call,
    StackTrace? stackTrace,
  }) {
    logger.log(LogLevel.error, 'Failed calling: $call', exception, stackTrace);
    if (exception is BadRequestException &&
        !StringUtils.isNullOrEmpty(exception.apiErrorMessage)) {
      showApiErrorDialog?.call(
        exception.apiErrorMessage,
        exception.statusCode.toString(),
      );
    } else {
      showErrorDialog?.call();
    }

    return Future.value(null);
  }
}
