class ModelPlaceAutoComplete {
  final String title;
  final String referenceId;

  ModelPlaceAutoComplete({required this.title, required this.referenceId});

  @override
  String toString() {
    return '''
title : $title 
reference : $referenceId   
''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelPlaceAutoComplete && runtimeType == other.runtimeType && referenceId == other.referenceId;

  @override
  int get hashCode => referenceId.hashCode;
}
