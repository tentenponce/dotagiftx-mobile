import 'package:dotagiftx_mobile/di/dependency_injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

const Named baseUrl = Named('baseUrl');

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
