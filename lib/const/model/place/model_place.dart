import 'package:odik/const/model/place/model_place_auto_complete.dart';

class ModelPlace extends ModelPlaceAutoComplete {
  final String? urlImage;

  ModelPlace({required String title, required String reference, required this.urlImage})
      : super(
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
