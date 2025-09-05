import 'package:flutter/material.dart';
import '../../../../../data/models/order/order_detail_model.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/card_top_part.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/horizontal_line.dart';
import '../components/order_summary_widget.dart';

class OrderBasicInfoView extends StatelessWidget {
  const OrderBasicInfoView({super.key, required this.orders});
  final OrderDetail? orders;
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CardTopPart(title: 'Order Information',bgColor: primaryColor.withOpacity(0.3)),

          Padding(
            padding: Utils.symmetric(v: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Basic Information",
                  fontSize: 16,
                ),
                HorizontalLine(color: gray5B,margin: Utils.symmetric(h: 0.0,v: 10.0)),
                OrderSummaryWidget(
                  title: "Order ID",
                  value: "#${orders?.order?.orderId}",
                ),
                OrderSummaryWidget(
                  title: "Create At",
                  value: Utils.timeWithData(orders?.order?.createdAt??'',false),
                ),
                OrderSummaryWidget(
                  title: "Delivery Date",
                  value: Utils.timeWithData(orders?.order?.updatedAt ??'',false),
                ),
                OrderSummaryWidget(
                  title: "Revision",
                  value: orders?.order?.revision.toString()??'0',
                ),
                Utils.verticalSpace(10.0),
                CustomText(
                  text: Utils.translatedText(context, 'Payment Information'),
                  fontSize: 16.0,
                ),
                HorizontalLine(color: gray5B,margin: Utils.symmetric(h: 0.0,v: 10.0)),
                OrderSummaryWidget(
                  title: "Order Status",
                  value: Utils.orderStatusText(context, orders?.order),
                  isText: false,
                  child: Container(
                    padding: Utils.symmetric(h: 8.0,v: 6.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Utils.orderStatusBg(context,orders?.order)),
                    child: CustomText(text: Utils.orderStatusText(context,orders?.order),color: blackColor,fontWeight: FontWeight.w500,),
                  ),
                ),
                OrderSummaryWidget(
                  title: "Payment Status",
                  value: Utils.capitalizeFirstLetter(orders?.order?.paymentStatus??''),
                  textColor: orders?.order?.paymentStatus == 'success'?greenColor:redColor,
                ),
                OrderSummaryWidget(
                  title: "Payment Gateway",
                  value: orders?.order?.paymentMethod??'',
                ),
                OrderSummaryWidget(
                  title: "Total",
                  value: Utils.formatAmount(context, orders?.order?.packageAmount??0.0,2),
                ),
                OrderSummaryWidget(
                  title: "Transaction",
                  value: orders?.order?.transactionId??'',
                  maxLine: 4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
