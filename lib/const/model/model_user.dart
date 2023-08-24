import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/enum_user.dart';
import 'package:odik/service/util/util_user.dart';

import '../../service/util/util_date_time.dart';

class ModelUser {
  final String tokenOdik;
  final String id;
  final UserLoginType userLoginType;
  final String? nickName;
  final UserGender? userGender;
  final DateTime dateJoin;
  final UserState userState;
  final String? locale;

  ModelUser.fromJson(Map<String, dynamic> json)
      : tokenOdik = json[keyTokenOdik] ?? '',
        id = json[keyEmail] ?? '',
        //email을 key로
        userLoginType = getUserLoginType(json[keyLoginType]),
        nickName = json[keyNickName],
        userGender = getUserGender(json[keyGender]),
        dateJoin = getDateTimeFromDynamicData(json[keyDateJoin]) ?? DateTime.now(),
        userState = getUserState(json[keyState]),
        locale = json[keyLocale];

  Map<String, dynamic> toJson({bool isEncodeDateTime = false}) {
    Map<String, dynamic> result = {
      keyTokenOdik: tokenOdik,
      keyId: id,
      keyLoginType: userLoginType.toString().split(".").last,
      keyNickName: nickName,
      keyGender: userGender.toString().split(".").last,
      keyDateJoin: dateJoin,
      keyState: userState.toString().split(".").last,
      keyLocale: locale,
    };

    //datetime 인코딩
    if (isEncodeDateTime) {
      for (var element in result.keys) {
        if (result[element] is DateTime) {
          result[element] = getFormattedDateTime(result[element] as DateTime);
        }
      }
    }

    return result;
  }
}
