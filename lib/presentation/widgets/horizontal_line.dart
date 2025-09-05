import 'package:flutter/material.dart';

import '../utils/utils.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key,this.color,this.margin});
  final Color? color;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin?? Utils.only(top: 5.0, bottom: 5.0),
      height: 0.2,
      width: double.infinity,
      color: color?? const Color(0xFFEDEBE7),
      // color: gray5B.withOpacity(0.5),
    );
  }

}
