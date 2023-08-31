import 'package:odik/const/value/enum_user.dart';
import 'package:odik/const/value/key.dart';

import '../../service/util/util_user.dart';

class ModelUserCore {
  final int idx;
  final String? nickName;
  final UserGenderType? userGenderType;
  final String? locale;

  ModelUserCore({
    required this.idx,
    required this.nickName,
    required this.userGenderType,
    required this.locale,
  });

  ModelUserCore.fromJson(Map<String, dynamic> json)
      : idx = json[keyIdx] ?? 0,
        nickName = json[keyNickName],
        userGenderType = getUserGender(json[keyGender]),
        locale = json[keyLocale];
}
