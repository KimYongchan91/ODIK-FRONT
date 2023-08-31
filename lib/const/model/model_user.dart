import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/enum_user.dart';
import 'package:odik/service/util/util_user.dart';

import '../../service/util/util_date_time.dart';

class ModelUser extends ModelUserCore {
  final String tokenOdik;
  final String id;
  final UserLoginType userLoginType;
  final DateTime dateJoin;
  final UserStateType userStateType;

  ModelUser.fromJson(Map<String, dynamic> json)
      : tokenOdik = json[keyTokenOdik] ?? '',
        id = json[keyEmail] ?? json[keyId] ?? '',
        //email을 key로
        userLoginType = getUserLoginType(json[keyLoginType]),
        dateJoin = getDateTimeFromDynamicData(json[keyDateJoin]) ?? DateTime.now(),
        userStateType = getUserState(json[keyState]),
        super.fromJson(json);

  Map<String, dynamic> toJson({bool isIncludeIdx = false, bool isEncodeDateTime = false}) {
    Map<String, dynamic> result = {
      keyTokenOdik: tokenOdik,
      keyId: id,
      keyLoginType: userLoginType.toString().split(".").last,
      keyNickName: nickName,
      keyGender: userGenderType.toString().split(".").last,
      keyDateJoin: dateJoin,
      keyState: userStateType.toString().split(".").last,
      keyLocale: locale,
    };

    if(isIncludeIdx){
      result[keyIdx] = idx;
    }

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
