import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/service/util/util_tour_course.dart';

import '../../service/util/util_date_time.dart';

class ModelTourCourse {
  final int idx;
  final String title;
  final ModelUserCore modelUserCore;
  final DateTime dateTimeCreate;
  final DateTime? dateTimeModify;
  final TourCourseType tourCourseType;

  //final String location;
  //final int expense;
  //final int duration;

  ModelTourCourse.fromJson(Map<String, dynamic> json)
      : idx = json[keyIdx] ?? 0,
        title = json[keyTitle] ?? '',
        modelUserCore = ModelUserCore.fromJson(json[keyUser] ?? {}),
        dateTimeCreate = getDateTimeFromDynamicData(json[keyDateCreate]) ?? DateTime.now(),
        dateTimeModify = getDateTimeFromDynamicData(json[keyDateModify]),

        //email을 key로
        tourCourseType = getTourCourseType(json[keyState]);
}
