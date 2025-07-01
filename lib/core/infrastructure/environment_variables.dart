import 'package:injectable/injectable.dart';

abstract interface class EnvironmentVariables {
  String get baseUrl;
}

@LazySingleton(as: EnvironmentVariables)
class EnvironmentVariablesImpl implements EnvironmentVariables {
  @override
  String get baseUrl => const String.fromEnvironment('baseUrl');
}
