import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/user.dart';
import 'package:odik/service/util/util_user.dart';

class ModelUser {
  final String id;
  final UserLoginType userLoginType;
  final String? nickName;
  final UserGender? userGender;
  final DateTime dateJoin;
  final UserState userState;

  ModelUser.fromJson(Map<String, dynamic> json)
      : id = json[keyId] ?? '',
        userLoginType = getUserLoginType(json[keyLoginType]),
        nickName = json[keyNickName],
        userGender = getUserGender(json[keyGender]),
        dateJoin = json[keyDateJoin] ?? DateTime.now(),
        userState = getUserState(json[keyState]);
}
