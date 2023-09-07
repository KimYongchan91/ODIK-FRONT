import 'package:flutter/material.dart';
import 'package:odik/const/model/model_tour_course.dart';
import 'package:provider/provider.dart';

import '../../const/model/place/model_direction.dart';
import '../../custom/custom_text_style.dart';
import '../../service/provider/provider_tour_course_cart.dart';
import '../item/item_direction.dart';
import '../item/item_tour_item_cart.dart';

class ListViewTourItemInTourCourse extends StatelessWidget {
  final ModelTourCourse modelTourCourse;
  const ListViewTourItemInTourCourse(this.modelTourCourse,{super.key});

  @override
  Widget build(BuildContext context) {

    //여기서 provider는 내 장바구니
    return Consumer<ProviderTourCourseCart>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.modelTourCourseMy!.listModelTourItem.length,
          itemBuilder: (context, index) {
            //뒤에 필요 없는 일차는 제거
            bool isDummy = true;

            for (int i = index; i < provider.modelTourCourseMy!.listModelTourItem.length; i++) {
              if (provider.modelTourCourseMy!.listModelTourItem[i].isNotEmpty) {
                isDummy = false;
                break;
              }
            }

            if (isDummy) {
              return Container();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: index == 0 ? 10 : 30, left: 10, right: 10, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}일차',
                        style: const CustomTextStyle.normalBlueBold(),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  itemCount: provider.modelTourCourseMy!.listModelTourItem[index].length,
                  itemBuilder: (context, index2) => ItemTourItemForCart(
                    provider.modelTourCourseMy!.listModelTourItem[index][index2],
                  ),
                  separatorBuilder: (context, index2) =>
                  index2 != provider.modelTourCourseMy!.listModelTourItem[index].length - 1
                      ? ItemDirection(
                    modelTourItemOrigin: provider.modelTourCourseMy!.listModelTourItem[index][index2],
                    modelTourItemOriginDestination: provider.modelTourCourseMy!.listModelTourItem[index]
                    [index2 + 1],
                    directionType: DirectionType.car,
                  )
                      : Container(),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              ],
            );
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}
