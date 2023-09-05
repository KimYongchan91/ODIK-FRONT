import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:odik/const/value/tour_course.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_tour_course_cart.dart';
import 'package:odik/ui/item/item_tour_item_cart_modify.dart';
import 'package:provider/provider.dart';

import '../../const/model/model_tour_item.dart';
import '../../my_app.dart';

class RouteCartModify extends StatefulWidget {
  const RouteCartModify({super.key});

  @override
  State<RouteCartModify> createState() => _RouteCartState();
}

class _RouteCartState extends State<RouteCartModify> {
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
          child: Column(
            children: [
              Consumer<ProviderTourCourseCart>(
                builder: (context, provider, child) => Text(
                  provider.modelTourCourseMy?.title ?? '장바구니',
                  style: const CustomTextStyle.bigBlackBold(),
                ),
              ),
              Expanded(
                child: Consumer<ProviderTourCourseCart>(
                  builder: (context, provider, child) {
                    List<List<ModelTourItem>> listListModelTourItem = [...provider.listModelTourItem];
                    for(int i = 0 ; i <maxCountTourCourseDay - listListModelTourItem.length ; i++){
                      listListModelTourItem.add([]);
                    }

                    return DragAndDropLists(
                      children: [
                        ...listListModelTourItem.asMap().entries.map(
                          (entry) {
                            return DragAndDropList(
                              header: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 120,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${entry.key+1}일차',
                                              style: const CustomTextStyle.normalBlackBold()
                                                  .copyWith(color: Colors.redAccent),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              children: [
                                ...entry.value
                                    .map((e) => DragAndDropItem(child: ItemTourItemForCartModify(e))),
                              ],
                              contentsWhenEmpty: Container(),
                              canDrag: true,
                            );
                          },
                        )
                      ],
                      onItemReorder: provider.onItemReorder,
                      onListReorder: provider.onListReorder,
                      scrollController: scrollController,
                      contentsWhenEmpty: Container(),
/*                    separatorBuilder: (context, index) => index != provider.listModelTourItem.length - 1
                          ? ItemDirection(
                              modelTourItemOrigin: provider.listModelTourItem[index],
                              modelTourItemOriginDestination: provider.listModelTourItem[index + 1],
                              directionType: DirectionType.car, //todo 김용찬 DirectionType 기본값
                            )
                          : Container(),
                      itemCount: provider.listModelTourItem.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),*/
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
