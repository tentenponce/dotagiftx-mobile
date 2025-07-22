import 'package:injectable/injectable.dart';

abstract interface class DateTimeUtils {
  DateTime getLocalDateTime();
}

@LazySingleton(as: DateTimeUtils)
class DateTimeUtilsImpl implements DateTimeUtils {
  @override
  DateTime getLocalDateTime() {
    // getting the local device time
    return DateTime.now();
  }
}
