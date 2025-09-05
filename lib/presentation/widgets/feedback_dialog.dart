import 'package:flutter/material.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_image.dart';
import 'custom_text.dart';

class FeedBackDialog extends StatelessWidget {
  const FeedBackDialog({
    super.key,
    required this.image,
    required this.message,
    required this.child,
    this.height = 226.0,
    this.radius = 10.0,
  });
  final String image;
  final String message;
  final Widget child;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4.0,
      insetPadding: Utils.all(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: SizedBox(
        width: Utils.hSize(340.0),
        height: Utils.vSize(height),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -70.0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFD7E14).withOpacity(0.2),
                ),
                child: Container(
                  // height: 90.0.h,
                  // width: 90.0.w,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: dialogCircleGradient,
                  ),
                  child: CustomImage(path: image, height: 41.0, width: 46.0),
                ),
              ),
            ),
            Positioned.fill(
              top: 55.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Utils.verticalSpace(16),
                    CustomText(
                      text: message,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                      textAlign: TextAlign.center,
                      color: const Color(0xFF162B49),
                    ),
                    Utils.verticalSpace(10),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
