import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/wallet/wallet_transaction_model.dart';
import '../../../logic/cubit/wallet/wallet_cubit.dart';
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

class WalletBankPaymentScreen extends StatefulWidget {
  const WalletBankPaymentScreen({super.key});

  @override
  State<WalletBankPaymentScreen> createState() => _WalletBankPaymentScreenState();
}

class _WalletBankPaymentScreenState extends State<WalletBankPaymentScreen> {


  late WalletCubit jobCubit;


  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    jobCubit = context.read<WalletCubit>();
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
                CustomText(text: jobCubit.wallet?.setting?.bankAccountInfo??'',fontWeight: FontWeight.w500,height: 1.6,),
                Utils.verticalSpace(20.0),
                CustomFormWidget(
                  label: Utils.translatedText(context, 'Transaction information'),
                  bottomSpace: 20.0,
                  isRequired: true,
                  child:    BlocBuilder<WalletCubit, WalletTransaction>(
                    builder: (context, state) {
                      final post = state.walletState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.paymentStatus,
                            onChanged: jobCubit.tnxInfo,
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
                BlocConsumer<WalletCubit, WalletTransaction>(
                  listener: (context, state) {
                    final s = state.walletState;
                    if (s is StripePaymentError) {
                      if(s.statusCode == 401){
                        Utils.logoutFunction(context);
                      }
                      Utils.errorSnackBar(context, s.message);
                    } else if (s is StripePaymentLoaded) {

                      jobCubit.getBuyerWallet();

                      Utils.showSnackBar(context, s.message??'', whiteColor, 2000);

                      Future.delayed(const Duration(milliseconds: 1000),(){
                        goToNext();
                      });
                    }
                  },
                  builder: (context, state) {
                    final s = state.walletState;
                    if (s is StripePaymentLoading) {
                      return const LoadingWidget();
                    }
                    return PrimaryButton(
                        text: Utils.translatedText(context, 'Pay Now'),
                        onPressed: () {
                          Utils.closeKeyBoard(context);
                          jobCubit.localWalletPayment(WalletPaymentType.bank);
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
  goToNext(){
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.walletScreen,
            (route) {
          if (route.settings.name == RouteNames.mainScreen) {
            return true;
          } else {
            return false;
          }
        });
  }
}
