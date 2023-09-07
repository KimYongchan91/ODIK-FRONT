import 'package:flutter/material.dart';
import 'package:odik/const/model/model_user_core.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/provider/provider_tour_course_public.dart';
import 'package:odik/ui/item/item_tour_course.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';

class RouteListTourCourse extends StatefulWidget {
  final ModelUserCore? modelUserCoreRequest;

  const RouteListTourCourse(this.modelUserCoreRequest, {super.key});

  @override
  State<RouteListTourCourse> createState() => _RouteListTourCourseState();
}

class _RouteListTourCourseState extends State<RouteListTourCourse> {
  late ModelUserCore modelUserCore;
  late ProviderTourCoursePublic providerTourCoursePublic;

  @override
  void initState() {
    super.initState();
    providerTourCoursePublic = ProviderTourCoursePublic();
    if (widget.modelUserCoreRequest == null) {
      //내껄 조회
      modelUserCore = MyApp.providerUser.modelUser!;
    } else {
      modelUserCore = widget.modelUserCoreRequest!;
    }
    providerTourCoursePublic.setModelUserCore(modelUserCore);
    providerTourCoursePublic.getAllTourCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [ChangeNotifierProvider.value(value: providerTourCoursePublic)],
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${modelUserCore.nickName}님의 코스',
                  style: const CustomTextStyle.bigBlackBold(),
                ),
                Consumer<ProviderTourCoursePublic>(
                  builder: (context, value, child) => ListView.builder(
                    itemCount: value.listModelTourCourse.length,
                    itemBuilder: (context, index) => ItemTourCourse(value.listModelTourCourse[index]),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
