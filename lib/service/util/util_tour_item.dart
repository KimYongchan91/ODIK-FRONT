import 'dart:developer';

import 'package:odik/service/util/util_http.dart';

import '../../const/value/key.dart';
import '../../const/value/key_user.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';

///관광지 조회
getTourItemByReferenceIdGoogle(String referenceId) async {
  //log("카트에 추가되는 정보 : ${modelPlace.toJson()}");

  String url = "$urlBaseTest/tour/item?reference_id=$referenceId}";

  try {
    Map<String, dynamic> response = await requestHttpStandard(url, {}, methodType: MethodType.get);
    MyApp.logger.d("관광지 조회 응답결과 : ${response.toString()}");

    //로그인 성공
    if (response[keyResult] == keyOk) {
    } else {}
  } catch (e) {
    //오류 발생
  }
}
