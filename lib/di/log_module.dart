import 'package:dotagiftx_mobile/core/logging/log_stream_provider.dart';
import 'package:dotagiftx_mobile/di/dependency_scopes.dart';
import 'package:injectable/injectable.dart';

@module
abstract class LogModule {
  final LogStreamHandler _logStreamHandler = LogStreamHandler();

  @Scope(DependencyScopes.initial)
  @lazySingleton
  LogStreamProvider get logStreamProvider => _logStreamHandler;

  @Scope(DependencyScopes.initial)
  @lazySingleton
  LogStreamPublisher get logStreamPublisher => _logStreamHandler;
}
