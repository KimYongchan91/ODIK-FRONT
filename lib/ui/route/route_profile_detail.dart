import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_user.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';

class RouteProfileDetail extends StatefulWidget {
  const RouteProfileDetail({super.key});

  @override
  State<RouteProfileDetail> createState() => _RouteProfileDetailState();
}

class _RouteProfileDetailState extends State<RouteProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: MyApp.providerUser)],
        builder: (context, child) => SafeArea(
          child: Consumer<ProviderUser>(
            builder: (context, value, child) => Column(
              children: [
                //id
                Text('${value.modelUser?.id.split("&lt").first}'),

                //nickname
                Text('${value.modelUser?.nickName}'),

                //로그아웃

                InkWell(
                  onTap: () {
                    value.logout();
                    Get.back();
                  },
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: const Text('로그아웃',style: CustomTextStyle.normalGreyBold(),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
