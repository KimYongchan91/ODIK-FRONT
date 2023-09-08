import 'package:flutter/material.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';
import '../../service/provider/provider_review_tour_item.dart';
import '../../service/provider/provider_tour_course_cart.dart';
import '../screen/screen_main_map.dart';

class RouteTourItemDetail extends StatefulWidget {
  final ModelTourItem modelTourItem;

  const RouteTourItemDetail(this.modelTourItem, {super.key});

  @override
  State<RouteTourItemDetail> createState() => _RouteTourItemDetailState();
}

class _RouteTourItemDetailState extends State<RouteTourItemDetail> {
  late ProviderReviewTourItem providerReviewTourItem;

  @override
  void initState() {
    super.initState();

    providerReviewTourItem = ProviderReviewTourItem(widget.modelTourItem);
    providerReviewTourItem.getReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: providerReviewTourItem),
        ],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    '${widget.modelTourItem.title}',
                    style: const CustomTextStyle.largeBlackBold(),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        ResultAddTourItemType resultAddTourItemType =  await MyApp.providerCourseCartMy
                            .addModelTourItem(widget.modelTourItem, isNotify: true, isChangeWithServer: true);

                        switch(resultAddTourItemType){
                          case ResultAddTourItemType.ok:
                            showSnackBarOnRoute(messageCompleteAddTourItem);
                          case ResultAddTourItemType.already:
                            showSnackBarOnRoute(messageAlreadyExistInCart);
                          case ResultAddTourItemType.error:
                            showSnackBarOnRoute(messageServerError);
                          case ResultAddTourItemType.yet:

                        }


                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: colorPrimary,
                              width: 1.5,
                            )),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.card_travel,
                              color: colorPrimary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '담기',
                              style: const CustomTextStyle.normalBlackBold().copyWith(color: colorPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '리뷰',
                  style: CustomTextStyle.normalBlackBold(),
                ),
                /* Consumer<ProviderReviewTourItem>(
                  builder: (context, value, child) => ListView.builder(itemBuilder: ,),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
