import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/model/place/model_place.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/ui/dialog/dialog_delete_tour_item_for_cart.dart';
import 'package:odik/ui/route/route_tour_item_detail.dart';
import 'package:odik/ui/screen/screen_main_map.dart';

import '../../my_app.dart';

const double _sizeImagePlace = 60;

enum ButtonAddCartType { add, already, invisible }

class ItemTourItemForCart extends StatelessWidget {
  final ModelTourItem modelTourItem;
  final ButtonAddCartType buttonAddCartType;

  const ItemTourItemForCart({required this.modelTourItem, required this.buttonAddCartType,  super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => RouteTourItemDetail(modelTourItem));
      },
      child: Card(
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: modelTourItem.listUrlImage.isNotEmpty ? modelTourItem.listUrlImage.first : '',
                      width: _sizeImagePlace,
                      height: _sizeImagePlace,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            modelTourItem.title,
                            style: const CustomTextStyle.normalBlackBold(),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:  buttonAddCartType != ButtonAddCartType.invisible,
                      child: InkWell(
                        onTap: () {
                          MyApp.providerCourseCartMy.addModelTourItem(modelTourItem,isNotify: true);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.card_travel,
                            color:  buttonAddCartType == ButtonAddCartType.add? colorPrimary : Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
