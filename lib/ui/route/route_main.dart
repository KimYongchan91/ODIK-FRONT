import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:odik/const/value/router.dart';
import 'package:odik/ui/screen/screen_main_home.dart';
import 'package:odik/ui/screen/screen_main_map.dart';
import 'package:odik/ui/screen/screen_main_profile.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show SystemNavigator, rootBundle;

import '../../my_app.dart';

class RouteMain extends StatefulWidget {
  const RouteMain({Key? key}) : super(key: key);

  @override
  State<RouteMain> createState() => _RouteMainState();
}

class _RouteMainState extends State<RouteMain> {
  //앱 종료 방지용
  int timeBackButtonPressed = 0;
  FToast fToast = FToast();

  List<IconData> listIconNavigationBar = [Icons.home, Icons.map, Icons.person];
  ValueNotifier<int> valueNotifierIndexPage = ValueNotifier(0);

  @override
  void initState() {
    fToast.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AddToCartAnimation(
        cartKey: MyApp.keyCart,
        createAddToCartAnimation: (runAddToCartAnimation) {
          MyApp.runAddToCartAnimation = runAddToCartAnimation;
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: MyApp.providerCourseCartMy),
              ],
              builder: (context, child) => SafeArea(
                child: ValueListenableBuilder(
                  valueListenable: valueNotifierIndexPage,
                  builder: (context, value, child) => IndexedStack(
                    index: value,
                    children: const [
                      ScreenMainHome(),
                      ScreenMainMap(),
                      ScreenMainProfile(),
                    ],
                  ),
                ),
              ),
            ),

            ///플로팅 액션 버튼
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () async {
                Get.toNamed(keyRouteCart);
              },
              child: AddToCartIcon(
                key: MyApp.keyCart,
                icon: const Icon(Icons.card_travel),
                badgeOptions: const BadgeOptions(
                  active: false,
                ),
              ),
            ),

            ///플로팅 액션 버튼 위치
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

            ///바텀 네비게이션 바
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: valueNotifierIndexPage,
              builder: (context, value, child) => AnimatedBottomNavigationBar.builder(
                itemCount: listIconNavigationBar.length,
                tabBuilder: (index, isActive) => Icon(
                  listIconNavigationBar[index],
                  color: isActive ? Colors.orange : Colors.grey,
                  size: isActive ? 28 : 24,
                ),
                height: 60,
                //기본값 56
                activeIndex: value,
                gapLocation: GapLocation.end,
                notchSmoothness: NotchSmoothness.defaultEdge,
                onTap: (index) {
                  valueNotifierIndexPage.value = index;
                },
              ),
              //other params
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (Platform.isIOS) {
      return true;
    }

    int timeNow = DateTime.now().millisecondsSinceEpoch;

    if (timeNow - timeBackButtonPressed > 2000) {
      ///기존 토스트 날리기
      fToast.removeCustomToast();

      ///토스트 띄우기
      _showToast();

      timeBackButtonPressed = timeNow;

      return false;
    } else {
      SystemNavigator.pop();
      return false;
    }
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close),
          SizedBox(
            width: 12.0,
          ),
          Text("한 번 더 누르면 종료돼요."),
        ],
      ),
    );

    // Custom Toast Position
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
