import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odik/const/model/model_tour_course.dart';
import 'package:odik/ui/route/route_tour_course_detail.dart';

class ItemTourCourse extends StatelessWidget {
  final ModelTourCourse modelTourCourse;

  const ItemTourCourse(this.modelTourCourse, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => RouteTourCourseDetail(modelTourCourse));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          height: 120,
          child: Column(
            children: [Text('${modelTourCourse.title}')],
          ),
        ),
      ),
    );
  }
}
