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

class ProviderTourCourseCart extends ChangeNotifier {
  ModelTourCourse? _modelTourCourseMy;

  getCart() async {
    //장바구니 불러오기
    MyApp.logger.d("장바구니 불러오기 실행");
    String url = "$urlBase/user/course";
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data, methodType: MethodType.get);
      log("장바구니 조회 결과 : ${response.toString()}");

      // 성공
      if (response[keyResult] == keyOk) {
        _modelTourCourseMy = ModelTourCourse.fromJson(response[keyTourCourse]);

        changeTourCourseTitle(_modelTourCourseMy!.title, isNotify: false);

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

  bool getIsExistAlready(ModelTourItem modelTourItem) {
    bool isExistAlready = false;
    for (var element in _modelTourCourseMy!.listModelTourItem) {
      if (element.contains(modelTourItem)) {
        isExistAlready = true;
        break;
      }
    }

    return isExistAlready;
  }

  addPlace(ModelPlace modelPlace, {bool isNotify = true}) async {
    if (MyApp.providerUser.modelUser == null) {
      showSnackBarOnRoute(messageNeedLogin);
      return;
    }

    assert(_modelTourCourseMy != null, '_modelTourCourseMy == null');

    ModelTourItem? modelTourItem = await getTourItemFromPlace(modelPlace);

    if (modelTourItem != null && getIsExistAlready(modelTourItem) == false) {
      addModelTourItem(modelTourItem, isNotify: true);
    }
  }

  addModelTourItem(ModelTourItem modelTourItem, {bool isNotify = true, bool isChangeWithServer = true}) {
    //마지막날에 추가
    int day = 0;

    loop1:
    for (int i = 0; i < _modelTourCourseMy!.listModelTourItem.length; i++) {
      bool isEmptyButThis = true;

      loop2:
      for (int j = i + 1; j < _modelTourCourseMy!.listModelTourItem.length; j++) {
        if (_modelTourCourseMy!.listModelTourItem[j].isNotEmpty) {
          isEmptyButThis = false;
          break loop2;
        }
      }
      if (isEmptyButThis) {
        day = i;
        break loop1;
      }
    }

    _modelTourCourseMy!.listModelTourItem[day].add(modelTourItem);

    //내 장바구니에 추가
    changeTourCourseWithServer();

    if (isNotify) {
      notifyListeners();
    }
  }

  addListModelTourItem(List<List<ModelTourItem>> listModelTourItem, {bool isNotify = true}) {
    for (var element in listModelTourItem) {
      for (var element2 in element) {
        addModelTourItem(element2, isNotify: false, isChangeWithServer: false);
      }
    }

    if (isNotify) {
      notifyListeners();
    }
  }

  //아이템 순서 재배열
  onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    //MyApp.logger.d("_onItemReorder\n"
    //    "oldItemIndex : $oldItemIndex\n"
    //    "oldListIndex : $oldListIndex\n"
    //    "newItemIndex : $newItemIndex\n"
    //    "newListIndex : $newListIndex\n");

    assert(_modelTourCourseMy != null, '_modelTourCourseMy == null');

    var itemOld = _modelTourCourseMy!.listModelTourItem[oldListIndex][oldItemIndex];
    _modelTourCourseMy!.listModelTourItem[oldListIndex].removeAt(oldItemIndex);
    _modelTourCourseMy!.listModelTourItem[newListIndex].insert(newItemIndex, itemOld);
    notifyListeners();

    changeTourCourseWithServer();
  }

  //리스트 전체 순서 재배열
  onListReorder(int oldListIndex, int newListIndex) {
    //MyApp.logger.d("_onListReorder\n"
    //    "oldItemIndex : $oldListIndex\n"
    //    "newListIndex : $newListIndex\n");

    assert(_modelTourCourseMy != null, '_modelTourCourseMy == null');

    var listOld = _modelTourCourseMy!.listModelTourItem[oldListIndex];
    _modelTourCourseMy!.listModelTourItem.removeAt(oldListIndex);
    _modelTourCourseMy!.listModelTourItem.insert(newListIndex, listOld);
    notifyListeners();

    changeTourCourseWithServer();
  }

  deleteModelTourItem(ModelTourItem modelTourItem) {
    assert(_modelTourCourseMy != null, '_modelTourCourseMy == null');

    for (var element in _modelTourCourseMy!.listModelTourItem) {
      element.remove(modelTourItem);
    }

    notifyListeners();

    changeTourCourseWithServer();
  }

  changeTourCourseWithServer({TourCourseStateType? tourCourseStateType}) async {
    assert(_modelTourCourseMy != null, '_modelTourCourseMy == null');

    List<Map<String, dynamic>> listTourItems = [];
    for (int i = 0; i < _modelTourCourseMy!.listModelTourItem.length; i++) {
      for (int j = 0; j < _modelTourCourseMy!.listModelTourItem[i].length; j++) {
        listTourItems.add({
          keyIdx: _modelTourCourseMy!.listModelTourItem[i][j].idx,
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
    if (tourCourseStateType == null) {
      //기존 state 재활용
      mapBody[keyState] =
          _modelTourCourseMy!.tourCourseStateType.toString().replaceAll("TourCourseStateType.", "");
    } else {
      mapBody[keyState] = tourCourseStateType.toString().replaceAll("TourCourseStateType.", "");
    }

    MyApp.logger.d("최종 modelTourCourseMy : ${mapBody.toString()}");

    ///user/course
    String url = "$urlBase/user/course";

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, mapBody, methodType: MethodType.put);
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

  clearProvider() {
    _modelTourCourseMy = null;
    notifyListeners();
  }

  ModelTourCourse? get modelTourCourseMy => _modelTourCourseMy;
}
