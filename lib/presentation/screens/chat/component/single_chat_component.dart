import 'package:flutter/material.dart';

import '../../../../data/models/chat/message_model.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';

// ignore: must_be_immutable
class SingleChat extends StatelessWidget {
  SingleChat({super.key, required this.m, required this.isSeller});

  final MessageModel m;
  final bool isSeller;
  double radius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSeller ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: Utils.symmetric(h: 12.0, v: 12.0),
            margin: Utils.symmetric(h: 16.0, v: 6.0).copyWith(top: 0.0),
            decoration: BoxDecoration(
              color: isSeller ? secondaryColor : scaffoldBgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
                bottomLeft: Radius.circular(isSeller ? radius : 0.0),
                bottomRight: Radius.circular(isSeller ? 0.0 : radius),
              ),
            ),
            child: CustomText(
              text: m.message,
              color: isSeller ? whiteColor : gray5B,
              fontSize: 14.0,
              maxLine: 20,
            ),
          ),
        ),
      ],
    );
  }
}
