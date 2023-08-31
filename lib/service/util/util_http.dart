import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../const/value/key.dart';
import '../../my_app.dart';

final Pattern patternDecodeUnicode = RegExp(r'\\u([0-9A-Fa-f]{4})');
final Map<String, String> headerStandard = {"Content-Type": "application/json"};

enum MethodType { get, post, put, delete }

typedef GetResponse = Future<http.Response> Function();

Future<Map<String, dynamic>> requestHttpStandard(String url, Map requestBodyData,
    {Map<String, String>? headerCustom,
    bool isIncludeModeHeaderCustom = true,
    bool isNeedDecodeUnicode = false,
    MethodType methodType = MethodType.post}) async {
  //body를 string으로 인코드
  String requestBody = json.encode(requestBodyData);

  //데이터를 보낼 url
  //String url = 'https://odik.link/auth/email_verify/verify';

  Map<String, String> header = {...headerStandard};
  if (MyApp.providerUser.modelUser != null) {
    header[keyAuthorization] = 'Bearer ${MyApp.providerUser.modelUser!.tokenOdik}';
  }

  if (headerCustom != null) {
    if (isIncludeModeHeaderCustom) {
      for (var element in headerCustom.keys) {
        header[element] = headerCustom[element]!;
      }
    } else {
      header = headerCustom;
    }
  }

  MyApp.logger.d(""
      "요청 url : $url\n"
      "요청 header : $header\n"
      "요청 body : $requestBody");

  http.Response response;
  switch (methodType) {
    case MethodType.get:
      response = await http.get(Uri.parse(url), headers: header).timeout(const Duration(seconds: 10));
      break;

    case MethodType.post:
      response = await http
          .post(Uri.parse(url), headers: header, body: requestBody)
          .timeout(const Duration(seconds: 10));
      break;
    case MethodType.put:
      response = await http
          .put(Uri.parse(url), headers: header, body: requestBody)
          .timeout(const Duration(seconds: 10));
      break;
    case MethodType.delete:
      response = await http
          .delete(Uri.parse(url), headers: header, body: requestBody)
          .timeout(const Duration(seconds: 10));
      break;
  }

  String responseBody;
  if (isNeedDecodeUnicode) {
    responseBody = response.body.replaceAllMapped(patternDecodeUnicode, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });
  } else {
    responseBody = utf8.decode(response.bodyBytes);
  }

  Map<String, dynamic> responseBodyData = jsonDecode(responseBody);

  return responseBodyData;
}
