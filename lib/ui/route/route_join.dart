import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odik/const/value/key.dart';
import 'package:odik/const/value/key_user.dart';
import 'package:odik/const/value/test.dart';
import 'package:odik/custom/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:odik/service/util/util_snackbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../my_app.dart';

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

  ValueNotifier<bool> valueNotifierIsProcessingEmailVerify = ValueNotifier(false);

  ValueNotifier<EmailVerifyStateType> valueNotifierEmailVerifyStateType =
      ValueNotifier(EmailVerifyStateType.yet);
  String? tokenVerifyEmail;

  @override
  void dispose() {
    textEditingControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('회원가입 페이지'),
                  const SizedBox(
                    height: 20,
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
                            children: [
                              CustomTextField(
                                hintText: "비밀번호를 입력해 주세요.",
                                controller: textEditingControllerPss,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                hintText: "비밀번호를 한번더 입력해 주세요.",
                                controller: textEditingControllerPss2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(onPressed: _join, child: Text('회원 가입'))
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
    );
  }

  ///todo 이메일 인증 - 인증번호 요청
  _requestEmailVerifyCode() async {
    if (textEditingControllerEmail.text.isEmpty) {
      showSnackBarOnRoute("e메일을 입력해 주세요.");
      return;
    }

    if (valueNotifierIsProcessingEmailVerify.value) {
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
    String url = 'https://odik.link/auth/email_verify/verify';

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
  _join() {}

  ///이메일 인증 과정을 초기화
  _resetEmailVerify() {
    valueNotifierEmailVerifyStateType.value = EmailVerifyStateType.yet;
    tokenVerifyEmail = null; //토큰 제거
  }
}
