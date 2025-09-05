import 'package:flutter/material.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({super.key, required this.child, this.radius,this.margin,this.padding,this.onTap});
  final Widget child;
  final BorderRadius ? radius;
  final EdgeInsets ? margin;
  final EdgeInsets ? padding;
  final VoidCallback ? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap??(){},
      child: Container(
        width: Utils.mediaQuery(context).width,
        padding: padding?? Utils.symmetric(v: 12.0),
        margin: margin??Utils.symmetric(h: 16.0),
        decoration: BoxDecoration(
          borderRadius: radius?? Utils.borderRadius(r: 4.0),
          color: whiteColor,
        ),
        child: child,
      ),
    );
  }
}
