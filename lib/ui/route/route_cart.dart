import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
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
              Consumer<ProviderPlace>(
                builder: (context, value, child) => ListView.separated(
                  itemBuilder: (context, index) => ItemPlace(value.listModelPlace[index]),
                  separatorBuilder: (context, index) => index != value.listModelPlace.length - 1
                      ? ItemDirection(
                          modelPlaceOrigin: value.listModelPlace[index],
                          modelPlaceDestination: value.listModelPlace[index + 1],
                          directionType: DirectionType.car,
                        )
                      : Container(),
                  itemCount: value.listModelPlace.length,
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
