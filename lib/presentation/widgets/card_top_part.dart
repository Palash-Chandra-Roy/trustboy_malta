import 'package:flutter/material.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_text.dart';

class CardTopPart extends StatelessWidget {
  const CardTopPart({super.key, required this.title,  this.bgColor,this.padding,this.margin});
  final String title;
  final Color? bgColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? Utils.symmetric(v: 14.0),
      margin: margin ?? Utils.all(),
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: bgColor?? stockColor,
      ),
      child:  Center(
          child: CustomText(
            text: Utils.translatedText(context, title),
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: blackColor,
          )),
    );
  }
}
