import 'package:odik/const/model/model_tour_course.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/service/util/util_http.dart';

import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';

Future<bool> getIsLikeTour({
  ModelTourCourse? modelTourCourse,
  ModelTourItem? modelTourItem,
}) async {
  assert(modelTourCourse != null || modelTourItem != null, "modelTourCourse, modelTourItem all null");

  String url;
  if (modelTourCourse != null) {
    url = "$urlBase/tour/course/${modelTourCourse.idx}/like";
  } else if (modelTourItem != null) {
    url = "$urlBase/tour/item/${modelTourItem.idx}/like";
  } else {
    url = "";
  }

  Map data = {};

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, data,methodType: MethodType.get);
    MyApp.logger.d("좋아요 여부 조회 응답결과 : ${response.toString()}");

    //성공
    if (response[keyResult] == keyOk) {
      if (response[keyLike] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("좋아요 여부 조회에 실패 : ${e.toString()}");
    return false;
  }
}

Future changeIsLikeTour(bool isLike, {
  ModelTourCourse? modelTourCourse,
  ModelTourItem? modelTourItem,
}) async {
  assert(modelTourCourse != null || modelTourItem != null, "modelTourCourse, modelTourItem all null");

  String url;
  if (modelTourCourse != null) {
    url = "$urlBase/tour/course/${modelTourCourse.idx}/like";
  } else if (modelTourItem != null) {
    url = "$urlBase/tour/item/${modelTourItem.idx}/like";
  } else {
    url = "";
  }

  Map data = {
    keyLike: isLike,
  };

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, data, methodType: MethodType.post);
    MyApp.logger.d("좋아요 여부 수정 응답결과 : ${response.toString()}");

    //성공
    if (response[keyResult] == keyOk) {
      if (response[keyLike] == true) {} else {}
    } else {}
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("좋아요 여부 조회에 실패 : ${e.toString()}");
    rethrow;
  }
}
