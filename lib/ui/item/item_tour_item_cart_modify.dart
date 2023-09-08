import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/const/model/place/model_place.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/ui/dialog/dialog_delete_tour_item_for_cart.dart';

import '../../my_app.dart';

const double _sizeImagePlace = 60;

class ItemTourItemForCartModify extends StatelessWidget {
  final ModelTourItem modelTourItem;

  const ItemTourItemForCartModify(this.modelTourItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.no_photography),
                    ),
                    width: _sizeImagePlace,
                    height: _sizeImagePlace,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            var result = await Get.dialog(const DialogDeleteTourItemForCart());
                            if (result == true) {
                              MyApp.providerCourseCartMy.deleteModelTourItem(modelTourItem);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.delete),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          modelTourItem.title,
                          style: const CustomTextStyle.normalBlackBold(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
