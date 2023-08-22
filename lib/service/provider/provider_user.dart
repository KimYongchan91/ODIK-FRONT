import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odik/const/model/model_user.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/key_user.dart';
import 'package:odik/service/util/util_http.dart';
import 'package:odik/service/util/util_snackbar.dart';

import '../../my_app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProviderUser extends ChangeNotifier {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  ModelUser? modelUser;

  ///이메일 로그인
  Future<bool> loginWithEmail(String email, String pss) async {
    String url = 'https://odik.link/auth/sign';
    Map data = {
      keyEmail: email,
      keyPss: pss,
    };

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data);

      //로그인 성공
      if (response[keyResult] == keyOk) {
        ModelUser modelUser = ModelUser.fromJson(response);
        _changeModelUser(modelUser);

        //로그인 실패
      } else {
        showSnackBarOnRoute(messageLoginFail);
        _logout();
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
      showSnackBarOnRoute(messageServerError);
      _logout();
    }

    return true;
  }

  ///자동 로그인
  _loginWithAuto() async {
    String? data = await flutterSecureStorage.read(key: keyUserLastLogin);

    //기존에 로그인 정보가 있음
    if (data != null) {
      ModelUser modelUser = ModelUser.fromJson(jsonDecode(data));
      await _changeModelUser(modelUser, isSaveOnLocal: false);

      //서버에서 유효한 계정인지 확인
      _checkIsValidAccount();
    }
  }

  _checkIsValidAccount() async {
    String url = 'https://odik.link/auth/sign';
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, data);

      //로그인 성공
      if (response[keyResult] == keyValid) {
        //아무 작업도 하지 않음

        //로그인 실패
      } else {
        showSnackBarOnRoute(messageNeedReLogin);
        _logout();
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
      showSnackBarOnRoute(messageNeedReLogin);
      _logout();
    }
  }

  _changeModelUser(ModelUser modelUser, {bool isSaveOnLocal = true}) async {
    this.modelUser = modelUser;
    notifyListeners();

    //로컬에 저장
    if (isSaveOnLocal && this.modelUser != null) {
      await flutterSecureStorage.write(key: keyUserLastLogin, value: jsonEncode(this.modelUser!.toJson()));
    }
  }

  _logout() {
    modelUser = null;
    notifyListeners();

    //로컬에서 삭제
    flutterSecureStorage.delete(key: keyUserLastLogin);
  }
}
