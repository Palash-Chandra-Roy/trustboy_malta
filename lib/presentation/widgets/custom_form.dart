import 'package:flutter/material.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_text.dart';

class CustomForm extends StatelessWidget {
  final String label;
  final String hintText;
  final int? maxLine;
  final double bottomSpace;

  const CustomForm({
    super.key,
    required this.label,
    required this.hintText,

    this.bottomSpace = 0.0,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blackColor,
        ),
        Utils.verticalSpace(10.0),
        TextField(
          maxLength: maxLine,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize:
              16.0,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none, // No border when enabled
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.transparent, // No border when focused
              ),
            ),
          ),
        ),
        Utils.verticalSpace(bottomSpace),
      ],
    );
  }
}

class CustomFormWidget extends StatelessWidget {
  final String label;
  final Widget child;
  final double bottomSpace;
  final Color labelColor;
  final bool? isRequired;

  const CustomFormWidget({
    super.key,
    required this.label,
    required this.child,
    this.bottomSpace = 0.0,
    this.labelColor = blackColor,
    this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: label,
              fontSize: 14.0,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
            if(isRequired??true)...[Utils.horizontalSpace(2.0),
              const CustomText(
                text: '*',
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),]
          ],
        ),
        Utils.verticalSpace(8.0),
        child,
        Utils.verticalSpace(bottomSpace),
      ],
    );
  }
}



