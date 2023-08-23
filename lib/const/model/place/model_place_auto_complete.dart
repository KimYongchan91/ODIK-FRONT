class ModelPlaceAutoComplete {
  final String title;
  final String reference;

  ModelPlaceAutoComplete({required this.title, required this.reference});

  @override
  String toString() {
    return '''
title : $title 
reference : $reference   
''';
  }
}
