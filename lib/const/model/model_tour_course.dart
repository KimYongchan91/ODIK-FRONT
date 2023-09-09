import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/service/util/util_list.dart';
import 'package:odik/service/util/util_tour_course.dart';

import '../../service/util/util_date_time.dart';
import 'model_tour_item.dart';

class ModelTourCourse {
  final int idx;
  String title;
  final ModelUserCore modelUserCore;
  final String? imageCover;
  final DateTime dateTimeCreate;
  final DateTime? dateTimeModify;
  final TourCourseStateType tourCourseStateType;
  final List<List<ModelTourItem>> listModelTourItem;

  //final String location;
  //final int expense;
  //final int duration;

  ModelTourCourse.fromJson(Map<String, dynamic> json)
      : idx = json[keyIdx] ?? 0,
        title = json[keyTitle] ?? '',
        modelUserCore = ModelUserCore.fromJson(json[keyUser] ?? {}),
        imageCover = json[keyImageCover],
        dateTimeCreate = getDateTimeFromDynamicData(json[keyDateCreate]) ?? DateTime.now(),
        dateTimeModify = getDateTimeFromDynamicData(json[keyDateModify]),

        //email을 key로
        tourCourseStateType = getTourCourseStateType(json[keyState]),
        listModelTourItem = getListListModelTourItemFromDynamicData(json[keyTourItems]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelTourCourse &&
          runtimeType == other.runtimeType &&
          idx == other.idx &&
          isSameList(listModelTourItem, other.listModelTourItem);

  @override
  int get hashCode => idx.hashCode ^ listModelTourItem.hashCode;
}
