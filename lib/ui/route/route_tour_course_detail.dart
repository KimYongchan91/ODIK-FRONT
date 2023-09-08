import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/model_tour_course.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/ui/route/route_list_tour_course.dart';
import 'package:odik/ui/screen/screen_main_map.dart';
import 'package:odik/ui/widget/listview_tour_item_In_tour_course.dart';
import 'package:provider/provider.dart';

import '../../const/model/place/model_direction.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../../service/provider/provider_tour_course_cart.dart';
import '../../service/util/util_http.dart';
import '../../service/util/util_like.dart';
import '../item/item_direction.dart';
import '../item/item_tour_item_cart.dart';

class RouteTourCourseDetail extends StatefulWidget {
  final ModelTourCourse modelTourCourse;

  const RouteTourCourseDetail(this.modelTourCourse, {super.key});

  @override
  State<RouteTourCourseDetail> createState() => _RouteTourCourseDetailState();
}

class _RouteTourCourseDetailState extends State<RouteTourCourseDetail> {
  ValueNotifier<bool> valueNotifierIsLike = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    //초기 좋아요 여부 조회
    getIsLikeTour(modelTourCourse: widget.modelTourCourse).then((value) {
      valueNotifierIsLike.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: MyApp.providerCourseCartMy,
          )
        ],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.modelTourCourse.title}',
                  style: const CustomTextStyle.largeBlackBold(),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => RouteListTourCourse(widget.modelTourCourse.modelUserCore));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${widget.modelTourCourse.modelUserCore.nickName}',
                      style: const CustomTextStyle.bigBlackBold().copyWith(color: Colors.blueAccent),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await MyApp.providerCourseCartMy
                        .addListModelTourItem(widget.modelTourCourse.listModelTourItem, isNotify: true);

                    showSnackBarOnRoute(messageCompleteAddTourItem);
                  },
                  child: Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: valueNotifierIsLike,
                        builder: (context, value, child) => InkWell(
                          onTap: _changeIsLike,
                          child: Icon(
                            value ? Icons.favorite : Icons.favorite_border,
                            size: 36,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: colorPrimary,
                              width: 1.5,
                            )),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.card_travel,
                              color: colorPrimary,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '모두 담기',
                              style: CustomTextStyle.normalBlackBold().copyWith(color: colorPrimary),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),

                ///관광지 아이템 리스트뷰
                ListViewTourItemInTourCourse(
                  modelTourCourseOther: widget.modelTourCourse,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //좋아요 수정
  _changeIsLike() async {
    try {
      await changeIsLikeTour(!valueNotifierIsLike.value, modelTourCourse: widget.modelTourCourse);
      valueNotifierIsLike.value = !valueNotifierIsLike.value;
    } catch (e) {
      //
    }
  }
}
