import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:odik/const/model/place/model_direction.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_course_cart.dart';
import 'package:odik/ui/item/item_direction.dart';
import 'package:odik/ui/item/item_tour_item_for_cart.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';

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
    MyApp.logger.d("provider.listModelTourItem. 개수 : ${MyApp.providerCourseCart.listModelTourItem.length}");

    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MyApp.providerCourseCart),
        ],
        builder: (context, child) => SafeArea(
          child: Column(
            children: [
              Consumer<ProviderCourseCart>(
                builder: (context, provider, child) => Text(
                  provider.title,
                  style: const CustomTextStyle.bigBlackBold(),
                ),
              ),
              Expanded(
                child: Consumer<ProviderCourseCart>(
                  builder: (context, provider, child) => DragAndDropLists(
                    children: [
                      ...provider.listModelTourItem.asMap().entries.map(
                        (entry) {
                          return DragAndDropList(
                            header: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('${entry.key}일차',style: const CustomTextStyle.normalBlackBold(),)),
                            children: [
                              ...entry.value.map((e) => DragAndDropItem(child: ItemTourItemForCart(e))),
                            ],
                            contentsWhenEmpty: Container()
                          );
                        },
                      )
                    ],
                    onItemReorder: _onItemReorder,
                    onListReorder: _onListReorder,
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    MyApp.logger.d("_onItemReorder\n"
        "oldItemIndex : $oldItemIndex\n"
        "oldListIndex : $oldListIndex\n"
        "newItemIndex : $newItemIndex\n"
        "newListIndex : $newListIndex\n");
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    MyApp.logger.d("_onListReorder\n"
        "oldItemIndex : $oldListIndex\n"
        "oldListIndex : $newListIndex\n");
  }
}
