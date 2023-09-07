import 'package:intl/intl.dart';
import 'package:odik/service/util/util_http.dart';

import '../../const/model/model_tour_item.dart';
import '../../const/model/place/model_direction.dart';
import '../../const/model/place/model_direction_transit_plan.dart';
import '../../my_app.dart';

///가는 경로 반환
Future<ModelDirection?> getModelDirection(ModelTourItem modelTourItemOrigin,
    ModelTourItem modelTourItemDestination, DirectionType directionType) async {
  //기존에 있으면 반환

  for (var element in MyApp.listModelDirection) {
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
            MyApp.listModelDirection.add(modelDirection);
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
            distance: listModelDirectionTransitPlan.first.distanceTotal,
            duration: listModelDirectionTransitPlan.first.durationTotal,
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