import 'package:flutter/material.dart';
import 'package:odik/custom/custom_text_style.dart';
import 'package:odik/service/util/util_snackbar.dart';
import 'package:odik/service/util/util_tour_course.dart';
import 'package:odik/ui/item/item_tour_course.dart';

import '../../const/model/model_tour_course.dart';
import '../../const/value/key.dart';
import '../../const/value/test.dart';
import '../../my_app.dart';
import '../../service/util/util_http.dart';

class RouteSearch extends StatefulWidget {
  final String? keyword;

  const RouteSearch({this.keyword, super.key});

  @override
  State<RouteSearch> createState() => _RouteSearchState();
}

class _RouteSearchState extends State<RouteSearch> {
  final TextEditingController textEditingControllerKeyword = TextEditingController();

  final ValueNotifier<String?> valueNotifierKeyword = ValueNotifier(null);
  final ValueNotifier<List<ModelTourCourse>> valueNotifierListModelTourCourse = ValueNotifier([]);

  @override
  void dispose() {
    textEditingControllerKeyword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    controller: textEditingControllerKeyword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          _searchByKeyword(textEditingControllerKeyword.text);
                        },
                        child: const Icon(Icons.search),
                      ),
                      hintText: '어디로 떠나 볼까요?',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: _searchByKeyword,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: valueNotifierKeyword,
                  builder: (context, value, child) => value != null

                      ///검색 후
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '코스',
                              style: CustomTextStyle.bigBlackBold(),
                            ),

                            ///코스 리스트뷰
                            ValueListenableBuilder(
                              valueListenable: valueNotifierListModelTourCourse,
                              builder: (context, value, child) => ListView.builder(
                                itemBuilder: (context, index) => ItemTourCourse(value[index]),
                                itemCount: value.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                            )
                          ],
                        )

                      ///검색  전
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '최근 검색어',
                              style: CustomTextStyle.bigBlackBold(),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchByKeyword(String keyword) async {
    FocusManager.instance.primaryFocus?.unfocus();
    valueNotifierKeyword.value = keyword;

    if(keyword.isEmpty || keyword.trim().isEmpty){
      showSnackBarOnRoute('검색어를 입력해 주세요.');
      return;
    }



    ///odik api 사용 부분
    String keywordFormatted = keyword.trim().replaceAll("  ", " ");

    String urlOdikApi = "$urlBase/tour/course?keyword=$keywordFormatted&order=like"; //todo 김용찬 order 수정
    String urlOdikApiEncoded = Uri.encodeFull(urlOdikApi);
    MyApp.logger.d("urlOdikApiEncoded : $urlOdikApiEncoded");
    Map data = {};

    try {
      Map<String, dynamic> response = await requestHttpStandard(urlOdikApi, data, methodType: MethodType.get);
      MyApp.logger.d("코스 검색 응답결과 : ${response.toString()}");

      if (response[keyResult] == keyOk) {
        //검색 성공
        List<ModelTourCourse> listModelTourCourse = [];
        for (var element in ((response[keyTourCourses]?[keyContent] ?? []) as List)) {
          ModelTourCourse modelTourCourse = ModelTourCourse.fromJson(element);
          listModelTourCourse.add(modelTourCourse);
        }
        valueNotifierListModelTourCourse.value = listModelTourCourse;
      }
    } catch (e) {
      //오류 발생
      MyApp.logger.wtf("코스 검색에 실패 : ${e.toString()}");
    }
  }
}
