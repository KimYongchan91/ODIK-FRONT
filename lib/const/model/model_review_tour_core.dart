import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/service/util/util_num.dart';

import '../../service/util/util_date_time.dart';

class ModelReviewTourCore {
  final int idx;
  final double rating;
  final String content;
  final ModelUserCore modelUserCore;
  final DateTime dateCreate;
  final DateTime dateModify;

  ModelReviewTourCore.fromJson(Map<String, dynamic> json)
      : idx = json[keyIdx],
        rating = getDoubleFromDynamic(json[keyRating]),
        content = json[keyContent] ?? '',
        modelUserCore = ModelUserCore.fromJson(json),
        dateCreate = getDateTimeFromDynamicData(json[keyDateCreate]) ?? DateTime.now(),
        dateModify = getDateTimeFromDynamicData(json[keyDateModify]) ?? DateTime.now();
}
