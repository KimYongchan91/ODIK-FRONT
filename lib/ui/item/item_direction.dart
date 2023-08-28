import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/const/model/place/model_place.dart';

import '../../my_app.dart';

class ItemDirection extends StatefulWidget {
  final ModelPlace modelPlaceOrigin;
  final ModelPlace modelPlaceDestination;
  final DirectionType directionType;

  const ItemDirection(
      {required this.modelPlaceOrigin,
      required this.modelPlaceDestination,
      required this.directionType,
      super.key});

  @override
  State<ItemDirection> createState() => _ItemDirectionState();
}

class _ItemDirectionState extends State<ItemDirection> {
  late Future<ModelDirection?> futureGetDirection;

  @override
  void initState() {
    super.initState();

    futureGetDirection = MyApp.providerPlace.getModelDirection(
      widget.modelPlaceOrigin,
      widget.modelPlaceDestination,
      widget.directionType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelDirection?>(
      future: futureGetDirection,
      builder: (context, snapshot) {
        if (snapshot.hasData == false || snapshot.hasError || snapshot.data == null) {
          return Container();
        } else {
          return Container(
            height: 100,
            child: Column(
              children: [
                Text('거리 : ${(snapshot.data!.distance / 1000).toStringAsFixed(1)}km'),
                Text('소요 시간 : ${snapshot.data!.duration ~/ 60}분'),
                Text('택시 요금 : ${snapshot.data!.fareTaxi}원'),
                Text('톨비 요금 : ${snapshot.data!.fareToll}원'),
              ],
            ),
          );
        }
      },
    );
  }
}
