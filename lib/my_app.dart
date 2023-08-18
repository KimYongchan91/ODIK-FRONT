import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:odik/service/provider/provider_user.dart';

class MyApp {
  static Logger logger = Logger();

  static ProviderUser providerUser = ProviderUser();

  //fcm  관련
  static late Completer completerInitFcm;
  static String? tokenFcm;
}
