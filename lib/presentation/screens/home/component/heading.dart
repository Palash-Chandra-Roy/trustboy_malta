import 'package:flutter/material.dart';

import '../../../widgets/custom_text.dart';
import '/presentation/utils/constraints.dart';
import '/presentation/utils/utils.dart';

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.title1,
    this.title2,
    this.onTap,
    this.seeAllVisible = true,
    this.padding,
    this.child = const SizedBox(),
  });

  final String title1;
  final String? title2;
  final VoidCallback? onTap;
  final bool seeAllVisible;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? Utils.all(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title1,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: blackColor,
          ),
          seeAllVisible
              ? GestureDetector(
                  onTap: onTap,
                  child: CustomText(
                    text: title2 ?? Utils.translatedText(context, 'View More'),
                    fontSize: 16.0,
                    color: primaryColor,
                  ),
                )
              : child,
        ],
      ),
    );
  }
}
