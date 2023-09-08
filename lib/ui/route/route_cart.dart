import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_tour_course_cart.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/ui/dialog/dialog_request_confirm.dart';
import 'package:odik/ui/item/item_direction.dart';
import 'package:odik/ui/item/item_tour_item_cart_modify.dart';
import 'package:odik/ui/route/route_cart_modify.dart';
import 'package:odik/ui/widget/button_standard.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';
import '../item/item_tour_item_cart.dart';
import '../widget/listview_tour_item_In_tour_course.dart';

class RouteCart extends StatefulWidget {
  const RouteCart({super.key});

  @override
  State<RouteCart> createState() => _RouteCartState();
}

class _RouteCartState extends State<RouteCart> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //MyApp.logger.d("provider.listModelTourItem. 개수 : ${MyApp.providerCourseCart.listModelTourItem.length}");

    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerCourseCartMy),
        ],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///상단 장바구니, 편집 버튼
                Consumer<ProviderTourCourseCart>(
                  builder: (context, provider, child) => Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          provider.modelTourCourseMy?.title ?? '장바구니',
                          style: const CustomTextStyle.bigBlackBold(),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const RouteCartModify());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '편집',
                            style: CustomTextStyle.normalGreyBold(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///일정 상세 영역
                const ListViewTourItemInTourCourse(),

                const SizedBox(
                  height: 40,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ButtonStandard(
                    onTap: changeTourCourseState,
                    label: '공개하기',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  changeTourCourseState() async {
    if (MyApp.providerCourseCartMy.modelTourCourseMy!.listModelTourItem.isEmpty) {
      showSnackBarOnRoute('코스가 비었어요.');
      return;
    }

    var result = await Get.dialog(const DialogRequestConfirm(
      content: '코스를 공개할까요?',
      labelButton: "공개",
    ));
    if (result == true) {
      //공개로 전환
      await MyApp.providerCourseCartMy
          .changeTourCourseWithServer(tourCourseStateType: TourCourseStateType.public);

      //카트 초기화
      MyApp.providerCourseCartMy.clearProvider();

      //카트 받아오기
      MyApp.providerCourseCartMy.getCart();
    }
  }
}
