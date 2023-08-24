import '../../my_app.dart';
import 'package:intl/intl.dart';

const String dateFormat = "yy-dd-MM HH:mm";

DateTime? getDateTimeFromDynamicData(dynamic data) {
  if (data == null) {
    return null;
  }
  try {
    if (data is String) {
      return DateFormat(dateFormat).parse(data);
    } else if (data is int) {
      return DateTime.fromMillisecondsSinceEpoch(data);
    }
  } catch (e) {
    MyApp.logger.wtf("datetime 파싱 오류 : ${e.toString()}");
    return null;
  }
}

String getFormattedDateTime(DateTime dateTime){
  return DateFormat(dateFormat).format(dateTime);
}
