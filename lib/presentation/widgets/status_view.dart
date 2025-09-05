import 'package:flutter/material.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_text.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.status,
    this.radius,
    this.padding,
    this.bgColor,
    this.statusColor,
  });

  final String status;
  final BorderRadius? radius;
  final EdgeInsets? padding;
  final Color? bgColor;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius ?? Utils.borderRadius(r: 30.0),
        color: bgColor ?? stockColor,
      ),
      child: Padding(
        padding: padding ?? Utils.symmetric(h: 10.0, v: 4.0),
        child: CustomText(
          text: Utils.translatedText(context, status),
          color: statusColor ?? blackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
