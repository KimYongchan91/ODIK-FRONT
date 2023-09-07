import 'package:flutter/material.dart';
import 'package:odik/const/model/model_tour_course.dart';

class ItemTourCourse extends StatelessWidget {
  final ModelTourCourse modelTourCourse;

  const ItemTourCourse(this.modelTourCourse, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: 120,
        child: Column(
          children: [
            Text('${modelTourCourse.title}')
          ],
        ),
      ),
    );
  }
}
