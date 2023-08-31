import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/service/util/util_http.dart';

import '../../const/model/place/model_place.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';

Future<ModelTourItem?> getTourItemFromPlace(ModelPlace modelPlace) async {
  //먼저 있나 조회
  ModelTourItem? modelTourItem = await getTourItemFromReferenceIdGoogle(modelPlace.referenceId);

  if (modelTourItem == null) {
    //서버에 없음
    //등록
    ModelTourItem? modelTourItemNew = await addTourItemToServer(modelPlace);
    if (modelTourItemNew != null) {
      //등록 성공
      return modelTourItemNew;
    } else {
      //등록 실패
      return null;
    }
  } else {
    //이미 있었음
    return modelTourItem;
  }
}

getTourItemFromReferenceIdGoogle(String referenceId) async {
  //관광지
  //log("카트에 추가되는 정보 : ${modelPlace.toJson()}");

  String url = "$urlBaseTest/tour/item?reference_id=$referenceId";

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, {}, methodType: MethodType.get);
    MyApp.logger.d("관광지 조회 응답결과 : ${response.toString()}");

    //로그인 성공
    if (response[keyResult] == keyOk) {
      ModelTourItem modelPlace = ModelTourItem.fromJson(response);
      //MyApp.logger.d("관광지 조회 생성자 결과 : ${modelPlace.toString()}");
      return modelPlace;
    } else {
      return null;
    }
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("관광지 조회 실패 : ${e.toString()}");
    return null;
  }
}

///관광지 등록
///등록 후 데이터까지 반환
Future<ModelTourItem?> addTourItemToServer(ModelPlace modelPlace) async {
  String url = "$urlBaseTest/tour/item";
  Map data = modelPlace.toJson();

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, data);
    MyApp.logger.d("관광지 생성 응답결과 : ${response.toString()}");

    //로그인 성공
    if (response[keyResult] == keyOk) {
      MyApp.logger.d("관광지 생성에 성공했습니다.");
      ModelTourItem modelPlace = ModelTourItem.fromJson(response);
      return modelPlace;
    } else {
      MyApp.logger.wtf("관광지 생성에 실패했습니다.");
      return null;
    }
  } catch (e) {
    //오류 발생
    MyApp.logger.wtf("관광지 생성에 실패 : ${e.toString()}");
    return null;
  }
}
