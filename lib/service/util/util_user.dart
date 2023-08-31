import 'package:odik/const/value/key.dart';

import '../../const/value/enum_user.dart';

UserLoginType getUserLoginType(String? loginType) {
  if (loginType == keyEmail) {
    return UserLoginType.email;
  } else if (loginType == keyGoogle) {
    return UserLoginType.google;
  } else if (loginType == keyApple) {
    return UserLoginType.apple;
  } else {
    return UserLoginType.error;
  }
}

UserGenderType getUserGender(String? gender) {
  if (gender == keyMale || gender == keyMale2) {
    return UserGenderType.male;
  } else if (gender == keyFemale || gender == keyFemale2) {
    return UserGenderType.female;
  } else {
    return UserGenderType.error;
  }
}

UserStateType getUserState(String? state) {
  if (state == keyOn) {
    return UserStateType.on;
  } else if (state == keyOut) {
    return UserStateType.out;
  } else if (state == keyBan) {
    return UserStateType.ban;
  } else {
    return UserStateType.error;
  }
}
