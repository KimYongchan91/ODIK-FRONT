import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/value/enum_user.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/test.dart';
import 'package:odik/custom/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:odik/ui/widget/button_standard.dart';

import '../../my_app.dart';
import '../../service/util/util_http.dart';
import '../dialog/dialog_request_confirm.dart';

enum EmailVerifyStateType {
  yet, //인증번호 발송 전
  send, //인증번호 발송함
  ok, //인증 완료
}

class RouteJoin extends StatefulWidget {
  const RouteJoin({super.key});

  @override
  State<RouteJoin> createState() => _RouteJoinState();
}

class _RouteJoinState extends State<RouteJoin> {
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerCode = TextEditingController();
  TextEditingController textEditingControllerPss = TextEditingController();
  TextEditingController textEditingControllerPss2 = TextEditingController();

  TextEditingController textEditingControllerNickName = TextEditingController();
  TextEditingController textEditingControllerPhone = TextEditingController();

  ValueNotifier<bool> valueNotifierIsProcessingEmailVerify = ValueNotifier(false);

  ValueNotifier<EmailVerifyStateType> valueNotifierEmailVerifyStateType =
      ValueNotifier(EmailVerifyStateType.yet);

  ValueNotifier<UserGenderType?> valueNotifierUserGenderType = ValueNotifier(null);
  String? tokenVerifyEmail;

