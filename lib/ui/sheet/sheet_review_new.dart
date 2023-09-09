import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/model_review_tour_core.dart';
import 'package:odik/ui/widget/button_standard.dart';

class SheetReviewNew<R extends ModelReviewTourCore> extends StatefulWidget {
  final R? r;

  const SheetReviewNew({this.r, super.key});

  @override
  State<SheetReviewNew> createState() => _SheetReviewNewState();
}

class _SheetReviewNewState<R extends ModelReviewTourCore> extends State<SheetReviewNew> {
  late ValueNotifier<double> valueNotifierRating;
  late TextEditingController textEditingControllerContent;

  @override
  void initState() {
    super.initState();

    if (widget.r != null) {
      valueNotifierRating = ValueNotifier(widget.r!.rating);
      textEditingControllerContent = TextEditingController(text: widget.r!.content);
    } else {
      valueNotifierRating = ValueNotifier(5);
      textEditingControllerContent = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            12,
          ),
          topLeft: Radius.circular(
            12,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Center(
                  child: Text('리뷰 남기기'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () {
                        Get.back(result: null);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          RatingBar.builder(
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            allowHalfRating: true,
            onRatingUpdate: (value) {
              valueNotifierRating.value = value;
            },
            initialRating: valueNotifierRating.value,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              controller: textEditingControllerContent,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
              minLines: 4,
            ),
          ),
          ButtonStandard(
            onTap: () {
              Get.back();
            },
          )
        ],
      ),
    );
  }
}
