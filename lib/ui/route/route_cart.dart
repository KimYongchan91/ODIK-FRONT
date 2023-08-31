import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_course_cart.dart';
import 'package:odik/ui/item/item_direction.dart';
import 'package:odik/ui/item/item_place.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';

class RouteCart extends StatefulWidget {
  const RouteCart({super.key});

  @override
  State<RouteCart> createState() => _RouteCartState();
}

class _RouteCartState extends State<RouteCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerCourseCart),
        ],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<ProviderCourseCart>(
                  builder: (context, provider, child) => Text(
                    provider.title,
                    style: const CustomTextStyle.bigBlackBold(),
                  ),
                ),
                Consumer<ProviderCourseCart>(
                  builder: (context, provider, child) => ListView.separated(
                    itemBuilder: (context, index) => ItemTourItemForCart(provider.listModelTourItem[index]),
                    separatorBuilder: (context, index) => index != provider.listModelTourItem.length - 1
                        ? ItemDirection(
                            modelTourItemOrigin: provider.listModelTourItem[index],
                            modelTourItemOriginDestination: provider.listModelTourItem[index + 1],
                            directionType: DirectionType.car, //todo 김용찬 DirectionType 기본값
                          )
                        : Container(),
                    itemCount: provider.listModelTourItem.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
