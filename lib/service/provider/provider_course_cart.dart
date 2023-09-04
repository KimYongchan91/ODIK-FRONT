import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odik/const/model/model_tour_course.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/const/model/place/model_direction_transit_plan.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:quiver/iterables.dart';

import '../../const/model/place/model_place.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../util/util_http.dart';
import '../util/util_tour_course.dart';
import '../util/util_tour_item.dart';

class ProviderCourseCart extends ChangeNotifier {
  ModelTourCourse? _modelTourCourseMy;
  final List<List<ModelTourItem>> _listModelTourItem = [];
  final List<ModelDirection> _listModelDirection = []; //길찾기 memory용

  ProviderCourseCart() {
    //기본적으로 2개 생성해둠
    for (int i = 0; i < 1; i++) {
      _listModelTourItem.add([]);
    }
  }

  initTourCourseMy() async {
    //먼저 내 장바구니가 있는지 조회
    ModelTourCourse? modelTourCourseMy = await getTourCourseMy();
    if (modelTourCourseMy != null) {
      _modelTourCourseMy = modelTourCourseMy;
      //장바구니가 있음
      //장바구니에 추가
    } else {
      //장바구니가 없음
    }

    //장바구니 불러오기
    String url = "$urlBaseTest/user/course";
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data, methodType: MethodType.get);
      //log("장바구니 조회 결과 : ${response.toString()}");

