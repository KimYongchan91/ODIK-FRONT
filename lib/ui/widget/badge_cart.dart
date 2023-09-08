import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_tour_course_cart.dart';
import 'package:odik/ui/screen/screen_main_map.dart';
import 'package:provider/provider.dart';

import '../../const/value/router.dart';

class BadgeCartMy extends StatelessWidget {
  const BadgeCartMy({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(keyRouteCart);
      },
      child: Consumer<ProviderTourCourseCart>(
        builder: (context, value, child) => Padding(
          padding: EdgeInsets.only(left: 10,bottom: 10),
          child: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -12),
            showBadge: true,
            ignorePointer: false,
            onTap: () {},
            badgeContent: Text(
              '${value.countAllTourItemInCart()}',
              style: CustomTextStyle.smallBlackBold().copyWith(color: Colors.white),
            ),
            badgeAnimation: const badges.BadgeAnimation.rotation(
              animationDuration: Duration(seconds: 1),
              colorChangeAnimationDuration: Duration(seconds: 1),
              loopAnimation: false,
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            badgeStyle: badges.BadgeStyle(
              padding: EdgeInsets.all(5),
              badgeColor: colorPrimary,
            ),
            child: const Icon(Icons.card_travel),
          ),
        ),
      ),
    );
  }
}
