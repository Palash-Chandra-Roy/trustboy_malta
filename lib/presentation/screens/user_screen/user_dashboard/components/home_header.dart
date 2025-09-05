import 'package:flutter/material.dart';

import '../../../../utils/constraints.dart';
import '../../../../utils/k_images.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/custom_text.dart';

class UserHomeHeader extends StatelessWidget {
  const UserHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: Utils.vSize(size.height * 0.20),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            decoration: const BoxDecoration(
              color: Color(0xFF13544E),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: Utils.only(top: 10.0),
              child: Row(

                children: [
                  Expanded(
                    child: Row(
                      children: [
                        //Utils.horizontalSpace(10),
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, RouteNames.editProfile),
                          },
                          child: Container(
                            height: Utils.vSize(52.0),
                            width: Utils.vSize(52.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child:  const CustomImage(
                                path: KImages.profileImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Utils.horizontalSpace(10.0),
                          const Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Good Morning',
                                color: Color(0xFFEBF4FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              CustomText(
                                text: 'Jenny Wilson',
                                color: whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        Utils.horizontalSpace(10),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: whiteColor, width: 1.5),
                          shape: BoxShape.circle,
                        ),
                        child:  const Center(
                            child: CustomImage(
                          path: KImages.notification,
                          height: 25,
                        )),
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
