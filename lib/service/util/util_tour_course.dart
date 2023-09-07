import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/service/util/util_http.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';

TourCourseStateType getTourCourseStateType(String? state) {
  if (state == keyCart) {
    return TourCourseStateType.cart;
  } else if (state == keyPublic) {
    return TourCourseStateType.public;
  } else if (state == keyDelete) {
    return TourCourseStateType.delete;
  } else {
    return TourCourseStateType.error;
  }
}

List<List<ModelTourItem>> getListListModelTourItemFromDynamicData(dynamic tourItems) {
  List<List<ModelTourItem>> result = List.generate(countTourCourseDayMax, (index) => []);

  //MyApp.logger.d("tourItems.type : ${tourItems.runtimeType.toString()}");

  if (tourItems is List) {
    for (var element in tourItems) {
      ModelTourItem modelTourItem = ModelTourItem.fromJson(element[keyTourItem]);
      //MyApp.logger.d("modelTourItem : ${modelTourItem.toString()}");
      int day = element[keyDay];
      int level = element[keyLevel];
      result[day].insert(level, modelTourItem);
    }
  }
  return result;
}

///장바구니에 아이템 추가
Future addTourItemToTourCourseWithServer(ModelTourItem modelTourItem, int day, int level) async {
  if (MyApp.providerCourseCartMy.modelTourCourseMy == null) {
    MyApp.logger.wtf("MyApp.providerCourseCart.modelTourCourseMy == null");
    return;
  }

  String url = "$urlBaseTest/user/course/add_tour_item";
  Map<String, dynamic> mapData = {
    keyTourCourseIdx: MyApp.providerCourseCartMy.modelTourCourseMy!.idx,
    keyTourItemIdx: modelTourItem.idx,
    keyDay: day,
    keyLevel: level,
  };

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, mapData, methodType: MethodType.post);
    MyApp.logger.d("장바구니에 관광지 추가 응답결과 : ${response.toString()}");
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("장바구니에 관광지 추가 실패 : ${e.toString()}");
    return null;
  }
}
