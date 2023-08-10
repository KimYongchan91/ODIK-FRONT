import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyApp {
  static Logger logger = Logger();


  //fcm  관련
  static late Completer completerInitFcm;
  static String? tokenFcm;


}
