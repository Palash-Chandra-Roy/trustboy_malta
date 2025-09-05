import 'package:flutter/material.dart';

import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class JoinSellerBanner extends StatelessWidget {
  const JoinSellerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(v: 26.0),
      child: Stack(
        children: [
          const CustomImage(path: KImages.joinSellerB),
          Positioned(
            bottom: 20.0,
            left: 30.0,
            child: GestureDetector(
              onTap: () =>Navigator.pushNamed(context, RouteNames.signUpScreen),
              child: Container(
                // height: 30.0,
                // width: 120,
                padding: Utils.symmetric(v: 6.0),
                decoration: BoxDecoration(
                  borderRadius: Utils.borderRadius(r: 20.0),
                  color: primaryColor,
                ),
                child:  CustomText(
                  text: Utils.translatedText(context, 'Join Seller'),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
