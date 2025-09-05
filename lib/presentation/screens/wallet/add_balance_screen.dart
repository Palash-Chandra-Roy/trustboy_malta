
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/data/data_provider/remote_url.dart';

import '../../../data/dummy_data/dummy_data.dart';
import '../../../data/models/wallet/wallet_transaction_model.dart';
import '../../../logic/cubit/wallet/wallet_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/card_top_part.dart';
import '../../widgets/common_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/primary_button.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {

  late WalletCubit walletCubit;
  DummyPackage ? _method;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    walletCubit = context.read<WalletCubit>();
    // Future.microtask(()=>withdrawCubit.getAllMethodList());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Add Balance')),
      body: ListView(
        children: [
          CardTopPart(title: 'Payment Information',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0),),
          BlocBuilder<WalletCubit, WalletTransaction>(
            builder: (context, state) {

              final amount = int.tryParse(state.createdAt ?? '');
              final type = state.paymentGateway;

              return CommonContainer(
                child: Column(
                  children: [

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Amount'),
                      bottomSpace: 20.0,
                      child: TextFormField(
                        initialValue: state.createdAt,
                        onChanged: walletCubit.addAmount,
                        decoration:  InputDecoration(
                            hintText: Utils.translatedText(context, 'Minimum 10 USD'),
                            border:  outlineBorder(),
                            enabledBorder: outlineBorder(),
                            focusedBorder: outlineBorder()
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: Utils.inputFormatter,
                      ),
                    ),

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Payment Gateway '),
                      bottomSpace: 20.0,
                      isRequired: true,
                      child: DropdownButtonFormField<DummyPackage>(
                        hint:  CustomText(text:Utils.translatedText(context, 'Select')),
                        isDense: true,
                        isExpanded: true,
                        value: _method,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        decoration: InputDecoration(
                            isDense: true,
                            border:  outlineBorder(),
                            enabledBorder: outlineBorder(),
                            focusedBorder: outlineBorder()
                        ),
                        borderRadius: Utils.borderRadius(r: 5.0),
                        dropdownColor: whiteColor,

                        onChanged: (value) {
                          if (value == null) return;
                          walletCubit.addGateway(value.value);
                        },
                        items: walletCubit.methods?.isNotEmpty??false?walletCubit.methods?.map<DropdownMenuItem<DummyPackage>>(
                              (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                                value: value,
                                child: CustomText(text: Utils.translatedText(context, value.title),fontWeight: FontWeight.w500,fontSize: 15.0),
                          ),
                        ).toList():[],
                      ),
                    ),
                    PrimaryButton(
                        text: Utils.translatedText(context, 'Pay Now'),
                        bgColor: walletCubit.isValidInfo() ? primaryColor:grayColor.withValues(alpha: 0.2),
                        onPressed: () {
                          Utils.closeKeyBoard(context);
                          if(walletCubit.isValidInfo()){
                            if((amount??0) >=10){
                              walletCubit.clearPayInfo();

                              if(type == 'stripe'){
                                Navigator.pushNamed(context,RouteNames.walletStripePaymentScreen);
                              }else if(type == 'bank'){
                                Navigator.pushNamed(context,RouteNames.walletBankPaymentScreen);
                              }else if(type == 'paypal'){
                                Navigator.pushNamed(context,RouteNames.paypalScreen,arguments: walletCubit.getWebUri(WalletPaymentType.paypal));
                              }else if(type == 'mollie'){
                                Navigator.pushNamed(context,RouteNames.molliePaymentScreen,arguments: walletCubit.getWebUri(WalletPaymentType.molli));
                              }else if(type == 'razorpay'){
                                Navigator.pushNamed(context,RouteNames.razorpayScreen,arguments: walletCubit.getWebUri(WalletPaymentType.razorpay));
                              }else if(type == 'flutterwave'){
                                Navigator.pushNamed(context,RouteNames.flutterWaveScreen,arguments: walletCubit.getWebUri(WalletPaymentType.flutterWave));
                              }else if(type == 'paysrack'){
                                Navigator.pushNamed(context,RouteNames.paystackPaymentScreen,arguments: walletCubit.getWebUri(WalletPaymentType.payStack));
                              }else if(type == 'instamojo'){
                                Navigator.pushNamed(context,RouteNames.instamojoPaymentScreen,arguments: walletCubit.getWebUri(WalletPaymentType.instamojo));
                              }

                            }else{
                              Utils.errorSnackBar(context, Utils.translatedText(context, 'You have to add minimum 10 USD'));
                            }
                          }
                          // withdrawCubit.createWithdrawMethod();
                        }),


                    // BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                    //   builder: (context, state) {
                    //     if(state.methods != null){
                    //       return Container(
                    //         margin: Utils.only(bottom: 20.0),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(color: stockColor),
                    //           borderRadius: Utils.borderRadius(r: 6.0),
                    //         ),
                    //         child: Container(
                    //           margin: Utils.all(value: 6.0),
                    //           decoration: BoxDecoration(
                    //             color: cardTopColor,
                    //             borderRadius: Utils.borderRadius(r: 6.0),
                    //           ),
                    //           padding: Utils.all(value: 10.0),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               CustomText(
                    //                 text: '${Utils.translatedText(context, 'Withdraw Limit')} : ${Utils.formatAmount(context, state.methods?.minAmount??0.0)} - ${Utils.formatAmount(context, state.methods?.maxAmount??0.0)}',
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16.0,
                    //               ),
                    //               Utils.verticalSpace(6.0),
                    //               CustomText(
                    //                 text: '${Utils.translatedText(context, 'Withdraw charge')} : ${state.methods?.withdrawCharge??0.0}%',
                    //                 fontWeight: FontWeight.w600,
                    //                 fontSize: 16.0,
                    //               ),
                    //               Utils.verticalSpace(6.0),
                    //               HtmlWidget(state.methods?.description??'',textStyle: const TextStyle(color: blackColor,fontWeight: FontWeight.w500)),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }else{
                    //       return const SizedBox.shrink();
                    //     }
                    //
                    //   },
                    // ),
                    //


                    // CustomFormWidget(
                    //   label: Utils.translatedText(context, 'Bank/Account Information'),
                    //   bottomSpace: 20.0,
                    //   child:  BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                    //     builder: (context, state) {
                    //       final post = state.withdrawState;
                    //       return Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           TextFormField(
                    //             initialValue: state.accountInfo,
                    //             onChanged: withdrawCubit.changeBankInfo,
                    //             decoration:  InputDecoration(
                    //                 hintText: Utils.translatedText(context, 'Bank/Account Information',true),
                    //                 border:  outlineBorder(10.0),
                    //                 enabledBorder: outlineBorder(10.0),
                    //                 focusedBorder: outlineBorder(10.0)
                    //             ),
                    //             keyboardType: TextInputType.multiline,
                    //             maxLines: 3,
                    //             // inputFormatters: Utils.inputFormatter,
                    //           ),
                    //           if (post is CreateWithdrawFormError) ...[
                    //             if (state.withdrawAmount.isNotEmpty)
                    //               if (post.errors.accountInfo.isNotEmpty)
                    //                 ErrorText(text: post.errors.accountInfo.first),
                    //           ]
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),
                    //
                    // BlocConsumer<WithdrawCubit, WithdrawStateModel>(
                    //   listener: (context, state) {
                    //     final s = state.withdrawState;
                    //     if (s is CreateWithdrawError) {
                    //       if(s.statusCode == 401){
                    //         Utils.logoutFunction(context);
                    //       }
                    //       Utils.errorSnackBar(context, s.message);
                    //     } else if (s is CreateWithdrawLoaded) {
                    //       Utils.showSnackBar(context, s.message, whiteColor, 2000);
                    //       Future.delayed(const Duration(milliseconds: 1000),(){
                    //         context.read<DashBoardCubit>().getDashBoard();
                    //         Navigator.of(context).pop();
                    //       });
                    //     }
                    //   },
                    //   builder: (context, state) {
                    //     final s = state.withdrawState;
                    //     if (s is CreateWithdrawLoading) {
                    //       return const LoadingWidget();
                    //     }
                    //     return PrimaryButton(
                    //         text: Utils.translatedText(context, 'Send Withdraw Request'),
                    //         onPressed: () {
                    //           Utils.closeKeyBoard(context);
                    //           withdrawCubit.createWithdrawMethod();
                    //         });
                    //   },
                    // ),

                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

