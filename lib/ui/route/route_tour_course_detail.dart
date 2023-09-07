import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:odik/const/model/model_tour_course.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/ui/screen/screen_main_map.dart';

import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../../service/util/util_http.dart';
import '../../service/util/util_like.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Text(
              '${widget.modelTourCourse.title}',
              style: CustomTextStyle.largeBlackBold(),
            ),
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
          ],
        ),
      ),
    );
  }

  //좋아요 수정
  _changeIsLike() async {
    try {
      await changeIsLikeTour(!valueNotifierIsLike.value,modelTourCourse: widget.modelTourCourse);
      valueNotifierIsLike.value = !valueNotifierIsLike.value;
    } catch (e) {
      //
    }
  }
}
