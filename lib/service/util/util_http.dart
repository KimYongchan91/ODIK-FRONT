import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../const/value/key.dart';
import '../../my_app.dart';

final Pattern patternDecodeUnicode = RegExp(r'\\u([0-9A-Fa-f]{4})');
final Map<String, String> headerStandard = {"Content-Type": "application/json"};

Future<Map<String, dynamic>> requestHttpStandard(String url, Map requestBodyData,
    {bool isNeedDecodeUnicode = false}) async {
  //body를 string으로 인코드
  String requestBody = json.encode(requestBodyData);

  //데이터를 보낼 url
  //String url = 'https://odik.link/auth/email_verify/verify';

  final Map<String, String> header = {...headerStandard};
  if (MyApp.providerUser.modelUser != null) {
    header[keyAuthorization] = MyApp.providerUser.modelUser!.tokenOdik;
  }

  http.Response response =
      await http.post(Uri.parse(url), headers: header, body: requestBody).timeout(const Duration(seconds: 10));

  String responseBody;
  if (isNeedDecodeUnicode) {
    responseBody = response.body.replaceAllMapped(patternDecodeUnicode, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });
  } else {
    responseBody = response.body;
  }

  Map<String, dynamic> responseBodyData = jsonDecode(responseBody);

  return responseBodyData;
}
