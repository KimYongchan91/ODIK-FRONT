import '../value/key.dart';

class ModelTourItem {
  final int idx;
  final String referenceIdGoogle;
  final String title;
  final String? type;
  final List<dynamic> listUrlImage;
  final double? pointGoogle;

  //
  final String? phoneNumber;
  final String? address;

  //
  final double locationLat;
  final double locationLng;

  ModelTourItem({
    required this.idx,
    required this.referenceIdGoogle,
    required this.title,
    required this.type,
    required this.listUrlImage,
    required this.pointGoogle,

    //
    required this.phoneNumber,
    required this.address,

    //
    required this.locationLat,
    required this.locationLng,
  });

  ModelTourItem.fromJson(Map<String, dynamic> json)
      : idx = json[keyIdx] ?? 0,
        referenceIdGoogle = json[keyReferenceIdGoogle] ?? '',
        title = json[keyTitle] ?? '',
        type = json[keyType] ?? '',
        listUrlImage = json[keyImagesGoogle] ?? [],
        pointGoogle = json[keyPointGoogle],
        //
        phoneNumber = json[keyPhoneNumber],
        address = json[keyAddress],
        //
        locationLat = json[keyLocationLat] ?? 0,
        locationLng = json[keyLocationLng] ?? 0;

  @override
  String toString() {
    return '''
idx: $idx,
referenceIdGoogle : $referenceIdGoogle, 
title : $title,
//
type : $type,
listUrlImage : $listUrlImage,
pointGoogle : $pointGoogle,
//
phoneNumber : $phoneNumber,
address : $address,
//
locationLat : $locationLat,
locationLng : $locationLng,

''';
  }

  toJson() {
    Map<String, dynamic> result = {
      keyIdx: idx,
      keyReferenceIdGoogle: referenceIdGoogle,
      keyTitle: title,
      keyType: type,
      keyPointGoogle: pointGoogle,
      keyImagesGoogle: listUrlImage,
      //
      keyPhoneNumber: phoneNumber,
      keyAddress: address,
      //
      keyLocationLat: locationLat,
      keyLocationLng: locationLng,
    };

    //따옴표 때문
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelTourItem && runtimeType == other.runtimeType && idx == other.idx;

  @override
  int get hashCode => idx.hashCode;
}
