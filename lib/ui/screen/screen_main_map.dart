import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../my_app.dart';

const Color colorPrimary = Colors.orange;

class ScreenMainMap extends StatefulWidget {
  const ScreenMainMap({super.key});

  @override
  State<ScreenMainMap> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainMap> {
  BitmapDescriptor? currentLocation;
  TextEditingController placeController = TextEditingController();

  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  LatLng latLngDefault =
      const LatLng(37.57583704337702, 126.9768261909485); //광화문 37.57583704337702, 126.9768261909485

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(zoom: 16, target: latLngDefault),
            onMapCreated: (controller) async {
              setState(() {
                googleMapController.complete(controller);
              });
              /* String val = "json/google_map_dark_light.json";
              var c = await rootBundle.loadString(val);
              _controller.setMapStyle(c);*/
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          prefixIcon: Icon(Icons.search, color: colorPrimary),
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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [const Divider()],
                            ),
                            Text(modelPlaceAutoComplete.title)
                          ],
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
                /*  Container(
                  margin: EdgeInsets.zero,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 10.0, spreadRadius: 1, offset: Offset(0, 4))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  "Current Location",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Samakhusi, Rehdon College",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Divider(
                            height: 8,
                            color: colorPrimary.withOpacity(0.6),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  border: Border.all(color: colorPrimary, width: 4),
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                const Text(
                                  "Destination",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    placeController.text.isEmpty
                                        ? "Select Destination"
                                        : placeController.text,
                                    overflow: TextOverflow.visible,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<Iterable<ModelPlaceAutoComplete>> _requestAutoComplete(String keyword) async {
    List<ModelPlaceAutoComplete> listPlaceAutoComplete = [];

    String url =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=${keyword}&language=ko&key=AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';

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
      ModelPlaceAutoComplete  modelPlaceAutoComplete=
          ModelPlaceAutoComplete(title: element["structured_formatting"]["main_text"]);
      listPlaceAutoComplete.add(modelPlaceAutoComplete);
    }

    //MyApp.logger.d("리스트 개수 : ${listPlaceAutoComplete.length}");

    return listPlaceAutoComplete;
  }
}

class ModelPlaceAutoComplete {
  final String title;

  ModelPlaceAutoComplete({required this.title});
}
