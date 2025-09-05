import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/order/order_item_model.dart';
import '../../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/horizontal_line.dart';

class UserOrderCard extends StatelessWidget {
  const UserOrderCard({super.key, required this.item});

  final OrderItem? item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //if(Utils.isSeller(context)){
        // context.read<BuyerOrderCubit>().addId(int.parse(item?.orderId??'0'));
        // }else{
        context.read<BuyerOrderCubit>().addId(item?.id ?? 0);
        // }

        Navigator.pushNamed(context, RouteNames.buyerSellerOrderDetailsScreen);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: whiteColor),
        child: Padding(
          padding: Utils.all(value: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "#${item?.orderId}",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomText(
                    text: Utils.formatAmount(context, item?.totalAmount ?? 0.0),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ],
              ),
              Utils.verticalSpace(6.0),
              CustomText(
                text: item?.listing?.title ?? '',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              Utils.verticalSpace(8.0),
              CustomText(
                text: item?.listing?.category?.name ?? '',
                fontSize: 12.0,
                color: primaryColor,
              ),
              HorizontalLine(
                  color: borderColor, margin: Utils.symmetric(h: 0.0, v: 12.0)),

              SizedBox(
                width: Utils.mediaQuery(context).width,
                child: Row(
                  children: [
                    SizedBox(
                      width: Utils.mediaQuery(context).width * 0.3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: Utils.translatedText(context, 'Delivery Date'),
                            fontSize: 12,
                          ),
                          Utils.verticalSpace(6.0),
                          CustomText(
                            text: Utils.timeWithData(item?.createdAt ?? '', false),
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    if(Utils.orderStatusText(context, item).length > 12)...[
                      const Spacer(flex: 1),
                    ]else...[
                      const Spacer(flex: 3),
                    ],

                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center, // Align everything to the right
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Push "Status" to the right
                            children: [
                              Flexible(
                                child: CustomText(
                                  text: Utils.translatedText(context, 'Status'),
                                  fontSize: 12.0,
                                  maxLine: 1,
                                ),
                              ),
                            ],
                          ),
                          Utils.verticalSpace(6.0),
                          Container(
                            padding: Utils.symmetric(h: 4.0, v: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: Utils.borderRadius(r: 30.0),
                              color: Utils.orderStatusBg(context, item),
                            ),
                            child: Padding(
                              padding: Utils.symmetric(h: 8.0, v: 0.0),
                              child: CustomText(
                                text: Utils.orderStatusText(context, item),
                                color: Utils.orderStatusTextColor(context, item),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )


             /* PrimaryButton(
                  text: Utils.translatedText(context, 'Order Details'),
                  minimumSize: const Size(double.infinity, 42.0),
                  onPressed: () {
                    //if(Utils.isSeller(context)){
                    // context.read<BuyerOrderCubit>().addId(int.parse(item?.orderId??'0'));
                    // }else{
                    context.read<BuyerOrderCubit>().addId(item?.id??0);
                    // }

                    Navigator.pushNamed(context, RouteNames.buyerSellerOrderDetailsScreen);
                  })*/
            ],
          ),
        ),
      ),
    );
  }
}
