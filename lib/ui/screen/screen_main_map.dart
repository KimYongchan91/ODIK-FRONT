import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odik/const/value/place.dart';
import 'package:odik/const/value/test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/ui/widget/button_standard.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

import '../../const/model/place/model_place.dart';
import '../../const/model/place/model_place_auto_complete.dart';
import '../../my_app.dart';
import 'dart:developer';

const Color colorPrimary = Colors.orange;
double sizeImageGoogleMap = 80;

class ScreenMainMap extends StatefulWidget {
  const ScreenMainMap({super.key});

  @override
  State<ScreenMainMap> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainMap> {
  BitmapDescriptor? currentLocation;
  TextEditingController placeController = TextEditingController();

  late final GoogleMapController googleMapController;
  LatLng latLngDefault =
      const LatLng(37.57583704337702, 126.9768261909485); //광화문 37.57583704337702, 126.9768261909485

  ValueNotifier<ModelPlace?> valueNotifierModelPlace = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///전체 화면 지도
        Positioned.fill(
          child: GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(zoom: 16, target: latLngDefault),
            onMapCreated: (controller) async {
              googleMapController = controller;

              /* String val = "json/google_map_dark_light.json";
              var c = await rootBundle.loadString(val);
              _controller.setMapStyle(c);*/
            },
            onTap: (argument) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ),

        ///검색 부분
        ValueListenableBuilder(
          valueListenable: valueNotifierModelPlace,
          builder: (context, value, child) => value != null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          // height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    blurRadius: 8.0,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4))
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: TypeAheadFormField<ModelPlaceAutoComplete>(
                            onSuggestionSelected: (suggestion) {},
                            getImmediateSuggestions: true,
                            keepSuggestionsOnLoading: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                style: GoogleFonts.lato(),
                                controller: placeController,
                                // style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  isDense: false,
                                  fillColor: Colors.transparent,
                                  filled: false,
                                  prefixIcon: const Icon(Icons.search, color: colorPrimary),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          placeController.clear();
                                        });
                                      },
                                      child: const Icon(Icons.clear, color: Colors.red)),
                                  // contentPadding:
                                  //     const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  hintText: "어디로 떠나 볼까요?",
                                  hintStyle: GoogleFonts.lato(),

                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                )),
                            itemBuilder: (context, ModelPlaceAutoComplete modelPlaceAutoComplete) {
                              return InkWell(
                                onTap: () {
                                  _showDetailModelPlaceAutoComplete(modelPlaceAutoComplete);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(),
                                        ],
                                      ),
                                      Text(modelPlaceAutoComplete.title)
                                    ],
                                  ),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container();
                              // return Wrap(
                              //   children: const [
                              //     Center(
                              //         heightFactor: 2,
                              //         child: Text(
                              //           "Location Not Found!!",
                              //           style: TextStyle(
                              //             fontSize: 12,
                              //           ),
                              //         )),
                              //   ],
                              // );
                            },
                            suggestionsCallback: _requestAutoComplete,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
        ),

        ///선택된 관광지 보여주는 부분
        ValueListenableBuilder(
          valueListenable: valueNotifierModelPlace,
          builder: (context, value, child) => value != null
              ? Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  width: Get.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///제목
                      Row(
                        children: [
                          Text(
                            value.title,
                            style: const CustomTextStyle.normalBlackBold(),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              valueNotifierModelPlace.value = null;
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 5),
                              child: Icon(Icons.close),
                            ),
                          )
                        ],
                      ),

                      ///별점 영역
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: value.pointGoogle ?? 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 12.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${value.pointGoogle ?? 0}')
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      ///이미지
                      SizedBox(
                        height: sizeImageGoogleMap,
                        child: ListView.separated(
                          itemBuilder: (context, index) => CachedNetworkImage(
                            imageUrl: value.listUrlImage[index],
                            width: sizeImageGoogleMap,
                            height: sizeImageGoogleMap,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            placeholder: (context, url) => Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color: colorPrimary,
                                size: 24,
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                          itemCount: value.listUrlImage.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              ///장바구니에 추가
                              onTap: () async {
                                await MyApp.runAddToCartAnimation(MyApp.keyButtonAddCart);

                                MyApp.providerCart.addPlace(valueNotifierModelPlace.value!);

                              },
                              child: Card(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        key: MyApp.keyButtonAddCart,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary,
                                          ),
                                          child: const Icon(
                                            Icons.card_travel,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: colorPrimary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Text(
                                            '장바구니',
                                            style: CustomTextStyle.normalWhite(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*Container(



                              ),*/
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  ///자동 완성
  Future<Iterable<ModelPlaceAutoComplete>> _requestAutoComplete(String keyword) async {
    Completer<List<ModelPlaceAutoComplete>> completer = Completer();
    EasyDebounce.debounce(
      'my-debouncer',
      const Duration(milliseconds: 500),
      () {
        _searchAutoComplete(keyword).then((value) {
          completer.complete(value);
        });
      },
    );

    List<ModelPlaceAutoComplete> result = await completer.future;

    return result;
  }

  ///실제 자동 완성 api 요청부
  Future<List<ModelPlaceAutoComplete>> _searchAutoComplete(String keyword) async {
    List<ModelPlaceAutoComplete> listPlaceAutoComplete = [];

    String url =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$keyword&language=ko&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';

    http.Response response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    final Pattern unicodePattern = RegExp(r'\\u([0-9A-Fa-f]{4})');
    final String newStr = response.body.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    MyApp.logger.d("응답 결과 : $newStr");

    Map<String, dynamic> data = jsonDecode(newStr);
    List listData = data["predictions"];
    //MyApp.logger.d("원본 리스트 개수 : ${listData.length}");

    for (var element in listData) {
      ModelPlaceAutoComplete modelPlaceAutoComplete = ModelPlaceAutoComplete(
          title: element["structured_formatting"]["main_text"], referenceId: element['reference']);
      listPlaceAutoComplete.add(modelPlaceAutoComplete);
    }

    //MyApp.logger.d("결과 리스트 개수 : ${listPlaceAutoComplete.length}");
    MyApp.logger.d("결과 리스트 개수 : ${listPlaceAutoComplete.toString()}");

    return listPlaceAutoComplete;
  }

  _showDetailModelPlaceAutoComplete(ModelPlaceAutoComplete modelPlaceAutoComplete) async {
    /*
    https://maps.googleapis.com/maps/api/place/details/json
    ?fields=name%2Crating%2Cformatted_phone_number
    &place_id=ChIJN1t_tDeuEmsRUsoyG83frY4
    &key=YOUR_API_KEY
    */

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${modelPlaceAutoComplete.referenceId}'
        '&language=ko&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';

    MyApp.logger.d("url : $url");

    http.Response response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    final Pattern unicodePattern = RegExp(r'\\u([0-9A-Fa-f]{4})');
    final String newStr = response.body.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    //MyApp.logger.d(newStr);
    log(newStr);

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
    List typesBody =  mapResult['result']?['types'] as List;
    for (var element in typesBody) {
      if(mapPlaceType.keys.contains(element)){
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
        pointGoogle: mapResult['result']?['rating'],
        //
        phoneNumber: mapResult['result']?['formatted_phone_number'],
        //
        address: mapResult['result']?['formatted_address'],
        locationLat: mapResult['result']?['geometry']?['location']?['lat'],
        locationLng: mapResult['result']?['geometry']?['location']?['lng'],
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
  }
}
