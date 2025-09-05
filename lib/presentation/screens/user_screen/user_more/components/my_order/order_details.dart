import 'package:flutter/material.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';
import 'package:work_zone/presentation/widgets/custom_text.dart';
import 'package:work_zone/presentation/widgets/primary_button.dart';

import '../../../../../utils/k_images.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_image.dart';



class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Order Detailsssssss"),
      body: Padding(
        padding: Utils.symmetric(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: const Color(0xFF22BE0D).withOpacity(0.3),
                      ),
                      child: const Center(
                          child: CustomText(
                        text: "Order Information",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                    Padding(
                      padding: Utils.symmetric(v: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Basic Information",
                            fontSize: 16,
                          ),
                          Utils.verticalSpace(10.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(10.0),
                          const SummaryWidget(
                            title: "Order ID:",
                            value: "#6546856485",
                          ),
                          const SummaryWidget(
                            title: "Create at:",
                            value: "06/06/2024",
                          ),
                          const SummaryWidget(
                            title: "Delivery Date:",
                            value: "08/06/2024",
                          ),
                          const SummaryWidget(
                            title: "Revision:",
                            value: "03",
                          ),
                          Utils.verticalSpace(10.0),
                          const CustomText(
                            text: "Payment Information",
                            fontSize: 16,
                          ),
                          Utils.verticalSpace(10.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(10.0),
                          const SummaryWidget(
                            title: "Payment Status:",
                            value: "Success",
                          ),
                          const SummaryWidget(
                            title: "Payment Gateway:",
                            value: "Paypal",
                          ),
                          SummaryWidget(
                            title: "Total:",
                            value: Utils.formatAmount(context, "30.00"),
                          ),
                          const SummaryWidget(
                            title: "Transaction:",
                            value: "Asdgnhdcnb",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Utils.verticalSpace(12.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: const Color(0xFF22BE0D).withOpacity(0.3),
                      ),
                      child: const Center(
                          child: CustomText(
                        text: "Service & Package Information",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                    Padding(
                      padding: Utils.symmetric(v: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Service & Package",
                            fontSize: 16,
                          ),
                          Utils.verticalSpace(10.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(10.0),
                          const SummaryWidget(
                            title: "Service:",
                            value: "Video Editor for Creative Projects",
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(text: "Package:"),
                              ...List.generate(3, (index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const CustomText(
                                        text: "Functional website"),
                                    Utils.horizontalSpace(8.0),
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.3)),
                                      child: const Icon(
                                        Icons.done,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                          Utils.verticalSpace(10.0),
                          PrimaryButton(
                              minimumSize: const Size(double.infinity, 42.0),
                              text: 'Download File',
                              onPressed: () {}),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Utils.verticalSpace(10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: const Color(0xFF22BE0D).withOpacity(0.3),
                      ),
                      child: const Center(
                          child: CustomText(
                        text: "Freelancer Info",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                    Padding(
                      padding: Utils.symmetric(v: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 78,
                                width: 78,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: secondaryColor),
                                child:  const CustomImage(path: KImages.jobLogo),
                              ),
                              Utils.horizontalSpace(6.0),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "David Richard",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomText(
                                      text: "(Freelancer)",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      maxLine: 2,
                                    ),
                                    CustomText(
                                      text: "Dhaka, Bangladesh",
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
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CustomImage(path: KImages.member),
                                  Utils.horizontalSpace(6.0),
                                  const CustomText(
                                    text: "Member Since",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              const CustomText(text: "Jan 10, 2024"),
                            ],
                          ),
                          Utils.verticalSpace(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CustomImage(path: KImages.star),
                                  Utils.horizontalSpace(6.0),
                                  const CustomText(
                                    text: "Review",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              const CustomText(text: "12"),
                            ],
                          ),
                          Utils.verticalSpace(10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CustomImage(path: KImages.begIcon),
                                  Utils.horizontalSpace(6.0),
                                  const CustomText(
                                    text: "Total Job",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                              const CustomText(text: "20"),
                            ],
                          ),
                          Utils.verticalSpace(10.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Utils.verticalSpace(20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 14,
        ),
        CustomText(
          text: value,
          fontSize: 14,
          maxLine: 2,
        ),
      ],
    );
  }
}
