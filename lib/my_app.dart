import 'dart:async';

import 'package:logger/logger.dart';
import 'package:odik/service/provider/provider_sql.dart';
import 'package:odik/service/provider/provider_tour_course_cart.dart';
import 'package:odik/service/provider/provider_tour_course_public.dart';
import 'package:odik/service/provider/provider_user.dart';

import 'const/model/place/model_direction.dart';

class MyApp {
  static Logger logger = Logger();

  static ProviderUser providerUser = ProviderUser();
  static ProviderTourCourseCart providerCourseCartMy = ProviderTourCourseCart();
  static ProviderTourCoursePublic providerCoursePublicMy = ProviderTourCoursePublic();

  static List<ModelDirection> listModelDirection = []; //길찾기 memory용

  static ProviderSQL providerSQL = ProviderSQL();

  //fcm  관련
  static late Completer completerInitFcm;
  static String? tokenFcm;

}
