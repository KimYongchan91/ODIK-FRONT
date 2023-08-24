import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:odik/const/value/key_user.dart';
import 'package:odik/service/util/util_snackbar.dart';

import '../../const/model/place/model_place.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../util/util_http.dart';

class ProviderCart extends ChangeNotifier {
  final List<ModelPlace> _listModelPlace = [];

  addPlace(ModelPlace modelPlace) {
    if (MyApp.providerUser.modelUser == null) {
      showSnackBarOnRoute(messageNeedLogin);
      return;
    }

    if (listModelPlace.contains(modelPlace)) {
      return;
    }

    _listModelPlace.add(modelPlace);

    //서버로 전송
    _addPlaceToServer(modelPlace);

    //새로고침
    notifyListeners();
  }

  _addPlaceToServer(ModelPlace modelPlace) async {
    log("카트에 추가되는 정보 : ${modelPlace.toJson()}");

    String url = "$urlBaseTest/tour/item";
    Map data = modelPlace.toJson();

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data);
      MyApp.logger.d("관광지 생성 응답결과 : ${response.toString()}");

      //로그인 성공
      if (response[keyResult] == keyOk) {
        showSnackBarOnRoute("관광지 생성에 성공했습니다.");
      } else {
        showSnackBarOnRoute("관광지 생성에 실패했습니다.");
      }
    } catch (e) {
      //오류 발생
      showSnackBarOnRoute("관광지 생성에 실패했습니다.");
    }
  }

  List<ModelPlace> get listModelPlace => _listModelPlace;
}
