import 'package:flutter/material.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({super.key, required this.title, required this.value,this.maxLine,this.flex,this.textColor,this.onTap,this.child,this.isText});

  final String title;
  final String value;
  final int ?maxLine;
  final int ? flex;
  final Color ? textColor;
  final VoidCallback ? onTap;
  final Widget ? child;
  final bool ? isText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(h:0.0,v: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomText(
              text: '${Utils.translatedText(context, title)}:',
              fontSize: 14.0,
              maxLine: 1,
            ),
          ),
          Utils.horizontalSpace(20.0),
          if(isText??true)...[
            Flexible(
              flex: flex ?? 1,
              child: GestureDetector(
                onTap: onTap,
                child: CustomText(
                  text: value,
                  fontSize: 14.0,
                  color: textColor ?? blackColor,
                  maxLine: maxLine??1,
                ),
              ),
            ),
          ]else...[
            child??const SizedBox.shrink(),
          ],
        ],
      ),
    );
  }
}