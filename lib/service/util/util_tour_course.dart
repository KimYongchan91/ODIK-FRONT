import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/service/util/util_http.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';

TourCourseType getTourCourseType(String? state) {
  if (state == keyCart) {
    return TourCourseType.cart;
  } else if (state == keyPublic) {
    return TourCourseType.public;
  } else if (state == keyDelete) {
    return TourCourseType.delete;
  } else {
    return TourCourseType.error;
  }
}

///내 코스(장바구니) 조회
Future<ModelTourCourse?> getTourCourseMy() async {
  String url = "$urlBaseTest/user/course";

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, {}, methodType: MethodType.get);
    MyApp.logger.d("내 장바구니 조회 응답결과 : ${response.toString()}");

    //todo 김용찬 idx가 아닌 result로 구별하자
    if (response[keyTourCourse][keyIdx] != null) {
      //내 장바구니가 있음
      ModelTourCourse modelTourCourseMy = ModelTourCourse.fromJson(response[keyTourCourse]);
      return modelTourCourseMy;
    } else {
      //내 장바구니가 없음
      return null;
    }
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("장바구니 조회 실패 : ${e.toString()}");
    return null;
  }
}

///장바구니에 아이템 추가
Future addTourItemToTourCourseWithServer(ModelTourItem modelTourItem, int day, int level) async {

  if(MyApp.providerCourseCart.modelTourCourseMy == null){
    MyApp.logger.wtf("MyApp.providerCourseCart.modelTourCourseMy == null");
    return;
  }

  String url = "$urlBaseTest/user/course/add_tour_item";
  Map<String, dynamic> mapData = {
    keyTourCourseIdx: MyApp.providerCourseCart.modelTourCourseMy!.idx,
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
