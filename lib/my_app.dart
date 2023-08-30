import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:odik/service/provider/provider_place.dart';
import 'package:odik/service/provider/provider_user.dart';

class MyApp {
  static Logger logger = Logger();

  static ProviderUser providerUser = ProviderUser();
  static ProviderCart providerPlace = ProviderCart();

  //fcm  관련
  static late Completer completerInitFcm;
  static String? tokenFcm;

  static final GlobalKey<CartIconKey> keyCart = GlobalKey<CartIconKey>();
  static final GlobalKey keyButtonAddCart = GlobalKey();

  static late Function(GlobalKey) runAddToCartAnimation;

}
