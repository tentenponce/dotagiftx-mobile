import 'package:dotagiftx_mobile/di/dependency_injection.config.dart';
import 'package:dotagiftx_mobile/di/dependency_scopes.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

const Named baseUrl = Named('baseUrl');

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

void registerInitialDependencies() {
  if (getIt.hasScope(DependencyScopes.initial)) {
    return;
  }

  getIt.initInitialScope();
}
