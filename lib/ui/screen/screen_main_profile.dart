import 'package:flutter/material.dart';
import 'package:odik/const/value/router.dart';
import 'package:odik/service/provider/provider_user.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../custom/custom_text_style.dart';
import '../../my_app.dart';

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
              children: [
                Consumer<ProviderUser>(
                  builder: (context, value, child) => value.modelUser != null
                      ? Text(
                          value.modelUser!.id,
                          style: const CustomTextStyle.bigBlackBold(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Get.toNamed(keyRouteLogin);
                          },
                          child: const Text('로그인'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
