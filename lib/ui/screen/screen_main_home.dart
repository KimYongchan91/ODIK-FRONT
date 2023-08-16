import 'package:flutter/material.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/ui/item/item_button_admin_type.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../const/value/admin.dart';

typedef Send = Future<http.Response> Function();

class ScreenMainHome extends StatefulWidget {
  const ScreenMainHome({super.key});

  @override
  State<ScreenMainHome> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainHome> {
  ValueNotifier<AdminType?> valueNotifierAdminType = ValueNotifier(null);
  TextEditingController textEditingControllerBodyContent = TextEditingController();

  ValueNotifier<bool> valueNotifierIsProcessingSend = ValueNotifier(false);
  ValueNotifier<String> valueNotifierResponse = ValueNotifier("");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              '관리자 계정 선택',
              style: CustomTextStyle.normalBlackBold(),
            ),
            const SizedBox(
              height: 10,
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifierAdminType,
              builder: (context, value, child) => Wrap(
                children: [
                  ...AdminType.values.map((e) => InkWell(
                      onTap: () {
                        _onTapButtonAdminType(e);
                      },
                      child: ItemButtonAdminType(adminType: e, isSelected: e == value)))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'body 내용',
                  style: CustomTextStyle.normalBlackBold(),
                ),
                Spacer(),
                const Text(
                  'body의 content 이름으로 전송',
                  style: CustomTextStyle.normalGrey(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: textEditingControllerBodyContent,
              minLines: 4,
              maxLines: 4,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifierIsProcessingSend,
              builder: (context, value, child) => ElevatedButton(
                onPressed: _send,
                child: value ? LoadingAnimationWidget.inkDrop(color: Colors.white, size: 20) : Text('전송'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'response 결과',
              style: CustomTextStyle.normalBlackBold(),
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifierResponse,
              builder: (context, value, child) => Text(value),
            ),
          ],
        ),
      ),
    );
  }

  _send() async {
    if (valueNotifierAdminType.value == null) {
      showSnackBarOnRoute('관리자를 선택해 주세요!!');
      return;
    }

    if (valueNotifierIsProcessingSend.value) {
      return;
    }

    valueNotifierIsProcessingSend.value = true;

    Send send;
    switch (valueNotifierAdminType.value) {
      case AdminType.kke:
        send = _sendByKke;

      case AdminType.kse:
        send = _sendByKse;

      case AdminType.kyc:
        send = _sendByKyc;

      case AdminType.syh:
        send = _sendBySyh;

      default:
        send = _sendByDefault;
    }

    http.Response response = await send();

    //결과 받아 와서 화면에 표시
    valueNotifierResponse.value = '응답 status code : ${response.statusCode}\n'
        '응답 body : \n'
        '${response.body}';

    valueNotifierIsProcessingSend.value = false;
  }

  ///todo 경은님 코드 부분
  ///url부분을 변경해보세요.
  Future<http.Response> _sendByKke() async {
    //입력된 데이터를 담은 body
    //현재 content 값에는 키보드로 입력받은 데이터가 들어있습니다.
    //필요할 경우 다양한 값 추가 가능
    Map data = {
      'content': textEditingControllerBodyContent.text, //키보드 입력값
      'title': '테스트',
      'userId': 5,
      //'key2' : 'value2',
    };

    //body를 string으로 인코드
    String body = json.encode(data);

    //데이터를 보낼 url
    String url = 'https://dummyjson.com/posts/add';

    //상위 함수에 데이터 결과 전달
    //제한 시간 10초
    return await http
        .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10));
  }

  ///todo 승은님 코드 부분
  Future<http.Response> _sendByKse() async {
    //입력된 데이터를 담은 body
    //현재 content 값에는 키보드로 입력받은 데이터가 들어있습니다.
    //필요할 경우 다양한 값 추가 가능
    Map data = {
      'content': textEditingControllerBodyContent.text, //키보드 입력값
      'title': '테스트',
      'userId': 5,
      //'key2' : 'value2',
    };

    //body를 string으로 인코드
    String body = json.encode(data);

    //데이터를 보낼 url
    String url = 'https://dummyjson.com/posts/add';

    //상위 함수에 데이터 결과 전달
    //제한 시간 10초
    return await http
        .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10));
  }

  ///todo 용찬님 코드 부분
  Future<http.Response> _sendByKyc() async {
    //입력된 데이터를 담은 body
    //현재 content 값에는 키보드로 입력받은 데이터가 들어있습니다.
    //필요할 경우 다양한 값 추가 가능
    Map data = {
      'content': textEditingControllerBodyContent.text, //키보드 입력값
      'title': '테스트',
      'userId': 5,
      //'key2' : 'value2',
    };

    //body를 string으로 인코드
    String body = json.encode(data);

    //데이터를 보낼 url
    String url = 'https://dummyjson.com/posts/add';

    //상위 함수에 데이터 결과 전달
    //제한 시간 10초
    return await http
        .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10));
  }

  ///todo 연화님 코드 부분
  Future<http.Response> _sendBySyh() async {
    //입력된 데이터를 담은 body
    //현재 content 값에는 키보드로 입력받은 데이터가 들어있습니다.
    //필요할 경우 다양한 값 추가 가능
    Map data = {
      'content': textEditingControllerBodyContent.text, //키보드 입력값
      'title': '테스트',
      'userId': 5,
      //'key2' : 'value2',
    };

    //body를 string으로 인코드
    String body = json.encode(data);

    //데이터를 보낼 url
    String url = 'https://dummyjson.com/posts/add';

    //상위 함수에 데이터 결과 전달
    //제한 시간 10초
    return await http
        .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10));
  }

  ///todo 선택 안했을 경우 코드 부분
  Future<http.Response> _sendByDefault() async {
    //입력된 데이터를 담은 body
    //현재 content 값에는 키보드로 입력받은 데이터가 들어있습니다.
    //필요할 경우 다양한 값 추가 가능
    Map data = {
      'content': textEditingControllerBodyContent.text, //키보드 입력값
      'title': '테스트',
      'userId': 5,
      //'key2' : 'value2',
    };

    //body를 string으로 인코드
    String body = json.encode(data);

    //데이터를 보낼 url
    String url = 'https://dummyjson.com/posts/add';

    //상위 함수에 데이터 결과 전달
    //제한 시간 10초
    return await http
        .post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10));
  }

  _onTapButtonAdminType(AdminType adminType) {
    if (valueNotifierAdminType.value == adminType) {
      valueNotifierAdminType.value = null;
    } else {
      valueNotifierAdminType.value = adminType;
    }
  }
}