      // 성공
      if (response[keyResult] == keyOk) {
        changeTourCourseTitle(response[keyTourCourse][keyTitle], isNotify: false);

        for (var element in ((response[keyTourCourse][keyTourItems] ?? []) as List)) { //수정 전
        //for (var element in ((response["tour_course_item_lists"] ?? []) as List)) {
          ModelTourItem modelTourItem = ModelTourItem.fromJson(element[keyTourItem]);
          MyApp.logger.d("modelTourItem : ${modelTourItem.toString()}");
          MyApp.providerCourseCart
              .addModelTourItem(modelTourItem, element[keyDay], element[keyLevel], isNotify: false);
        }

        notifyListeners();

        // 실패
      } else {}
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
    }
  }

  changeTourCourseTitle(String titleNew, {bool isNotify = true}) {
    _modelTourCourseMy?.title = titleNew;

    if (isNotify) {
      notifyListeners();
    }
  }

  addPlace(ModelPlace modelPlace, {bool isNotify = true}) async {
    if (MyApp.providerUser.modelUser == null) {
      showSnackBarOnRoute(messageNeedLogin);
      return;
    }

    ModelTourItem? modelTourItem = await getTourItemFromPlace(modelPlace);

    bool isExistAlready = false;
    for (var element in _listModelTourItem) {
      if (element.contains(modelTourItem)) {
        isExistAlready = true;
        break;
      }
    }

    if (modelTourItem != null && isExistAlready == false) {
      //마지막날에 추가
      _listModelTourItem[_listModelTourItem.length - 1].add(modelTourItem);
      //새로고침
      notifyListeners();

      //내 장바구니에 추가
      //추가하고 나서 서버에 보내는 거니 _listModelTourItem.last.length -1
      //todo 김용찬 이 부분 제거해야됨
      /*addTourItemToTourCourseWithServer(
          modelTourItem, _listModelTourItem.length - 1, _listModelTourItem.last.length - 1);*/

      //todo 김용찬 아래로 대체
      _changeTourCourse();
    }
  }

  addModelTourItem(ModelTourItem modelTourItem, int day, int level, {bool isNotify = true}) {
    if (day >= _listModelTourItem.length) {
      //부족한만큼 생성
      for (int i = 0; i < day - _listModelTourItem.length + 1; i++) {
        _listModelTourItem.add([]);
      }
    }

    _listModelTourItem[day].add(modelTourItem);

    if (isNotify) {
      notifyListeners();
    }
  }

  //아이템 순서 재배열
  onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    MyApp.logger.d("_onItemReorder\n"
        "oldItemIndex : $oldItemIndex\n"
        "oldListIndex : $oldListIndex\n"
        "newItemIndex : $newItemIndex\n"
        "newListIndex : $newListIndex\n");

    var itemOld = _listModelTourItem[oldListIndex][oldItemIndex];
    _listModelTourItem[oldListIndex].removeAt(oldItemIndex);
    _listModelTourItem[newListIndex].insert(newItemIndex, itemOld);
    notifyListeners();

    _changeTourCourse();
  }

  //리스트 전체 순서 재배열
  onListReorder(int oldListIndex, int newListIndex) {
    MyApp.logger.d("_onListReorder\n"
        "oldItemIndex : $oldListIndex\n"
        "newListIndex : $newListIndex\n");

    var listOld = _listModelTourItem[oldListIndex];
    _listModelTourItem.removeAt(oldListIndex);
    _listModelTourItem.insert(newListIndex, listOld);
    notifyListeners();

    _changeTourCourse();
  }

  _changeTourCourse() async {
    if (_modelTourCourseMy == null) {
      MyApp.logger.wtf("modelTourCourseMy ==null");
      return;
    }

    List<Map<String, dynamic>> listTourItems = [];
    for (int i = 0; i < _listModelTourItem.length; i++) {
      for (int j = 0; j < _listModelTourItem[i].length; j++) {
        listTourItems.add({
          keyIdx: _listModelTourItem[i][j].idx,
          keyDay: i,
          keyLevel: j,
        });
      }
    }

    Map<String, dynamic> mapBody = {
      keyTourCourseIdx: _modelTourCourseMy!.idx,
      keyTourItems: listTourItems,
      keyTitle: _modelTourCourseMy!.title,
    };

    MyApp.logger.d("최종 modelTourCourseMy : ${mapBody.toString()}");
    ///user/course
    String url = "$urlBaseTest/user/course";

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, mapBody,methodType: MethodType.put);
      MyApp.logger.d("코스 변경 응답결과 : ${response.toString()}");

      //로그인 성공
      if (response[keyResult] == keyOk) {
        MyApp.logger.d("코스 변경에 성공했습니다.");

      } else {
        MyApp.logger.wtf("관광지 생성에 실패했습니다.");
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf("관광지 생성에 실패 : ${e.toString()}");
    }
  }

  ///가는 경로 반환
  Future<ModelDirection?> getModelDirection(ModelTourItem modelTourItemOrigin,
      ModelTourItem modelTourItemDestination, DirectionType directionType) async {
    //기존에 있으면 반환

    for (var element in _listModelDirection) {
      if (element.modelTourItemOrigin == modelTourItemOrigin &&
          element.modelTourItemDestination == modelTourItemDestination &&
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
            "origin=${modelTourItemOrigin.locationLng},${modelTourItemOrigin.locationLat}&"
            "destination=${modelTourItemDestination.locationLng},${modelTourItemDestination.locationLat}&";

        Map<String, String> header = {"Authorization": "KakaoAK ea3f77c6f8358b06fe4ad946662253dc"};

        try {
          final response =
              await requestHttpStandard(url, {}, methodType: MethodType.get, headerCustom: header);
          MyApp.logger.d("response 결과 : ${response.toString()}");

          dynamic routes = response['routes'];
          if (routes is List && routes.isNotEmpty) {
            dynamic route = routes.first;
            if (route['result_msg'] == "길찾기 성공") {
              ModelDirection modelDirection = ModelDirection(
                modelTourItemOrigin: modelTourItemOrigin,
                modelTourItemDestination: modelTourItemDestination,
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

      case DirectionType.transit:
        String url = "https://apis.openapi.sk.com/transit/routes";

        try {
          Map<String, String> header = {
            "accept": "application/json",
            "content-type": "application/json",
            "appKey": "e8wHh2tya84M88aReEpXCa5XTQf3xgo01aZG39k5",
          };

          Map<String, dynamic> body = {
            "startX": "${modelTourItemOrigin.locationLng}",
            "startY": "${modelTourItemOrigin.locationLat}",
            "endX": "${modelTourItemDestination.locationLng}",
            "endY": "${modelTourItemDestination.locationLat}",
            "lang": 0,
            "format": "json",
            "reqDttm": DateFormat('yyyyMMddHHmmss').format(DateTime.now())
          };

          final response = await requestHttpStandard(
            url,
            body,
            methodType: MethodType.post,
            headerCustom: header,
            isIncludeModeHeaderCustom: false,
            isNeedDecodeUnicode: false,
          );

          List<ModelDirectionTransitPlan> listModelDirectionTransitPlan = [];
          List listItineraries = ((response['metaData']?['plan']?['itineraries'] ?? []) as List);

          for (var element in listItineraries) {
            ModelDirectionTransitPlan modelDirectionTransitPlan = ModelDirectionTransitPlan(
              pathType: element['pathType'] ?? 0,
              countTransfer: element['transferCount'] ?? 0,
              distanceTotal: element['totalDistance'] ?? 0,
              distanceWalk: element['totalWalkDistance'] ?? 0,
              durationTotal: element['totalTime'] ?? 0,
              durationWalk: element['totalWalkTime'] ?? 0,
              fareTotal: element['fare']['regular']['totalFare'],
            );

            listModelDirectionTransitPlan.add(modelDirectionTransitPlan);
          }

          if (listModelDirectionTransitPlan.isNotEmpty) {
            ModelDirection modelDirection = ModelDirection(
              modelTourItemOrigin: modelTourItemOrigin,
              modelTourItemDestination: modelTourItemDestination,
              directionType: directionType,
              listTransitPlan: listModelDirectionTransitPlan,
            );

            return modelDirection;
          } else {
            return null;
          }
        } catch (e) {
          MyApp.logger.wtf("direction 에러 : ${e.toString()}");
          return null;
        }
      case DirectionType.walk:
        try {
          String url = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1";

          Map<String, String> header = {
            "accept": "application/json",
            "content-type": "application/json",
            "appKey": "e8wHh2tya84M88aReEpXCa5XTQf3xgo01aZG39k5",
          };

          Map<String, dynamic> body = {
            "startX": "${modelTourItemOrigin.locationLng}",
            "startY": "${modelTourItemOrigin.locationLat}",
            "endX": "${modelTourItemDestination.locationLng}",
            "endY": "${modelTourItemDestination.locationLat}",
            "startName": modelTourItemOrigin.title,
            "endName": modelTourItemDestination.title,
          };

          final response = await requestHttpStandard(
            url,
            body,
            methodType: MethodType.post,
            headerCustom: header,
            isIncludeModeHeaderCustom: false,
            isNeedDecodeUnicode: false,
          );

          MyApp.logger.d("response 결과 : ${response.toString()}");

          List listItineraries = ((response['features'] ?? []) as List);
          MyApp.logger.d("listItineraries.first : ${listItineraries.first.toString()}");
          dynamic properties = listItineraries.first['properties'];
          if (properties != null && properties['totalDistance'] != null && properties['totalTime'] != null) {
            ModelDirection modelDirection = ModelDirection(
              modelTourItemOrigin: modelTourItemOrigin,
              modelTourItemDestination: modelTourItemDestination,
              directionType: directionType,
              distance: properties['totalDistance'],
              duration: properties['totalTime'],
            );
            return modelDirection;
          } else {
            return null;
          }
        } catch (e) {
          MyApp.logger.wtf("direction 에러 : ${e.toString()}");
          return null;
        }
    }

    return null;
  }

  ModelTourCourse? get modelTourCourseMy => _modelTourCourseMy;

  List<List<ModelTourItem>> get listModelTourItem => _listModelTourItem;

  List<ModelDirection> get listModelDirection => _listModelDirection;
}
