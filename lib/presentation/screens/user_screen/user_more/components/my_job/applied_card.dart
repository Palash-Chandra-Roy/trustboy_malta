import 'package:flutter/material.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';

import '../../../../../utils/constraints.dart';
import '../../../../../utils/k_images.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_text.dart';

class AppliedCard extends StatelessWidget {
  const AppliedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.all(value: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: const CustomImage(path: KImages.defaultImg)),
                ),
                Utils.horizontalSpace(10.0),
                Column(
                  children: [
                    const CustomText(
                      text: "Nankathan",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFEDEBE7)),
                      child: Padding(
                        padding: Utils.symmetric(v: 4.0, h: 8.0),
                        child:
                            const Center(child: CustomText(text: "Complete")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFEDEBE7)),
                child: Padding(
                  padding: Utils.all(value: 6.0),
                  child: const Icon(Icons.more_vert),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
