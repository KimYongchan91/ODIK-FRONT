import '../../my_app.dart';

DateTime? getDateTimeFromDynamicData(dynamic data) {
  if (data == null) {
    return null;
  }
  try {
    if (data is String) {
      return DateTime.parse(data);
    } else if (data is int) {
      return DateTime.fromMillisecondsSinceEpoch(data);
    }
  } catch (e) {
    MyApp.logger.wtf("datetime 파싱 오류 : ${e.toString()}");
    return null;
  }
}
