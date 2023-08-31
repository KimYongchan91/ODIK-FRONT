import 'dart:convert';

import 'package:odik/const/model/place/model_place_auto_complete.dart';

import '../../value/key.dart';

class ModelPlace extends ModelPlaceAutoComplete {
  final String? type;
  final List<String> listUrlImage;
  final double? pointGoogle;

  //
  final String? phoneNumber;
  final String? address;

  //
  final double locationLat;
  final double locationLng;

  ModelPlace({
    required String title,
    required String reference,

    //
    required this.type,
    required this.listUrlImage,
    required this.pointGoogle,

    //
    required this.phoneNumber,
    required this.address,

    //
    required this.locationLat,
    required this.locationLng,
  }) : super(
          title: title,
          referenceId: reference,
        );

  ModelPlace.fromJson(Map<String, dynamic> json)
      : type = json[keyType] ?? '',
        listUrlImage = json[keyImagesGoogle] ?? [],
        pointGoogle = json[keyPointGoogle],
        //
        phoneNumber = json[keyPhoneNumber],
        address = json[keyAddress],
        //
        locationLat = json[keyLocationLat],
        locationLng = json[keyLocationLng]
        //
        ,
        super(
          title: json[keyTitle],
          referenceId: keyReferenceIdGoogle,
        );

  @override
  String toString() {
    return '''
title : $title, 
reference : $referenceId,
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
      keyTitle: super.title,
      keyReferenceIdGoogle: super.referenceId,

      //
      keyType: type,
      keyPointGoogle: pointGoogle,
      keyImagesGoogle: listUrlImage,
      keyPhoneNumber: phoneNumber,
      keyAddress: address,
      keyLocationLat: locationLat,
      keyLocationLng: locationLng,
    };

    //따옴표 때문
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ModelPlace && referenceId == other.referenceId;

  @override
  int get hashCode => super.hashCode ^ referenceId.hashCode;
}
