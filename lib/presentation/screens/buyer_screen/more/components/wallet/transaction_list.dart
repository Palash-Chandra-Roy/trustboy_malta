import 'package:flutter/material.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';

import '../../../../../utils/utils.dart';
import '../../../../user_screen/order/components/order_summary_widget.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Transaction Lits"),
      body: Padding(
        padding: Utils.symmetric(),
        child: Column(
          children: [
            ...List.generate(3, (index) {
              return const TransactionCard();
            })
          ],
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Utils.only(bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.symmetric(v: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OrderSummaryWidget(
              title: 'Transaction ID:',
              value: "#0563465",
            ),
            Utils.verticalSpace(8.0),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5),
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
              color: Colors.grey.withOpacity(0.5),
            ),
            Utils.verticalSpace(8.0),
            const OrderSummaryWidget(
              title: 'Gateway:',
              value: "Paypal",
            ),
            Utils.verticalSpace(8.0),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.5),
            ),
            Utils.verticalSpace(8.0),
            const OrderSummaryWidget(
              title: 'Date:',
              value: "15 Jul 2024",
            ),
          ],
        ),
      ),
    );
  }
}
