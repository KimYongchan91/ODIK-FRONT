import 'package:odik/const/model/model_review_tour_core.dart';
import 'package:odik/const/model/model_tour_item.dart';

class ModelReviewTourItem extends ModelReviewTourCore {
  final ModelTourItem modelTourItem;

  ModelReviewTourItem.fromJson(Map<String, dynamic> json, this.modelTourItem) : super.fromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelReviewTourItem &&
          runtimeType == other.runtimeType &&
          modelTourItem.idx == other.modelTourItem.idx &&
          idx == other.idx;

  @override
  int get hashCode => modelTourItem.idx ^ idx;
}
