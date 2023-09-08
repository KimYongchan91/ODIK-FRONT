import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_tour_course_cart.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/ui/item/item_button_admin_type.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:odik/ui/route/route_search.dart';
import 'package:odik/ui/widget/badge_cart.dart';
import 'package:provider/provider.dart';

import '../../const/value/admin.dart';

class ScreenMainHome extends StatefulWidget {
  const ScreenMainHome({super.key});

  @override
  State<ScreenMainHome> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const BadgeCartMy(),
              InkWell(
                onTap: () {
                  Get.to(() => const RouteSearch());
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.search,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
