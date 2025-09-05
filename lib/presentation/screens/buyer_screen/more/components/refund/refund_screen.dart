import 'package:flutter/material.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/utils/language_string.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';
import 'package:work_zone/presentation/widgets/custom_text.dart';
import 'package:work_zone/presentation/widgets/primary_button.dart';

import '../../../../../utils/utils.dart';
import '../../../../user_screen/order/components/order_summary_widget.dart';

class RefundScreen extends StatelessWidget {
  const RefundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Refund"),
      body: Padding(
        padding: Utils.symmetric(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ...List.generate(5, (index) {
                return Padding(
                  padding: Utils.only(bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: whiteColor),
                    child: Padding(
                      padding: Utils.symmetric(v: 10.0),
                      child: Column(
                        children: [
                          const OrderSummaryWidget(
                            title: 'Order ID:',
                            value: "#0563465",
                          ),
                          Utils.verticalSpace(8.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(8.0),
                           OrderSummaryWidget(
                            title: 'Amount:',
                            value: Utils.formatAmount(context, 25),
                          ),
                          Utils.verticalSpace(8.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(8.0),
                          const OrderSummaryWidget(
                            title: 'Date:',
                            value: "15 Jul 2024",
                          ),
                          Utils.verticalSpace(8.0),
                          Container(
                            height: 0.5,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          Utils.verticalSpace(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(text: "Status"),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey.withOpacity(0.3)),
                                child: Padding(
                                  padding: Utils.symmetric(h: 8.0, v: 4.0),
                                  child: const CustomText(text: "Pending"),
                                ),
                              ),
                            ],
                          ),
                          Utils.verticalSpace(12.0),
                          PrimaryButton(
                              minimumSize: const Size(double.infinity, 42),
                              text: Utils.translatedText(
                                  context, Language.viewDetails),
                              onPressed: () {
                                showDialog(context: context, builder: (index){
                                  return  Dialog(
                                    backgroundColor: whiteColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: borderColor
                                          ),
                                          color: whiteColor
                                        ),
                                        child: Padding(
                                          padding: Utils.symmetric(v: 10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CustomText(text: "Refund Details",fontSize: 18,fontWeight: FontWeight.w600,),
                                              Utils.verticalSpace(8.0),
                                              Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              ),
                                              Utils.verticalSpace(8.0),
                                              const OrderSummaryWidget(
                                                title: 'Order ID:',
                                                value: "#0563465",
                                              ),
                                              Utils.verticalSpace(8.0),
                                              Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              ),
                                              Utils.verticalSpace(8.0),
                                              OrderSummaryWidget(
                                                title: 'Amount:',
                                                value: Utils.formatAmount(context, 25),
                                              ),
                                              Utils.verticalSpace(8.0),
                                              Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              ),
                                              Utils.verticalSpace(8.0),
                                              const OrderSummaryWidget(
                                                title: 'Date:',
                                                value: "15 Jul 2024",
                                              ),
                                              Utils.verticalSpace(8.0),
                                              Container(
                                                height: 0.5,
                                                width: double.infinity,
                                                color: Colors.grey,
                                              ),
                                              Utils.verticalSpace(8.0),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const CustomText(text: "Status"),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                        color: Colors.grey.withOpacity(0.3)),
                                                    child: Padding(
                                                      padding: Utils.symmetric(h: 8.0, v: 4.0),
                                                      child: const CustomText(text: "Pending"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Utils.verticalSpace(12.0),
                                                Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const CustomText(text: "Reason:"),
                                                  Utils.horizontalSpace(6.0),
                                                  const Expanded(
                                                    child: CustomText(text: "Hello admin, I'm going to request for refund. this seller not buyer friendly. I have declined the order. Thanks",
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
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
