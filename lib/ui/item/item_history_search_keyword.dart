import 'package:flutter/material.dart';
import 'package:odik/const/model/model_history_search_keyword.dart';
import 'package:odik/custom/custom_text_style.dart';

import '../../my_app.dart';

class ItemHistorySearchKeyword extends StatelessWidget {
  final ModelHistorySearchKeyword modelHistorySearchKeyword;
  final void Function()? onTapeKeyword;
  final void Function()? onTapDeleteKeyword;

  const ItemHistorySearchKeyword(this.modelHistorySearchKeyword,
      {this.onTapeKeyword, this.onTapDeleteKeyword, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapeKeyword,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Text(
              modelHistorySearchKeyword.keyword,
              style: CustomTextStyle.normalBlackBold(),
            ),
            Spacer(),
            Visibility(
              visible: onTapDeleteKeyword != null,
              child: InkWell(
                onTap: onTapDeleteKeyword,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.close),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
