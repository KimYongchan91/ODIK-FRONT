import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:odik/const/model/place/model_place.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/service/util/util_tour_course.dart';
import 'package:odik/ui/item/item_place.dart';
import 'package:odik/ui/item/item_tour_course.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/model/place/model_place_auto_complete.dart';
import '../../const/value/key.dart';
import '../../const/value/place.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../../service/util/util_http.dart';
import 'package:http/http.dart' as http;

import '../../service/util/util_num.dart';

class RouteSearch extends StatefulWidget {
  final String? keyword;

  const RouteSearch({this.keyword, super.key});

  @override
  State<RouteSearch> createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  final TextEditingController textEditingControllerKeyword = TextEditingController();

  final ValueNotifier<String?> valueNotifierKeyword = ValueNotifier(null);
  final ValueNotifier<List<ModelTourCourse>> valueNotifierListModelTourCourse = ValueNotifier([]);
  final ValueNotifier<List<ModelPlace>> valueNotifierModelPlace = ValueNotifier([]);

  @override
  void dispose() {
    textEditingControllerKeyword.dispose();
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    controller: textEditingControllerKeyword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          _search(textEditingControllerKeyword.text);
                        },
                        child: const Icon(Icons.search),
                      ),
                      hintText: '어디로 떠나 볼까요?',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: _search,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: valueNotifierKeyword,
                  builder: (context, value, child) => value != null

                      ///검색 후
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '코스',
                              style: CustomTextStyle.bigBlackBold(),
                            ),

                            ///코스 리스트뷰
                            ValueListenableBuilder(
                              valueListenable: valueNotifierListModelTourCourse,
                              builder: (context, value, child) => ListView.builder(
                                itemBuilder: (context, index) => ItemTourCourse(value[index]),
                                itemCount: value.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),

                            const Text(
                              '관광지',
                              style: CustomTextStyle.bigBlackBold(),
                            ),

                            ///코스 리스트뷰
                            ValueListenableBuilder(
                              valueListenable: valueNotifierModelPlace,
                              builder: (context, value, child) => ListView.builder(
                                itemBuilder: (context, index) => ItemPlace(value[index]),
                                itemCount: value.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            )
                          ],
                        )

                      ///검색  전
                      : const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '최근 검색어',
                              style: CustomTextStyle.bigBlackBold(),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _search(String keyword) {
    _searchCourseFromOdikApi(keyword);
    _searchPlaceFromGoogleMapApi(keyword);
  }

  _searchCourseFromOdikApi(String keyword) async {
    FocusManager.instance.primaryFocus?.unfocus();
    valueNotifierKeyword.value = keyword;

    if (keyword.isEmpty || keyword.trim().isEmpty) {
      showSnackBarOnRoute('검색어를 입력해 주세요.');
      return;
    }

    ///odik api 사용 부분
    String keywordFormatted = keyword.trim().replaceAll("  ", " ");

    String urlOdikApi = "$urlBase/tour/course?keyword=$keywordFormatted&order=like"; //todo 김용찬 order 수정
    String urlOdikApiEncoded = Uri.encodeFull(urlOdikApi);
    MyApp.logger.d("urlOdikApiEncoded : $urlOdikApiEncoded");
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(urlOdikApi, data, methodType: MethodType.get);
      MyApp.logger.d("코스 검색 응답결과 : ${response.toString()}");

      if (response[keyResult] == keyOk) {
        //검색 성공
        List<ModelTourCourse> listModelTourCourse = [];
        for (var element in ((response[keyTourCourses]?[keyContent] ?? []) as List)) {
          ModelTourCourse modelTourCourse = ModelTourCourse.fromJson(element);
          listModelTourCourse.add(modelTourCourse);
        }
        valueNotifierListModelTourCourse.value = listModelTourCourse;
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf("코스 검색에 실패 : ${e.toString()}");
    }
  }

  ///실제 자동 완성 api 요청부
  _searchPlaceFromGoogleMapApi(String keyword) async {
    List<ModelPlace> listModelPlace = [];

    ///구글맵 api 사용 부분
/*    String urlGoogleMapApi ="https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
        "?fields=formatted_address,name,rating,opening_hours,geometry"
    "&input=$keyword"
    "&inputtype=textquery"
    "&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU";*/
    /*String urlGoogleMapApi =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$keyword&language=ko&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';
*/
    String urlGoogleMapApi = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        "?query=$keyword"
        "&language=ko"
        "&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU";

    http.Response response =
        await http.get(Uri.parse(Uri.encodeFull(urlGoogleMapApi))).timeout(const Duration(seconds: 10));

    final Pattern unicodePattern = RegExp(r'\\u([0-9A-Fa-f]{4})');
    final String newStr = response.body.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    //log(newStr);

    Map<String, dynamic> dataNewStr = jsonDecode(newStr);
    List listData = dataNewStr["results"];
    //MyApp.logger.d("원본 리스트 개수 : ${listData.length}");



    for (var element in listData) {

      List<String> listUrlImage = [];

      dynamic photos = element?['photos'];
      if (photos != null && photos is List) {
        for (var element in (photos)) {
          String? imageReference = element['photo_reference'];
          if (imageReference != null) {
            String urlImage = 'https://maps.googleapis.com/maps/api/place/photo?'
                'maxwidth=$sizeImageWidthGoogleMapApi&'
                'photoreference=$imageReference&'
                'key=$keyGoogleMapApi';

            listUrlImage.add(urlImage);
            //print(urlImage);
          }
        }
      }


      String? type;
      List typesBody = (element?['types']??[]) as List;
      for (var element in typesBody) {
        if (mapPlaceType.keys.contains(element)) {
          type = element;
          break;
        }
      }

      ModelPlace modelPlace = ModelPlace(
        title: element['name'],
        reference: element['reference'],

        type: type,
        listUrlImage: listUrlImage,
        pointGoogle: getDoubleFromDynamic(element?['rating'] ?? 0),
        //
        phoneNumber: null,
        //
        address: element['formatted_address'],
        locationLat: getDoubleFromDynamic(element['geometry']?['location']?['lat']),
        locationLng: getDoubleFromDynamic(element['geometry']?['location']?['lng']),
      );

      MyApp.logger.d(modelPlace.toString());
    listModelPlace.add(modelPlace);
/*
      ModelPlaceAutoComplete modelPlaceAutoComplete = ModelPlaceAutoComplete(
          title: element["structured_formatting"]["main_text"], referenceId: element['reference']);
      listPlaceAutoComplete.add(modelPlaceAutoComplete);*/
    }

    valueNotifierModelPlace.value = listModelPlace;

  }

