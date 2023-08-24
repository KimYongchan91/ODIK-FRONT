import 'package:odik/const/model/place/model_place_auto_complete.dart';

class ModelPlace extends ModelPlaceAutoComplete {
  final List<String> listUrlImage;
  final double? pointGoogle;

  ModelPlace({
    required String title,
    required String reference,
    required this.listUrlImage,
    required this.pointGoogle,
  }) : super(
          title: title,
          reference: reference,
        );

  @override
  String toString() {
    return '''
title : $title 
reference : $reference   
''';
  }
}
