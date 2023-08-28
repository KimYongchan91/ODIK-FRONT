import 'package:odik/const/model/place/model_place.dart';

enum DirectionType { car, transit, foot }

 class ModelDirection {
  final ModelPlace modelPlaceOrigin;
  final ModelPlace modelPlaceDestination;

  final DirectionType directionType;

  final int distance;
  final int duration;

  ///car
  final int fareTaxi;
  final int fareToll;

  ///transit
  final int countTransfer;
  final int fare;

  ///foot

  ModelDirection({
    required this.modelPlaceOrigin,
    required this.modelPlaceDestination,
    required this.directionType,
    required this.distance,
    required this.duration,
    ///car
    this.fareTaxi = 0,
    this.fareToll = 0,
    ///transit
    this.countTransfer =0,
    this.fare = 0,
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
