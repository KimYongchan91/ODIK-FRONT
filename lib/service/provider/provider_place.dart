import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/const/model/place/model_direction_car.dart';
import 'package:odik/const/value/key_user.dart';
import 'package:odik/service/util/util_snackbar.dart';

import '../../const/model/place/model_place.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../util/util_http.dart';

class ProviderPlace extends ChangeNotifier {
  final List<ModelPlace> _listModelPlace = [];

  final List<ModelDirection> _listModelDirection = []; //길찾기 memory용

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

  Future<ModelDirection?> getModelDirection(
      ModelPlace modelPlaceOrigin, ModelPlace modelPlaceDestination, DirectionType directionType) async {
    //기존에 있으면 반환

    for (var element in _listModelDirection) {
      if (element.modelPlaceOrigin == modelPlaceOrigin &&
          element.modelPlaceDestination == modelPlaceDestination &&
          element.directionType == directionType) {
        MyApp.logger.d("기존 direction 재활용");
        return element;
      }
    }

    /* String url =
        "https://apis-navi.kakaomobility.com/v1/directions?"
        "origin=127.11015314141542,37.39472714688412&"
        "destination=127.10824367964793,37.401937080111644&"
        "waypoints=&"
        "priority=RECOMMEND&"
        "car_fuel=GASOLINE&"
        "car_hipass=false&"
        "alternatives=false&"
        "road_details=false";
*/

    switch (directionType) {
      case DirectionType.car:
        String url = "https://apis-navi.kakaomobility.com/v1/directions?"
            "origin=${modelPlaceOrigin.locationLng},${modelPlaceOrigin.locationLat}&"
            "destination=${modelPlaceDestination.locationLng},${modelPlaceDestination.locationLat}&";

        Map<String, dynamic> header = {"Authorization": "KakaoAK ea3f77c6f8358b06fe4ad946662253dc"};

        try {
          final response =
              await requestHttpStandard(url, {}, methodType: MethodType.get, headerCustom: header);
          MyApp.logger.d("response 결과 : ${response.toString()}");

          dynamic routes = response['routes'];
          if (routes is List && routes.isNotEmpty) {
            dynamic route = routes.first;
            if (route['result_msg'] == "길찾기 성공") {
              ModelDirection modelDirection = ModelDirection(
                modelPlaceOrigin: modelPlaceOrigin,
                modelPlaceDestination: modelPlaceDestination,
                directionType: directionType,
                distance: route['summary']?['distance'] ?? 0,
                duration: route['summary']?['duration'] ?? 0,
                fareTaxi: route['summary']?['fare']?['taxi'] ?? 0,
                fareToll: route['summary']?['fare']?['toll'] ?? 0,
              );

              //저장후 리턴
              _listModelDirection.add(modelDirection);
              return modelDirection;
            }
          }
        } catch (e) {
          MyApp.logger.wtf("direction 에러 : ${e.toString()}");
        }

      case DirectionType.transportation:
      // TODO: Handle this case.
      case DirectionType.foot:
      // TODO: Handle this case.
    }

    return null;
  }

  List<ModelPlace> get listModelPlace => _listModelPlace;

  List<ModelDirection> get listModelDirection => _listModelDirection;
}
