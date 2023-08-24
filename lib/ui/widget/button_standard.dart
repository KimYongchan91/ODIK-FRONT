import 'package:flutter/material.dart';
import 'package:odik/ui/screen/screen_main_map.dart';

import '../../custom/custom_text_style.dart';

class ButtonStandard extends StatelessWidget {
  final Color color;
  final String label;
  final void Function() onTap;
  final double? width;
  final double height;

  const ButtonStandard(
      {required this.onTap, this.color = colorPrimary, this.label = '확인', this.width,this.height = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: const CustomTextStyle.normalWhite(),
            ),
          ),
        ),
      ),
    );
  }
}
