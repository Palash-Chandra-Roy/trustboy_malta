import 'package:flutter/material.dart';


import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_text.dart';

class AddNewButton extends StatelessWidget {
  const AddNewButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: Utils.symmetric(v: 14.0,h: 18.0),
          decoration: BoxDecoration(
            color: primaryColor,
            // border: Border.all(color: stockColor),
            borderRadius: Utils.borderRadius(r: 40.0),
          ),
          child:  CustomText(
            text: Utils.translatedText(context, "Add More"),
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: whiteColor,
            maxLine: 1,
          ),
        ),
      ),
    );
    /*return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.add_box_rounded,
        color: primaryColor,
      ),
      label:  CustomText(
        text: Utils.translatedText(context, "Add More"),
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        decoration: TextDecoration.underline,
      ),
    );*/
  }
}
