import 'package:flutter/material.dart';
import 'package:odik/const/model/model_tour_item.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:provider/provider.dart';

import '../../service/provider/provider_review_tour_item.dart';

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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    '${widget.modelTourItem.title}',
                    style: CustomTextStyle.largeBlackBold(),
                  ),
                ),
                Text(
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
