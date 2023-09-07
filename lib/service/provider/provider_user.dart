import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/model/model_user.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/service/util/util_http.dart';
import 'package:odik/service/util/util_snackbar.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../util/util_tour_course.dart';

class ProviderUser extends ChangeNotifier {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  ModelUser? modelUser;

  ///이메일 로그인
  Future<bool> loginWithEmail(String email, String pss) async {
    //String url = 'https://odik.link/auth/sign';
    //todo test
    String url = "$urlBase/auth/login";
    Map data = {
      keyId: email,
      keyPassword: pss,
    };

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data);
      MyApp.logger.d("로그인 결과 : ${response.toString()}");

      //로그인 성공
      if (response[keyResult] == keyOk) {
        ModelUser modelUser = ModelUser.fromJson(response[keyUser]);
        await _changeModelUser(modelUser);

        jobAfterLogin();

        return true;

        //로그인 실패
      } else {
        showSnackBarOnRoute(messageLoginFail);
        logout();
        return false;
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
      showSnackBarOnRoute(messageServerError);
      logout();
      return false;
    }
  }

  ///자동 로그인
  loginWithAuto() async {
    String? data = await flutterSecureStorage.read(key: keyUserLastLogin);
    //MyApp.logger.d("불러온 마지막 로그인 정보 : $data");

    //기존에 로그인 정보가 있음
    if (data != null) {
      //MyApp.logger.d("불러온 마지막 로그인 정보 : $data");
      ModelUser modelUser = ModelUser.fromJson(jsonDecode(data));
      await _changeModelUser(modelUser, isSaveOnLocal: false);

      jobAfterLogin();

      //서버에서 유효한 계정인지 확인
      _checkIsValidAccount();
    }
  }

  ///로그인 후 공통 작업
  jobAfterLogin() async {
    if (modelUser == null) {
      MyApp.logger.wtf("modelUser==null");
      return;
    }
    MyApp.logger.d("jobAfterLogin 동작");
    MyApp.providerCourseCartMy.getCart();
    MyApp.providerCoursePublicMy.setModelUserCore(modelUser!);
    MyApp.providerCoursePublicMy.getAllTourCourse();

    return;
  }

  _checkIsValidAccount() async {
    //재 인증 url
    //header 데이터만으로 인증 여부 확인
    String url = "$urlBase/auth/validate_token";
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data, methodType: MethodType.get);
      //MyApp.logger.d("자동 로그인 응답 결과 : ${response.toString()}");

      //로그인 성공
      if (response[keyResult] == keyValid) {
        //아무 작업도 하지 않음
        //딱히?

        //로그인 실패
      } else {
        showSnackBarOnRoute(messageNeedReLogin);
        logout();
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
      showSnackBarOnRoute(messageNeedReLogin);
      logout();
    }
  }

  _changeModelUser(ModelUser modelUser, {bool isSaveOnLocal = true}) async {
    this.modelUser = modelUser;
    notifyListeners();

    //로컬에 저장
    if (isSaveOnLocal && this.modelUser != null) {
      try {
        MyApp.logger.d("마지막 정보 저장 : ${this.modelUser!.toJson(isEncodeDateTime: true).toString()}");
        await flutterSecureStorage.write(
            key: keyUserLastLogin, value: jsonEncode(this.modelUser!.toJson(isEncodeDateTime: true)));
      } catch (e) {
        MyApp.logger.wtf('데이터 로컬 저장 오류 발생 : ${e.toString()}');
      }
    }
  }

  logout() {
    modelUser = null;
    notifyListeners();

    //로컬에서 삭제
    flutterSecureStorage.delete(key: keyUserLastLogin);

    //장바구니 및 내 코스 초기화
    MyApp.providerCoursePublicMy.clearProvider();
    MyApp.providerCourseCartMy.clearProvider();
  }
}
