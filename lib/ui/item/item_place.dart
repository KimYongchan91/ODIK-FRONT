import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odik/const/model/place/model_place.dart';

import '../../custom/custom_text_style.dart';
import '../screen/screen_main_map.dart';
double _sizeImageGoogleMap = 80;

class ItemPlace extends StatelessWidget {
  final ModelPlace modelPlace;

  const ItemPlace(this.modelPlace, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey)
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///제목
          Row(
            children: [
              Text(
                modelPlace.title,
                style: const CustomTextStyle.normalBlackBold(),
              ),
              const Spacer(),

            ],
          ),

          ///별점 영역
          Row(
            children: [
              RatingBarIndicator(
                rating: modelPlace.pointGoogle ?? 0.0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 12.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(
                width: 10,
              ),
              Text('${modelPlace.pointGoogle ?? 0}')
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          ///이미지
          SizedBox(
            height: _sizeImageGoogleMap,
            child: ListView.separated(
              itemBuilder: (context, index) => CachedNetworkImage(
                imageUrl: modelPlace.listUrlImage[index],
                width: _sizeImageGoogleMap,
                height: _sizeImageGoogleMap,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, url) => Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: colorPrimary,
                    size: 24,
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 5,
              ),
              itemCount: modelPlace.listUrlImage.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
            ),
          ),

        ],
      ),
    );
  }
}
