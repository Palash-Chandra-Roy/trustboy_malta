
import 'package:flutter/material.dart';

import '../../../data/models/subscription/sub_detail_model.dart';
import '../../screens/user_screen/user_more/components/withdraw/withdraw_screen.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_text.dart';

class PurchaseComponent extends StatelessWidget {
  const PurchaseComponent(
      {super.key, required this.singleOrder, this.isUnderline = true});

  final SubDetailModel? singleOrder;
  final bool isUnderline;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //_showDetails(context, singleOrder);
      },
      child: Container(
        width: Utils.mediaQuery(context).width,
        //height: 200.0.h,
        padding: Utils.symmetric(h: 16.0,v: 10.0),
        margin: Utils.symmetric(h: 14.0,v: 6.0),
        decoration: BoxDecoration(color: whiteColor, borderRadius: Utils.borderRadius(r: 4.0)),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomText(
                    text: singleOrder?.planName??'',
                    fontSize: 18.0,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    maxLine: 2,
                  ),
                ),
                Utils.horizontalSpace(20.0),
                CustomText(
                  text: Utils.formatAmount(context, singleOrder?.planPrice),
                  fontSize: 15.0,
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                ),
                /*Row(
                  children: [
                    CustomText(
                      text: Utils.formatPrice(context, singleOrder.planPrice),
                      fontSize: 15.0,
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                    Utils.horizontalSpace(20.0),
                    GestureDetector(
                      onTap: () => _showDetails(context, singleOrder),
                      child: Chip(
                        label: const Icon(Icons.visibility, color: whiteColor),
                        backgroundColor: blackColor,
                        padding: Utils.all(),
                        labelPadding: Utils.symmetric(h: 10.0, v: 5.0),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: transparent),
                          borderRadius: Utils.borderRadius(r: 6.0),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
            Utils.verticalSpace(10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatus(),

                  CustomText(
                    text: convertData(singleOrder?.expirationDate),
                    // text: Utils.timeWithData(singleOrder?.expirationDate,false),
                    // text: '${singleOrder?.status[0].toUpperCase()}' '${singleOrder?.status.substring(1).toLowerCase()}',
                    fontSize: 14.0,
                    color: blackColor,
                    fontWeight: FontWeight.w600,
                    maxLine: 1,
                  ),
                GestureDetector(
                  onTap: ()=>detail(context, singleOrder),
                  child: Container(
                    height: 40.0,width: 40.0,
                    decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: Utils.borderRadius(r: 4.0),
                    ),
                    child: Icon(Icons.visibility,color: whiteColor,),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return Chip(
      label: CustomText(
        text: '${singleOrder?.status[0].toUpperCase()??''}${singleOrder?.status.substring(1).toLowerCase()}',
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: singleOrder?.status == 'active' ? greenColor : redColor,
      ),
      backgroundColor: singleOrder?.status == 'active' ? greenColor.withValues(alpha:0.15) : redColor.withValues(alpha:0.1),
      padding: Utils.all(),
      labelPadding: Utils.symmetric(h: 12.0, v: 0.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: transparent),
        borderRadius: Utils.borderRadius(r: 100.0),
      ),
    );
  }
  // Widget _buildPaymentStatus() {
  //   return Chip(
  //     label: CustomText(
  //       text: singleOrder.paymentStatus[0].toUpperCase() +
  //           singleOrder.paymentStatus.substring(1).toLowerCase(),
  //       fontSize: 14.0,
  //       color: singleOrder.paymentStatus == 'success' ? greenColor : redColor,
  //     ),
  //     backgroundColor: singleOrder.paymentStatus == 'success'
  //         ? greenColor.withOpacity(0.1)
  //         : redColor.withOpacity(0.1),
  //     padding: Utils.all(),
  //     labelPadding: Utils.symmetric(h: 12.0, v: 0.0),
  //     shape: RoundedRectangleBorder(
  //       side: const BorderSide(color: transparent),
  //       borderRadius: Utils.borderRadius(r: 4.0),
  //     ),
  //   );
  // }
  //
  // void _showDetails(BuildContext context, SubscriptionPlan method) {
  //   final exp = singleOrder.expiration[0].toUpperCase() +
  //       singleOrder.expiration.substring(1).toLowerCase();
  //   Utils.showCustomDialog(
  //     context,
  //     padding: Utils.symmetric(h: 16.0),
  //     child: Padding(
  //       padding: Utils.symmetric(v: 20.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               // const Spacer(),
  //               const CustomText(
  //                 text: 'Purchase Details',
  //                 fontSize: 22.0,
  //                 fontWeight: FontWeight.w700,
  //                 color: blackColor,
  //               ),
  //               const Spacer(),
  //               GestureDetector(
  //                 onTap: ()=>Navigator.of(context).pop(),
  //                 child: const Icon(Icons.clear, color: redColor)),
  //             ],
  //           ),
  //           Utils.verticalSpace(10.0),
  //           _info('Plan', method.planName),
  //           _info('Expiration', exp),
  //           _info('Expire Date', method.expirationDate),
  //           _info('Remaining Day', remainingDays(method.expirationDate)),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const CustomText(text: 'Status', fontWeight: FontWeight.w500, color: blackColor),
  //               _buildStatus(),
  //             ],
  //           ),
  //           DottedLine(dashColor: grayColor.withOpacity(0.3)),
  //
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const CustomText(text: 'Payment Status', fontWeight: FontWeight.w500, color: blackColor),
  //               _buildPaymentStatus(),
  //             ],
  //           ),
  //           DottedLine(dashColor: grayColor.withOpacity(0.3)),
  //           Utils.verticalSpace(6.0),
  //           _info('Payment Method', method.paymentMethod),
  //           _info('Transaction', method.transaction,false),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _info(String key, String value,
  //     [bool dotted = true, Color color = blackColor]) {
  //   return Padding(
  //     padding: Utils.symmetric(h: 0.0, v: 6.0),
  //     child: Column(
  //       //mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             CustomText(text: key, fontWeight: FontWeight.w500, color: blackColor),
  //             Flexible(child: CustomText(text: value, fontWeight: FontWeight.w500, color: color,maxLine: 2,)),
  //           ],
  //         ),
  //         Utils.verticalSpace(dotted ? 10.0 : 0.0),
  //         dotted
  //             ? DottedLine(dashColor: grayColor.withOpacity(0.3))
  //             : const SizedBox(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDot() {
  //   return Padding(
  //     padding: Utils.symmetric(h: 8.0),
  //     child: const CustomText(
  //         text: '\u2022', fontSize: 14.0, color: backgroundColor),
  //   );
  // }

  String convertData(String? input) {
    if (input == null || input.trim().isEmpty) return '';

    try {
      final parsedDate = DateTime.tryParse(input);
      if (parsedDate != null) {
        return Utils.formatDate(parsedDate.toIso8601String());
      }
      return input;
    } catch (e, stack) {
      debugPrint('convertData error: $e\n$stack');
      return input ?? '';
    }
  }


  String remainingDays(String date) {
    if (date.contains('/') || date.contains('-') || date.contains(':')) {
      final rd = Utils.getRemainingDays(date);
      return '$rd Days';
    } else {
      return date[0].toUpperCase()+date.substring(1).toLowerCase();
    }
  }

  detail(BuildContext context,SubDetailModel ? item){
    Utils.showCustomDialog(
      bgColor: whiteColor,
      context,
      padding: Utils.symmetric(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: Utils.symmetric(v: 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Spacer(),
                  CustomText(
                    text: Utils.translatedText(context, 'Plan Details'),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.clear, color: redColor)),
                ],
              ),
              const Divider(color: stockColor),
              Utils.verticalSpace(14.0),
              Container(
                padding: Utils.all(value: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: stockColor),
                  borderRadius: Utils.borderRadius(),
                ),
                child: Column(
                  children: [
                    WithdrawKeyValue(title: 'Plan Name',value: item?.planName??''),
                    WithdrawKeyValue(title: 'Plan Price',value: Utils.formatAmount(context, item?.planPrice??0.0)),
                    WithdrawKeyValue(title: 'Maximum Listing',value: item?.maxListing.toString()??''),
                    WithdrawKeyValue(title: 'Featured Listing',value: item?.featuredListing.toString()??''),
                    WithdrawKeyValue(title: 'Recommended Seller',value: Utils.translatedText(context, item?.recommendedSeller == 'active'? 'Available':'Not-Available')),
                    WithdrawKeyValue(title: 'Expiration',value: item?.expiration??''),
                    WithdrawKeyValue(title: 'Expiration Date',value: item?.expirationDate??''),
                    WithdrawKeyValue(title: 'Remaining day',value: remainingDays(item?.expirationDate??'')),
                    WithdrawKeyValue(title: 'Plan Status',value: Utils.capitalizeFirstLetter(item?.status??'')),
                    WithdrawKeyValue(title: 'Payment Status',value: Utils.capitalizeFirstLetter(item?.paymentStatus??'')),
                    WithdrawKeyValue(title: 'Payment Method',value: item?.paymentMethod??''),
                    WithdrawKeyValue(title: 'Transaction',value: item?.transaction??'',showDivider: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
