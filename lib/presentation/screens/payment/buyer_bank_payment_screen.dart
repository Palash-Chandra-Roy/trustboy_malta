import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/setting/currencies_model.dart';
import '../../../logic/cubit/payment/payment_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/common_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class BuyerBankPaymentScreen extends StatefulWidget {
  const BuyerBankPaymentScreen({super.key});

  @override
  State<BuyerBankPaymentScreen> createState() => _BuyerBankPaymentScreenState();
}

class _BuyerBankPaymentScreenState extends State<BuyerBankPaymentScreen> {


  late PaymentCubit jobCubit;


  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    jobCubit = context.read<PaymentCubit>();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Pay via Bank')),
      body: Utils.logout(
        child: CommonContainer(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(text: Utils.translatedText(context, 'Pay via Bank'),fontWeight: FontWeight.w600,color: blackColor),
                const Divider(color: stockColor),
                CustomText(text: jobCubit.payment?.setting?.bankAccountInfo??'',fontWeight: FontWeight.w500,height: 1.6,),
                Utils.verticalSpace(20.0),
                CustomFormWidget(
                  label: Utils.translatedText(context, 'Transaction information'),
                  bottomSpace: 20.0,
                  isRequired: true,
                  child:    BlocBuilder<PaymentCubit, CurrenciesModel>(
                    builder: (context, state) {
                      final post = state.paymentState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.updatedAt,
                            onChanged: jobCubit.cvc,
                            decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Transaction information',true),
                              border:  outlineBorder(10.0),
                              enabledBorder: outlineBorder(10.0),
                              focusedBorder: outlineBorder(10.0),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                          ),
                          if (post is StripePaymentFormError) ...[
                            if (post.errors.tnxInfo.isNotEmpty)
                              ErrorText(text: post.errors.tnxInfo.first),
                          ]
                        ],
                      );
                    },
                  ),
                ),
                BlocConsumer<PaymentCubit, CurrenciesModel>(
                  listener: (context, state) {
                    final s = state.paymentState;
                    if (s is BankError) {
                      if(s.statusCode == 401){
                        Utils.logoutFunction(context);
                      }
                      Utils.errorSnackBar(context, s.message);
                    } else if (s is BankLoadedState) {
                      Utils.showSnackBar(context, s.message, whiteColor, 2000);

                      Future.delayed(const Duration(milliseconds: 1000),(){
                        Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerSellerOrderScreen,
                                (route) {
                              if (route.settings.name == RouteNames.mainScreen) {
                                return true;
                              } else {
                                return false;
                              }
                            },arguments: 'success');
                      });

                    }
                  },
                  builder: (context, state) {
                    final s = state.paymentState;
                    if (s is BankLoading) {
                      return const LoadingWidget();
                    }
                    return PrimaryButton(
                        text: Utils.translatedText(context, 'Submit Now'),
                        onPressed: () {
                          Utils.closeKeyBoard(context);
                          jobCubit.bankWalletPayment();
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _bottomButton(),
    );
  }
}
