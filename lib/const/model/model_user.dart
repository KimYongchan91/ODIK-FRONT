import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/user.dart';
import 'package:odik/service/util/util_user.dart';

class ModelUser {
  final String tokenOdik;
  final String id;
  final UserLoginType userLoginType;
  final String? nickName;
  final UserGender? userGender;
  final DateTime dateJoin;
  final UserState userState;

  ModelUser.fromJson(Map<String, dynamic> json)
      : tokenOdik = json[keyTokenOdik] ?? '',
        id = json[keyId] ?? '',
        userLoginType = getUserLoginType(json[keyLoginType]),
        nickName = json[keyNickName],
        userGender = getUserGender(json[keyGender]),
        dateJoin = json[keyDateJoin] ?? DateTime.now(),
        userState = getUserState(json[keyState]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      keyId: id,
      keyLoginType: userLoginType.toString().split(".").last,
      keyNickName: nickName,
      keyGender: userGender.toString().split(".").last,
      keyDateJoin: dateJoin,
      keyState: userState.toString().split(".").last,
    };

    return result;
  }
}
