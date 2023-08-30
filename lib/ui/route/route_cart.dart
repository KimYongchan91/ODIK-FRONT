import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_place.dart';
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
  ValueNotifier<DirectionType> valueNotifierDirectionType = ValueNotifier(DirectionType.car);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerPlace),
        ],
        builder: (context, child) => SafeArea(
          child: Column(
            children: [
              Consumer<ProviderCart>(
                builder: (context, providerCart, child) => Text(
                  providerCart.title,
                  style: CustomTextStyle.bigBlackBold(),
                ),
              ),
              Consumer<ProviderCart>(
                builder: (context, providerCart, child) => ListView.separated(
                  itemBuilder: (context, index) => ItemPlace(providerCart.listModelPlace[index]),
                  separatorBuilder: (context, index) => index != providerCart.listModelPlace.length - 1
                      ? ValueListenableBuilder(
                          valueListenable: valueNotifierDirectionType,
                          builder: (context, directionType, child) => ItemDirection(
                            modelPlaceOrigin: providerCart.listModelPlace[index],
                            modelPlaceDestination: providerCart.listModelPlace[index + 1],
                            directionType: directionType,
                          ),
                        )
                      : Container(),
                  itemCount: providerCart.listModelPlace.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