/*_showDetailModelPlaceAutoComplete(ModelPlaceAutoComplete modelPlaceAutoComplete) async {
    */ /*
    https://maps.googleapis.com/maps/api/place/details/json
    ?fields=name%2Crating%2Cformatted_phone_number
    &place_id=ChIJN1t_tDeuEmsRUsoyG83frY4
    &key=YOUR_API_KEY
    */ /*

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${modelPlaceAutoComplete.referenceId}'
        '&language=ko&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';

    //MyApp.logger.d("url : $url");

    http.Response response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    final Pattern unicodePattern = RegExp(r'\\u([0-9A-Fa-f]{4})');
    final String newStr = response.body.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    //MyApp.logger.d(newStr);
    //log(newStr);

    Map<String, dynamic> mapResult = jsonDecode(newStr);

    List<String> listUrlImage = [];

    dynamic photos = mapResult['result']?['photos'];
    if (photos != null && photos is List) {
      for (var element in (photos)) {
        String? imageReference = element['photo_reference'];
        if (imageReference != null) {
          String urlImage = 'https://maps.googleapis.com/maps/api/place/photo?'
              'maxwidth=$sizeImageWidthGoogleMapApi&'
              'photoreference=$imageReference&'
              'key=$keyGoogleMapApi';

          listUrlImage.add(urlImage);
          //print(urlImage);
        }
      }
    }

    String? type;
    List typesBody = mapResult['result']?['types'] as List;
    for (var element in typesBody) {
      if (mapPlaceType.keys.contains(element)) {
        type = element;
        break;
      }
    }

    try {
      ModelPlace modelPlace = ModelPlace(
        title: modelPlaceAutoComplete.title,
        reference: modelPlaceAutoComplete.referenceId,

        type: type,
        listUrlImage: listUrlImage,
        pointGoogle: getDoubleFromDynamic(mapResult['result']?['rating'] ?? 0),
        //
        phoneNumber: mapResult['result']?['formatted_phone_number'],
        //
        address: mapResult['result']?['formatted_address'],
        locationLat: getDoubleFromDynamic(mapResult['result']?['geometry']?['location']?['lat']),
        locationLng: getDoubleFromDynamic(mapResult['result']?['geometry']?['location']?['lng']),
      );

      valueNotifierModelPlace.value = modelPlace;

      googleMapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            modelPlace.locationLat,
            modelPlace.locationLng,
          ),
        ),
      );
    } catch (e) {
      MyApp.logger.wtf("에러 발생 : ${e.toString()}");
    }
  }*/
}
