import 'package:flutter/material.dart';
import '../utils/constraints.dart';
import '../utils/k_images.dart';
import '../utils/utils.dart';

import 'custom_image.dart';
import 'custom_text.dart';
import 'primary_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
     this.message,
    this.cancelText,
    this.confirmText ,
    this.confirmHeading,
     this.icon,
     this.bgColor,
     this.image,
    required this.onTap,
  });

  final String? confirmHeading;
  final String? message;
  final String? cancelText;
  final String? confirmText;
  final String? icon;
  final Color? bgColor;
  final Widget? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: Utils.symmetric(h: 14.0, v: 36.0),
      shape: RoundedRectangleBorder(
        borderRadius: Utils.borderRadius(r: 12.0),
      ),
      child: Padding(
        padding: Utils.symmetric(v: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Utils.vSize(100.0),
              width: Utils.hSize(100.0),
              padding: Utils.all(value: 10.0),
              margin: Utils.only(bottom: 16.0),
              decoration:  BoxDecoration(
                color: bgColor??transparent,
                shape: BoxShape.circle,
              ),
              child: image?? CustomImage(path: icon??KImages.logout, color: redColor),
            ),
            CustomText(
              text: Utils.translatedText(context, confirmHeading?? 'Exit'),
              textAlign: TextAlign.center,
              height: 1.4,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: Utils.translatedText(context, message?? 'Are you sure you want to exit from app?'),
              textAlign: TextAlign.center,
              height: 1.4,
            ),
            Utils.verticalSpace(20.0),
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Cancel action
                      child: CustomText(
                        text: Utils.translatedText(context, cancelText??'Cancel'),
                        color: redColor,
                        decorationColor: redColor,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                        maxLine: 1,
                      ),
                    ),
                  ),
                  Utils.horizontalSpace(20.0),
                  Expanded(
                    flex: 3,
                    child: PrimaryButton(
                      bgColor: redColor,
                      text: Utils.translatedText(context, confirmText??'Yes, Exit'),
                      onPressed: onTap,
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      //   Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false);
                      // },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Padding buildPadding(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(h: 14.0, v: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFD7E14).withOpacity(0.2),
            ),
            child: Container(
              padding: Utils.all(value:24.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: dialogCircleGradient,
              ),
              child: CustomImage(path: icon),
            ),
          ),
          // Utils.verticalSpace(20.0),
          CustomText(
            text: message,
            // text: 'Do you want to Delete\nYour Account?',
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: blackColor,
            textAlign: TextAlign.center,
          ),
          Utils.verticalSpace(30.0),
          Row(
            children: [
              Expanded(
                  child: PrimaryButton(
                onPressed: () => Navigator.of(context).pop(),
                text: cancelText,
                borderRadiusSize: 4.0,
                bgColor: backgroundColor,
                textColor: whiteColor,
              )),
              Utils.horizontalSpace(20.0),
              Expanded(
                  child: PrimaryButton(
                onPressed: onTap,
                text: confirmText,
                bgColor: redColor,
                textColor: whiteColor,
                borderRadiusSize: 4.0,
                // fontWeight: FontWeight.w600,
              )),
            ],
          ),
        ],
      ),
    );
  }*/
}
