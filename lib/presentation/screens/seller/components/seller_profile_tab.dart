import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import 'about_screen.dart';
import 'education_tab.dart';
import 'review_tab.dart';
import 'service_screen.dart';

class SupplierTabContents extends StatefulWidget {
  const SupplierTabContents({super.key});

  @override
  State<SupplierTabContents> createState() => _SupplierTabContentsState();
}

class _SupplierTabContentsState extends State<SupplierTabContents> {
  int _currentIndex = 0;
  late List<Widget> detailScreen;
  @override
  void initState() {
    super.initState();

    detailScreen = [
      const ServiceTabScreen(),
       const AboutScreen(),
      const ReviewTab(),
      const EducationTab(),
      const LanguageTab(),
      const SkillTab(),
    ];

  }


  @override
  Widget build(BuildContext context) {
    final List<String> tabTitle = [
      Utils.translatedText(context, 'Gig Service'),
      Utils.translatedText(context, 'About Me'),
      Utils.translatedText(context, 'Reviews'),
      Utils.translatedText(context, 'Education'),
      Utils.translatedText(context, 'Languages'),
      Utils.translatedText(context, 'Skills'),
    ];
    return ExpandablePageView.builder(
      itemCount: detailScreen.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: Utils.symmetric(h: 16.0),
              padding: Utils.symmetric(h: 4.0),
              decoration:  BoxDecoration(
                  borderRadius: Utils.borderRadius(r:22.0),
                  color: whiteColor
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    tabTitle.length,
                        (index) {
                      final active = _currentIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _currentIndex = index),
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.0),
                              color:active ? primaryColor : Colors.transparent
                          ),
                          duration: const Duration(seconds: 0),
                          padding: Utils.symmetric(v: 10.0,h: 0.0),
                          margin: Utils.only(left: index == 2 ? 0.0 : 10.0, bottom: 10.0, top: 10.0),
                          child: Padding(
                            padding: Utils.symmetric(h: 20.0),
                            child: CustomText(
                              text: tabTitle[index],
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color:active ? whiteColor : blackColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Utils.verticalSpace(10.0),
            Padding(
              padding: Utils.symmetric(h: _currentIndex != 0? 20.0:0).copyWith(bottom: Utils.mediaQuery(context).height * 0.05),
              child: detailScreen[_currentIndex],
            ),
          ],
        );
      },
    );
  }
}


