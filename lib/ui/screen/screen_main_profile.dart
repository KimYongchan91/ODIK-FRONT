import 'package:flutter/material.dart';
import 'package:odik/const/value/router.dart';
import 'package:odik/service/provider/provider_user.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/ui/route/route_list_tour_course.dart';
import 'package:odik/ui/route/route_profile_detail.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../custom/custom_text_style.dart';
import '../../my_app.dart';
import '../widget/button_standard.dart';

class ScreenMainProfile extends StatefulWidget {
  const ScreenMainProfile({super.key});

  @override
  State<ScreenMainProfile> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMainProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerUser),
        ],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    '프로필',
                    style: CustomTextStyle.bigBlackBold(),
                  ),
                ),
                Consumer<ProviderUser>(
                  builder: (context, value, child) => value.modelUser != null
                      ? InkWell(
                          onTap: () {
                            Get.to(() => const RouteProfileDetail());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_2_rounded,
                                  size: 48,
                                ),
                                Text(
                                  '${value.modelUser!.nickName ?? value.modelUser!.id.split("&lt").first} >',
                                  style: const CustomTextStyle.bigBlackBold(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: ButtonStandard(
                            onTap: () {
                              Get.toNamed(keyRouteLogin);
                            },
                            label: '로그인',
                          ),
                        ),
                ),
                ButtonStandard(
                  onTap: () {
                    if (MyApp.providerUser.modelUser == null) {
                      showSnackBarOnRoute(messageNeedLogin);
                      return;
                    }

                    Get.to(() => const RouteListTourCourse(null));
                  },
                  label: '내가 등록한 코스',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
