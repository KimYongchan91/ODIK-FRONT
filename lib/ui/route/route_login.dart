import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/value/router.dart';

class RouteLogin extends StatefulWidget {
  const RouteLogin({super.key});

  @override
  State<RouteLogin> createState() => _RouteLoginState();
}

class _RouteLoginState extends State<RouteLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('로그인 페이지'),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(keyRouteJoin);
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
