import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/value/router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../custom/custom_text_field.dart';
import '../../my_app.dart';
import '../../service/util/util_snackbar.dart';

class RouteLogin extends StatefulWidget {
  const RouteLogin({super.key});

  @override
  State<RouteLogin> createState() => _RouteLoginState();
}

class _RouteLoginState extends State<RouteLogin> {
  TextEditingController textEditingControllerId = TextEditingController();
  TextEditingController textEditingControllerPss = TextEditingController();
  ValueNotifier<bool> valueNotifierIsProcessingLoginWithEmail = ValueNotifier(false);
  ValueNotifier<bool> valueNotifierIsProcessingLoginWithGoogle = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const Text('로그인 페이지'),
                CustomTextField(
                  hintText: "e메일",
                  controller: textEditingControllerId,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  hintText: "비밀번호",
                  controller: textEditingControllerPss,
                ),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder(
                  valueListenable: valueNotifierIsProcessingLoginWithEmail,
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: _loginWithEmail,
                    child: value ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20) : const Text('로그인'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      Expanded(
                        child: Center(
                          child: Text(
                            '구글 로그인',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(keyRouteJoin);
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///todo 이메일 로그인
  _loginWithEmail() async {
    if (valueNotifierIsProcessingLoginWithEmail.value || valueNotifierIsProcessingLoginWithGoogle.value) {
      return;
    }

    if (textEditingControllerId.text.isEmpty) {
      showSnackBarOnRoute('e메일을 입력해 주세요.');
      return;
    }

    if (textEditingControllerPss.text.isEmpty) {
      showSnackBarOnRoute('비밀번호를 입력해 주세요.');
      return;
    }

    valueNotifierIsProcessingLoginWithEmail.value = true;

    //실제 로그인 구현부
    bool isSuccessLogin =
        await MyApp.providerUser.loginWithEmail(textEditingControllerId.text, textEditingControllerPss.text);


    valueNotifierIsProcessingLoginWithEmail.value = false;

    //로그인 성공
    if (isSuccessLogin) {
      Get.back();
    }
  }
}
