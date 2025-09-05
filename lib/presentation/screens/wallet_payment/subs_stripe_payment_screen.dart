import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/subscription/sub_detail_model.dart';
import '../../../logic/cubit/subscription/subscription_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/common_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class SubsStripePaymentScreen extends StatefulWidget {
  const SubsStripePaymentScreen({super.key});

  @override
  State<SubsStripePaymentScreen> createState() => _SubsStripePaymentScreenState();
}

class _SubsStripePaymentScreenState extends State<SubsStripePaymentScreen> {

  late SubscriptionCubit jobCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    jobCubit = context.read<SubscriptionCubit>();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Pay via Stripe')),
      body: Utils.logout(
        child: CommonContainer(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(text: Utils.translatedText(context, 'Pay via Stripe'),fontWeight: FontWeight.w600,color: blackColor),
                const Divider(color: stockColor),
                Utils.verticalSpace(10.0),

                CustomFormWidget(
                  label: Utils.translatedText(context, 'Card Number'),
                  bottomSpace: 20.0,
                  child: BlocBuilder<SubscriptionCubit, SubDetailModel>(
                    builder: (context, state) {
                      final post = state.subState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.paymentStatus,
                            onChanged: jobCubit.cardNumber,
                            decoration:  InputDecoration(
                                hintText: Utils.translatedText(context, 'Card Number',true),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder()
                            ),
                            keyboardType: TextInputType.text,

                          ),
                          // if (post is StripePaymentFormError) ...[
                          //   if (post.errors.cardNumber.isNotEmpty)
                          //     ErrorText(text: post.errors.cardNumber.first),
                          // ],

                        ],
                      );
                    },
                  ),
                ),

                CustomFormWidget(
                  label: Utils.translatedText(context, 'Expired Month'),
                  bottomSpace: 20.0,
                  isRequired: true,
                  child:  BlocBuilder<SubscriptionCubit, SubDetailModel>(
                    builder: (context, state) {
                      final post = state.subState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.transaction,
                            onChanged: jobCubit.month,
                            decoration:  InputDecoration(
                                hintText: Utils.translatedText(context, 'Expired Month',true),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder()
                            ),
                            keyboardType: TextInputType.text,
                            // inputFormatters: Utils.inputFormatter,
                          ),
                          // if (post is StripePaymentFormError) ...[
                          //   if (state.isDefault.isNotEmpty)
                          //     if (post.errors.month.isNotEmpty)
                          //       ErrorText(text: post.errors.month.first),
                          // ]
                        ],
                      );
                    },
                  ),
                ),

                CustomFormWidget(
                  label: Utils.translatedText(context, 'Expired Year'),
                  bottomSpace: 20.0,
                  isRequired: true,
                  child:    BlocBuilder<SubscriptionCubit, SubDetailModel>(
                    builder: (context, state) {
                      final post = state.subState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.status,
                            onChanged: jobCubit.addYear,
                            decoration:  InputDecoration(
                                hintText: Utils.translatedText(context, 'Expired Year',true),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder()
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          // if (post is StripePaymentFormError) ...[
                          //   if (state.currencyPosition.isNotEmpty)
                          //     if (post.errors.year.isNotEmpty)
                          //       ErrorText(text: post.errors.year.first),
                          // ]
                        ],
                      );
                    },
                  ),
                ),
                CustomFormWidget(
                  label: Utils.translatedText(context, 'CVC'),
                  bottomSpace: 20.0,
                  isRequired: true,
                  child:    BlocBuilder<SubscriptionCubit, SubDetailModel>(
                    builder: (context, state) {
                      //final post = state.walletState;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: state.updatedAt,
                            onChanged: jobCubit.cvc,
                            decoration:  InputDecoration(
                                hintText: Utils.translatedText(context, 'CVC',true),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder()
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          // if (post is StripePaymentFormError) ...[
                          //   if (state.createdAt.isNotEmpty)
                          //     if (post.errors.cvc.isNotEmpty)
                          //       ErrorText(text: post.errors.cvc.first),
                          // ]
                        ],
                      );
                    },
                  ),
                ),
                BlocConsumer<SubscriptionCubit, SubDetailModel>(
                  listener: (context, state) {
                    final s = state.subState;
                    if (s is StripePaymentError) {
                      if(s.statusCode == 401){
                        Utils.logoutFunction(context);
                      }
                      Utils.errorSnackBar(context, s.message);
                    } else if (s is StripePaymentLoaded) {

                      // jobCubit.getBuyerWallet();

                     Utils.showSnackBar(context, s.message??'', whiteColor, 2000);

                     // Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 1000),(){
                        goToNext();
                      });
                    }
                  },
                  builder: (context, state) {
                    final s = state.subState;
                    if (s is StripePaymentLoading) {
                      return const LoadingWidget();
                    }
                    return PrimaryButton(
                        text: Utils.translatedText(context, 'Pay Now'),
                        onPressed: () {
                          Utils.closeKeyBoard(context);
                         jobCubit.localSubsPayment(SubsType.stripe);
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
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.subsHistoryScreen,
            (route) {
          if (route.settings.name == RouteNames.mainScreen) {
            return true;
          } else {
            return false;
          }
        });
  }
}
