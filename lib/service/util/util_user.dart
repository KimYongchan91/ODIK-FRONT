import 'package:odik/const/value/key.dart';

import '../../const/value/user.dart';

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

UserGender getUserGender(String? gender) {
  if (gender == keyMale) {
    return UserGender.male;
  } else if (gender == keyFemale) {
    return UserGender.female;
  } else {
    return UserGender.error;
  }
}

UserState getUserState(String? state) {
  if (state == keyOn) {
    return UserState.on;
  } else if (state == keyOut) {
    return UserState.out;
  } else if (state == keyBan) {
    return UserState.ban;
  } else {
    return UserState.error;
  }
}