  @override
  void dispose() {
    textEditingControllerEmail.dispose();
    textEditingControllerCode.dispose();
    textEditingControllerPss.dispose();
    textEditingControllerPss2.dispose();

    textEditingControllerNickName.dispose();
    textEditingControllerPhone.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '회원가입',
                      style: CustomTextStyle.largeBlackBold(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'e메일',
                      style: CustomTextStyle.normalBlack(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueNotifierEmailVerifyStateType,
                      builder: (context, value, child) => CustomTextField(
                        hintText: "이메일을 입력해주세요.",
                        controller: textEditingControllerEmail,
                        readOnly: value != EmailVerifyStateType.yet,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueNotifierEmailVerifyStateType,
                      builder: (context, value, child) {
                        switch (value) {
                          //아직 인증 요청 전
                          case EmailVerifyStateType.yet:
                            return ValueListenableBuilder(
                              valueListenable: valueNotifierIsProcessingEmailVerify,
                              builder: (context, value, child) => ElevatedButton(
                                onPressed: _requestEmailVerifyCode,
                                child: value
                                    ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20)
                                    : const Text('인증번호 발송'),
                              ),
                            );

                          //인증번호 요청이 성공했을 때
                          case EmailVerifyStateType.send:
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: "인증번호를 입력해 주세요.",
                                    controller: textEditingControllerCode,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: valueNotifierIsProcessingEmailVerify,
                                  builder: (context, value, child) => ElevatedButton(
                                    onPressed: _verifyEmailVerifyCode,
                                    child: value
                                        ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20)
                                        : const Text('인증'),
                                  ),
                                )
                              ],
                            );

                          //인증 완료
                          case EmailVerifyStateType.ok:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '비밀번호',
                                  style: CustomTextStyle.normalBlack(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: "비밀번호를 입력해 주세요.",
                                  controller: textEditingControllerPss,
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  '비밀번호 확인',
                                  style: CustomTextStyle.normalBlack(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: "비밀번호를 한번더 입력해 주세요.",
                                  controller: textEditingControllerPss2,
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  '별명',
                                  style: CustomTextStyle.normalBlack(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: "별명을 입력해 주세요.",
                                  controller: textEditingControllerNickName,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  '전화번호 (선택)',
                                  style: CustomTextStyle.normalBlack(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: "전화번호를 입력해 주세요.",
                                  controller: textEditingControllerPhone,
                                  keyboardType: TextInputType.phone,
                                  autocorrect: false,
                                  inputFormatters: [
                                    MaskedInputFormatter('###-####-####'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  '성별 (선택)',
                                  style: CustomTextStyle.normalBlack(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: valueNotifierUserGenderType,
                                      builder: (context, value, child) => Radio<UserGenderType>(
                                        value: UserGenderType.male,
                                        groupValue: value,
                                        onChanged: (value) {
                                          valueNotifierUserGenderType.value = value;
                                        },
                                      ),
                                    ),
                                    const Text(
                                      '남성',
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: valueNotifierUserGenderType,
                                      builder: (context, value, child) => Radio<UserGenderType>(
                                        value: UserGenderType.female,
                                        groupValue: value,
                                        onChanged: (value) {
                                          valueNotifierUserGenderType.value = value;
                                        },
                                      ),
                                    ),
                                    const Text(
                                      '여성',
                                    )
                                  ],
                                ),
                                ButtonStandard(onTap: _join, label: '회원 가입'),
                              ],
                            );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///todo 이메일 인증 - 인증번호 요청
  _requestEmailVerifyCode() async {
    if (valueNotifierIsProcessingEmailVerify.value) {
      return;
    }

    if (textEditingControllerEmail.text.isEmpty) {
      showSnackBarOnRoute("e메일을 입력해 주세요.");
      return;
    }

    if (EmailValidator.validate(textEditingControllerEmail.text) == false) {
      showSnackBarOnRoute('e메일 형식을 확인해 주세요.');
      return;
    }

    valueNotifierIsProcessingEmailVerify.value = true;

    //body의 데이터
    Map dataRequest = {
      keyEmail: textEditingControllerEmail.text, //email : abc@gmail.com
    };

    //body를 string으로 인코드
    String body = json.encode(dataRequest);

    //데이터를 보낼 url
    String url = '$urlBaseTest/auth/email_verify/request';

    try {
      //응답결과 객체
      http.Response response = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
          .timeout(const Duration(seconds: 10));

      //응답결과 중 body를 json형태로 파싱
      final dataResponse = jsonDecode(response.body);

      //test
/*
      final dataResponse = {keyResult: keySend, keyToken: "x1xd24e"};
*/

      //body 로그 찍기
      MyApp.logger.d("인증번호 요청 응답 결과\n"
          "${dataResponse.toString()}");

      //인증번호가 발송되었다면
      if (dataResponse[keyResult] == keySend) {
        showSnackBarOnRoute("e메일로 인증번호가 발송되었어요.");
        //email 더 이상 수정 못 하도록

        valueNotifierEmailVerifyStateType.value = EmailVerifyStateType.send;
        tokenVerifyEmail = dataResponse[keyToken]; //토큰 저장

        //이미 존재하는 email이라면
      } else if (dataResponse[keyResult] == keyAlreadyExist) {
        showSnackBarOnRoute("이미 가입한 e메일입니다.");
        _resetEmailVerify();

        //기타 알 수 없는 응답이 왔을 경우
      } else {
        showSnackBarOnRoute(messageServerError);
        _resetEmailVerify();
      }

      //예외 처리
    } catch (e) {
      MyApp.logger.wtf("에러 발생 : ${e.toString()}");
      _resetEmailVerify();
    }

    valueNotifierIsProcessingEmailVerify.value = false;
  }

  ///todo 이메일 인증 - 인증번호 확인
  _verifyEmailVerifyCode() async {
    if (textEditingControllerCode.text.isEmpty) {
      showSnackBarOnRoute("인증번호를 입력해 주세요.");
      return;
    }

    if (valueNotifierIsProcessingEmailVerify.value) {
      return;
    }

    valueNotifierIsProcessingEmailVerify.value = true;

    //body의 데이터
    Map dataRequest = {
      keyEmail: textEditingControllerEmail.text, //email : abc@gmail.com
      keyToken: tokenVerifyEmail, //token : x1xd24e
      keyCode: textEditingControllerCode.text, //code : 123456
    };

    //body를 string으로 인코드
    String body = json.encode(dataRequest);

    //데이터를 보낼 url
    String url = '$urlBaseTest/auth/email_verify/verify';

    try {
      //응답결과 객체
      http.Response response = await http
          .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
          .timeout(const Duration(seconds: 10));

      //응답결과 중 body를 json형태로 파싱
      final dataResponse = jsonDecode(response.body);

      //test
/*
      final dataResponse = {keyResult: keyOk, keyEmail: "abc@gmail.com", keyToken: "x1xd24e"};
*/
      //body 로그 찍기
      MyApp.logger.d("인증번호 확인 응답 결과\n"
          "${dataResponse.toString()}");

      //인증번호가 맞다면
      if (dataResponse[keyResult] == keyOk) {
        showSnackBarOnRoute("e메일로 인증에 성공했어요.");
        valueNotifierEmailVerifyStateType.value = EmailVerifyStateType.ok;

        //인증번호가 틀리다면
      } else if (dataResponse[keyResult] == keyWrongCode) {
        showSnackBarOnRoute("잘못된 인증번호예요.");

        //기타 알 수 없는 응답이 왔을 경우
      } else {
        showSnackBarOnRoute(messageServerError);
      }

      //예외 처리
    } catch (e) {
      MyApp.logger.wtf("에러 발생 : ${e.toString()}");
    }

    valueNotifierIsProcessingEmailVerify.value = false;
  }

  ///todo 회원 가입
  ///아직 구현 안 함
  _join() async {
    if (textEditingControllerPss.text.length < lengthPasswordMin) {
      showSnackBarOnRoute('비밀번호는 최소 $lengthPasswordMin글자 예요.');
      return;
    }

    if (textEditingControllerPss.text.length > lengthPasswordMax) {
      showSnackBarOnRoute('비밀번호는 최대 $lengthPasswordMax글자 예요.');
      return;
    }

    if (textEditingControllerPss.text != textEditingControllerPss2.text) {
      showSnackBarOnRoute('비밀번호가 서로 달라요.');
      return;
    }

    if (textEditingControllerNickName.text.length < lengthNickNameMin) {
      showSnackBarOnRoute('별명은 최소 $lengthNickNameMin글자 예요.');
      return;
    }

    if (textEditingControllerNickName.text.length > lengthNickNameMax) {
      showSnackBarOnRoute('별명은 최대 $lengthNickNameMax글자 예요.');
      return;
    }

    Map<String, dynamic> mapData = {
      keyId: textEditingControllerEmail.text,
      keyPassword: textEditingControllerPss.text,
      keyNickName: textEditingControllerNickName.text,
    };

    if (textEditingControllerPhone.text.isNotEmpty) {
      mapData[keyPhone] = textEditingControllerPhone.text;
    }

    if (valueNotifierUserGenderType.value != null) {
      switch (valueNotifierUserGenderType.value) {
        case null:
        case UserGenderType.male:
          mapData[keyGender] = keyMale2;
        case UserGenderType.female:
          mapData[keyGender] = keyFemale2;
        case UserGenderType.error:
      }
    }

    //재 인증 url
    //header 데이터만으로 인증 여부 확인
    String url = "$urlBaseTest/auth/signup";

    try {
      Map<String, dynamic> response = await requestHttpStandard(url, mapData, methodType: MethodType.post);
      MyApp.logger.d("회원가입 응답 결과 : ${response.toString()}");

      //성공
      if (response[keyResult] == keyValid) {
        //실패
      } else {}
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf('오류 발생 : ${e.toString()}');
    }

    Get.back();
  }

  ///이메일 인증 과정을 초기화
  _resetEmailVerify() {
    valueNotifierEmailVerifyStateType.value = EmailVerifyStateType.yet;
    tokenVerifyEmail = null; //토큰 제거
  }

  Future<bool> onWillPop() async {
    var result = await Get.dialog(const DialogRequestConfirm(
      content: '저장하지 않고 나갈까요?',
      labelButton: '나가기',
    ));
    if (result == true) {
      return true;
    } else {
      return false;
    }
  }
}
