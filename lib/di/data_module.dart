import 'package:dotagiftx_mobile/core/infrastructure/environment_variables.dart';
import 'package:dotagiftx_mobile/di/dependency_injection.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataModule {
  @lazySingleton
  @baseUrl
  String getBaseUrl(EnvironmentVariables environmentVariables) =>
      environmentVariables.baseUrl;
}
