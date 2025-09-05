import 'package:flutter/material.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';
import 'package:work_zone/presentation/widgets/horizontal_line.dart';

import '../../../../../utils/constraints.dart';
import '../../../../../utils/k_images.dart';
import '../../../../../utils/language_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../order/components/order_summary_widget.dart';

class JobApplicationCard extends StatelessWidget {
  const JobApplicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.all(value: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: secondaryColor),
                  child: const CustomImage(path: KImages.jobLogo),
                ),
                Utils.horizontalSpace(6.0),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: Utils.formatAmount(context, '25.0'),
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFFEDEBE7)),
                            child: Padding(
                              padding: Utils.symmetric(h: 8.0, v: 2.0),
                              child: const CustomText(text: "Hired"),
                            ),
                          ),
                        ],
                      ),
                      const CustomText(
                        text: "Nas Best Digital Agency Website Design",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        maxLine: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Utils.verticalSpace(10.0),
            Container(
              height: 0.5,
              width: double.infinity,
              color: borderColor,
            ),
            Utils.verticalSpace(14.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: Utils.translatedText(context, "Date:"),
                  fontSize: 12,
                ),
                Utils.horizontalSpace(10.0),
                CustomText(
                  text: Utils.translatedText(context, "10-12-2024"),
                  fontSize: 12,
                ),
              ],
            ),
            Utils.verticalSpace(14.0),
            PrimaryButton(
                text: Utils.translatedText(context, Language.viewDetails),
                minimumSize: const Size(double.infinity, 42.0),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (index) {
                        return Dialog(
                          backgroundColor: whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(color: borderColor),
                                  color: whiteColor),
                              child: Padding(
                                padding: Utils.symmetric(v: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CustomText(
                                      text: "Application Details",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Utils.verticalSpace(8.0),
                                    Container(
                                      height: 0.5,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const OrderSummaryWidget(
                                      title: 'Name:',
                                      value: "David Richard",
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(8.0),
                                    const OrderSummaryWidget(
                                      title: 'Phone:',
                                      value: "017589654",
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(8.0),
                                    const OrderSummaryWidget(
                                      title: 'Email:',
                                      value: "david@gmail.com",
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(8.0),
                                    const OrderSummaryWidget(
                                      title: 'Address:',
                                      value: "dhaka, bangladesh",
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(8.0),
                                    const OrderSummaryWidget(
                                      title: 'Apply Date:',
                                      value: "15 jul 2024",
                                    ),
                                    Utils.verticalSpace(8.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(8.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const CustomText(text: "Status"),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                          child: Padding(
                                            padding:
                                                Utils.symmetric(h: 8.0, v: 4.0),
                                            child: const CustomText(
                                                text: "Pending"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Utils.verticalSpace(12.0),
                                    const HorizontalLine(),
                                    Utils.verticalSpace(12.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(text: "Message:"),
                                        Utils.horizontalSpace(6.0),
                                        const Expanded(
                                          child: CustomText(
                                            text:
                                                "Hello admin, I'm going to request for refund. this seller not buyer friendly. I have declined the order. Thanks",
                                            maxLine: 5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Utils.verticalSpace(12.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
