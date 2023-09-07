import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:expandable/expandable.dart';
import 'package:odik/custom/custom_text_style.dart';

import '../../my_app.dart';
import '../../service/util/util_direction.dart';

class ItemDirection extends StatefulWidget {
  final ModelTourItem modelTourItemOrigin;
  final ModelTourItem modelTourItemOriginDestination;
  final DirectionType directionType;

  const ItemDirection(
      {required this.modelTourItemOrigin,
      required this.modelTourItemOriginDestination,
      required this.directionType,
      super.key});

  @override
  State<ItemDirection> createState() => _ItemDirectionState();
}

class _ItemDirectionState extends State<ItemDirection> {
  late Future<ModelDirection?> futureGetDirection;

  late ValueNotifier<DirectionType> valueNotifierDirectionType;

  @override
  void initState() {
    super.initState();

    valueNotifierDirectionType = ValueNotifier(widget.directionType);

    futureGetDirection = getModelDirection(
      widget.modelTourItemOrigin,
      widget.modelTourItemOriginDestination,
      valueNotifierDirectionType.value,
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

          return ExpandablePanel(
            theme: const ExpandableThemeData(
              hasIcon: false,
            ),
            header: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ValueListenableBuilder(
                  valueListenable: valueNotifierDirectionType,
                  builder: (context, value, child) {
                    String labelType;
                    switch (value) {
                      case DirectionType.car:
                        labelType = '자동차로';
                      case DirectionType.transit:
                        labelType = '대중교통으로';
                      case DirectionType.walk:
                        labelType = '도보로';
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$labelType ${modelDirection.duration ~/ 60}분 이동',
                          style: const CustomTextStyle.smallBlackBold().copyWith(color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blueAccent,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            collapsed: Container(),
            expanded: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: valueNotifierDirectionType,
                  builder: (context, value, child) => SizedBox(
                    height: 30,
                    child: Wrap(
                      children: [
                        ...DirectionType.values.map(
                          (e) {
                            IconData iconData;
                            switch (e) {
                              case DirectionType.car:
                                iconData = FontAwesomeIcons.car;
                                break;
                              case DirectionType.transit:
                                iconData = FontAwesomeIcons.bus;
                                break;
                              case DirectionType.walk:
                                iconData = FontAwesomeIcons.walking;
                                break;
                            }
                            return InkWell(
                              onTap: () {
                                valueNotifierDirectionType.value = e;

                                setState(() {
                                  futureGetDirection = getModelDirection(
                                    widget.modelTourItemOrigin,
                                    widget.modelTourItemOriginDestination,
                                    valueNotifierDirectionType.value,
                                  );
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Icon(
                                  iconData,
                                  color: value == e ? Colors.black : Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  if (valueNotifierDirectionType.value == DirectionType.car) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(),
                        Text('거리 : ${(modelDirection.distance / 1000).toStringAsFixed(1)}km'),
                        Text('소요 시간 : ${modelDirection.duration ~/ 60}분'),
                        Text('택시 요금 : ${modelDirection.fareTaxi}원'),
                        Text('톨비 요금 : ${modelDirection.fareToll}원'),
                      ],
                    );
                  } else if (valueNotifierDirectionType.value == DirectionType.transit) {
                    if (modelDirection.listTransitPlan.isEmpty) {
                      return Container();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
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
                        Row(),
                        Text('거리 : ${(modelDirection.distance / 1000).toStringAsFixed(1)}km'),
                        Text('소요 시간 : ${modelDirection.duration ~/ 60}분'),
                      ],
                    );
                  }
                }),
              ],
            ),
          );
        }
      },
    );
  }
}
