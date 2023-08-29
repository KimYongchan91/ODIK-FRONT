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
          final ModelDirection modelDirection = snapshot.data!;

          return Container(
            height: 100,
            child: Builder(builder: (context) {
              if (widget.directionType == DirectionType.car) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('거리 : ${(modelDirection.distance / 1000).toStringAsFixed(1)}km'),
                    Text('소요 시간 : ${modelDirection.duration ~/ 60}분'),
                    Text('택시 요금 : ${modelDirection.fareTaxi}원'),
                    Text('톨비 요금 : ${modelDirection.fareToll}원'),
                  ],
                );
              } else if (widget.directionType == DirectionType.transit) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text('다른 경로 : ${modelDirection.listTransitPlan.length - 1}'),
                      ],
                    ),
                    Text('종류 : ${mapPathType[modelDirection.listTransitPlan.first.pathType] ?? ''}'),
                    Text('환승 횟수 : ${modelDirection.listTransitPlan.first.countTransfer}'),
                    Text('총 소요 시간 : ${modelDirection.listTransitPlan.first.durationTotal ~/ 60}분'
                        '(도보 ${modelDirection.listTransitPlan.first.durationWalk ~/ 60}분 포함)'),
                    Text('총 요금 : ${modelDirection.listTransitPlan.first.fareTotal}원'),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('거리 : ${(modelDirection.distance / 1000).toStringAsFixed(1)}km'),
                    Text('소요 시간 : ${modelDirection.duration ~/ 60}분'),
                  ],
                );
              }
            }),
          );
        }
      },
    );
  }
}
