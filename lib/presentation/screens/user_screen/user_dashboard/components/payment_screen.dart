import 'package:flutter/material.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '/presentation/widgets/custom_form.dart';
import '../../../../utils/utils.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Payment "),
      body: Padding(
        padding: Utils.symmetric(v: 0.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Padding(
                  padding: Utils.symmetric(v: 10.0),
                  child: Column(
                    children: [
                      const CustomForm(
                        label: "Amount",
                        hintText: "Amount here",
                      ),
                      Utils.verticalSpace(10.0),
                      const CustomForm(
                        label: "Payment Gateway",
                        hintText: "Amount here",
                      ),
                      Utils.verticalSpace(10.0),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
