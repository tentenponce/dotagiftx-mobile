import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract interface class PackageInfoUtils {
  Future<String> fetchVersion();
  Future<int> fetchBuildNumber();
}

@LazySingleton(as: PackageInfoUtils)
class PackageInfoUtilsImpl implements PackageInfoUtils {
  @override
  Future<String> fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  @override
  Future<int> fetchBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return int.parse(packageInfo.buildNumber);
  }
}
