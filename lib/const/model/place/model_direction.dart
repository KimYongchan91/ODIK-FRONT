import 'package:odik/const/model/place/model_place.dart';

import 'model_direction_transit_plan.dart';

enum DirectionType { car, transit, walk }

Map<int, String> mapPathType = {
  1: "지하철",
  2: "버스",
  3: "버스+지하철",
  4: "고속/시외버스",
  5: "기차",
  6: "항공",
  7: "해운",
};

class ModelDirection {
  final ModelPlace modelPlaceOrigin;
  final ModelPlace modelPlaceDestination;

  final DirectionType directionType;

  ///car
  final int distance;
  final int duration;
  final int fareTaxi;
  final int fareToll;

  ///transit
  List<ModelDirectionTransitPlan> listTransitPlan;

  ///foot

  ModelDirection({
    required this.modelPlaceOrigin,
    required this.modelPlaceDestination,
    required this.directionType,

    ///car
    this.distance = 0,
    this.duration = 0,
    this.fareTaxi = 0,
    this.fareToll = 0,

    ///transit
    this.listTransitPlan = const [],

    ///foot
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelDirection &&
          runtimeType == other.runtimeType &&
          modelPlaceOrigin == other.modelPlaceOrigin &&
          modelPlaceDestination == other.modelPlaceDestination &&
          directionType == other.directionType;

  @override
  int get hashCode => modelPlaceOrigin.hashCode ^ modelPlaceDestination.hashCode ^ directionType.hashCode;
}
