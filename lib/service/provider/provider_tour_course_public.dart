import 'package:flutter/cupertino.dart';
import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/const/value/tour_course.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../util/util_http.dart';

class ProviderTourCoursePublic extends ChangeNotifier {
  ModelUserCore? _modelUserCore;
  final List<ModelTourCourse> _listModelTourCourse = [];

  setModelUserCore(ModelUserCore modelUserCore) {
    _modelUserCore = modelUserCore;
  }

  getAllTourCourse() async {
    assert(_modelUserCore != null, '_modelUserCore is null, setModelUserCore() first ');

    if (_modelUserCore == null) {
      MyApp.logger.wtf('_modelUserCore == null');
      return;
    }

    //재 인증 url
    //header 데이터만으로 인증 여부 확인
    String url = "$urlBase/tour/course/user/${_modelUserCore!.idx}";
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data, methodType: MethodType.get);
      MyApp.logger.d("내 코든 코스 응답 결과 : ${response.toString()}");

      //성공
      if (response[keyResult] == keyOk) {
        for (var element in ((response[keyTourCourses]?[keyContent] ?? []) as List)) {
          ModelTourCourse modelTourCourse = ModelTourCourse.fromJson(element);
          //장바구니가 아닌 것만 추가
          if (modelTourCourse.tourCourseStateType != TourCourseStateType.cart) {
            _listModelTourCourse.add(modelTourCourse);
          }
        }

        //실패
      } else {}
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
    }

    //새로고침
    notifyListeners();
  }

  refreshAllTourCourse() async {
    clearProvider();
    await getAllTourCourse();
    notifyListeners();
  }

  clearProvider() {
    _listModelTourCourse.clear();
    notifyListeners();
  }

  List<ModelTourCourse> get listModelTourCourse => _listModelTourCourse;
}
