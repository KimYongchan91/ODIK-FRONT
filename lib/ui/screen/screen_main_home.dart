import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';

import '../../my_app.dart';

class ScreenMainHome extends StatefulWidget {
  const ScreenMainHome({super.key});

  @override
  State<ScreenMainHome> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainHome> {
  Set<Marker> setMarker = {};

  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();

  List<LatLng> listLatLng = const [
    LatLng(37.57583704337702, 126.9768261909485), //광화문 37.57583704337702, 126.9768261909485
    LatLng(37.552130864521686, 126.987361907959), //남산타워 37.552130864521686, 126.987361907959
  ];

  //애월 33.468582299688016, 126.31353735923769
  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String googleApiKey = 'AIzaSyDeGTGjfDq6K5qFJXEXz2qvthzNNLM2zXU';
  String totalDistance = 'No route';

  @override
  void initState() {
    super.initState();

    List<Future> listFutureLoadMarkerImage = [];

    listFutureLoadMarkerImage.add(BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(60, 45)),
      "asset/image/sample/resize_202208291317416161.jpg",
    ).then((value) {
      setMarker.add(Marker(
        markerId: MarkerId("1"),
        position: listLatLng[0],
        icon: value,
      ));
    }));

    listFutureLoadMarkerImage.add(BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(60, 45)),
      "asset/image/sample/resize_201512141830100478_d.jpg",
    ).then((value) {
      setMarker.add(Marker(
        markerId: MarkerId("2"),
        position: listLatLng[1],
        icon: value,
      ));
    }));

    Future.wait(listFutureLoadMarkerImage).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng((listLatLng[0].latitude + listLatLng[1].latitude) / 2,
                  (listLatLng[0].longitude + listLatLng[1].longitude) / 2),
              zoom: 13,
            ),
            onMapCreated: (controller) {
              googleMapController.complete(controller);
            },
            markers: setMarker,
            polylines: route.routes,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await route.drawRoute(
                  listLatLng, 'Test routes', Color.fromRGBO(130, 78, 210, 1.0), googleApiKey,
                  travelMode: TravelModes.walking);

              setState(() {
                totalDistance = distanceCalculator.calculateRouteDistance(listLatLng, decimals: 1);
              });
            } catch (e) {
              MyApp.logger.wtf("오류 발생 : ${e.toString()}");

              setState(() {
                totalDistance = "경로 없음";
              });
            }
          },
          child: Text('경로 찾기'),
        ),
        Text('총 경로 : ${totalDistance}')
      ],
    );
  }
}
