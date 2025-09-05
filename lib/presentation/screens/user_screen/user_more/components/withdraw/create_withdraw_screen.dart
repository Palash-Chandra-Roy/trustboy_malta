import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '/data/models/withdraw/method_model.dart';
import '/logic/cubit/dashboard/dashboard_cubit.dart';
import '../../../../../../logic/cubit/withdraw/withdraw_cubit.dart';
import '../../../../../../logic/cubit/withdraw/withdraw_state_model.dart';
import '../../../../../utils/constraints.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/card_top_part.dart';
import '../../../../../widgets/common_container.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_form.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/error_text.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/primary_button.dart';
import 'withdraw_screen.dart';


class NewWithdrawScreen extends StatefulWidget {
  const NewWithdrawScreen({super.key});

  @override
  State<NewWithdrawScreen> createState() => _NewWithdrawScreenState();
}

class _NewWithdrawScreenState extends State<NewWithdrawScreen> {

  late WithdrawCubit withdrawCubit;
  MethodModel ? _method;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    withdrawCubit = context.read<WithdrawCubit>();
    Future.microtask(()=>withdrawCubit.getAllMethodList());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'New Withdraw')),
      body: Utils.logout(
        child: ListView(
          children: [
            CardTopPart(title: 'Withdraw Information',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0),),
            CommonContainer(
              child: Column(
                children: [

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Withdraw Method'),
                    bottomSpace: 20.0,
                    isRequired: true,
                    child: BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                      builder: (context, state) {
                        final post = state.withdrawState;
                        if (state.methodId.isNotEmpty && withdrawCubit.methods.isNotEmpty) {
                          _method = withdrawCubit.methods.where((e)=>e.id.toString() == state.methodId)
                              .first;
                        } else {
                          _method =  null;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<MethodModel>(
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
                                withdrawCubit..changeMethodId(value.id.toString())..addMethod(value);
                              },
                              items: withdrawCubit.methods.isNotEmpty?withdrawCubit.methods.map<DropdownMenuItem<MethodModel>>(
                                    (MethodModel value) => DropdownMenuItem<MethodModel>(
                                  value: value,
                                  child: CustomText(text: value.name),
                                ),
                              ).toList():[],
                            ),
                            if (post is CreateWithdrawFormError) ...[
                              if (post.errors.methodId.isNotEmpty)
                                ErrorText(text: post.errors.methodId.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),


                  BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                    builder: (context, state) {
                    if(state.methods != null){
                      return Container(
                        margin: Utils.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: stockColor),
                          borderRadius: Utils.borderRadius(r: 6.0),
                        ),
                        child: Container(
                          margin: Utils.all(value: 6.0),
                          decoration: BoxDecoration(
                            color: cardTopColor,
                            borderRadius: Utils.borderRadius(r: 6.0),
                          ),
                          padding: Utils.all(value: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: '${Utils.translatedText(context, 'Withdraw Limit')} : ${Utils.formatAmount(context, state.methods?.minAmount??0.0)} - ${Utils.formatAmount(context, state.methods?.maxAmount??0.0)}',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                              Utils.verticalSpace(6.0),
                              CustomText(
                                text: '${Utils.translatedText(context, 'Withdraw charge')} : ${state.methods?.withdrawCharge??0.0}%',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                              Utils.verticalSpace(6.0),
                              HtmlWidget(state.methods?.description??'',textStyle: const TextStyle(color: blackColor,fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    }else{
                      return const SizedBox.shrink();
                      }

                    },
                  ),

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Amount'),
                    bottomSpace: 20.0,
                    child: BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                      builder: (context, state) {
                        final post = state.withdrawState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.withdrawAmount,
                              onChanged: withdrawCubit.changeAmount,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Amount',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: Utils.inputFormatter,
                            ),
                            if (post is CreateWithdrawFormError) ...[
                              if (state.methodId.isNotEmpty)
                                if (post.errors.withdrawAmount.isNotEmpty)
                                  ErrorText(text: post.errors.withdrawAmount.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Bank/Account Information'),
                    bottomSpace: 20.0,
                    child:  BlocBuilder<WithdrawCubit, WithdrawStateModel>(
                      builder: (context, state) {
                        final post = state.withdrawState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.accountInfo,
                              onChanged: withdrawCubit.changeBankInfo,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Bank/Account Information',true),
                                  border:  outlineBorder(10.0),
                                  enabledBorder: outlineBorder(10.0),
                                  focusedBorder: outlineBorder(10.0)
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              // inputFormatters: Utils.inputFormatter,
                            ),
                            if (post is CreateWithdrawFormError) ...[
                              if (state.withdrawAmount.isNotEmpty)
                                if (post.errors.accountInfo.isNotEmpty)
                                  ErrorText(text: post.errors.accountInfo.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),

                  BlocConsumer<WithdrawCubit, WithdrawStateModel>(
                    listener: (context, state) {
                      final s = state.withdrawState;
                      if (s is CreateWithdrawError) {
                        if(s.statusCode == 401){
                          Utils.logoutFunction(context);
                        }
                        Utils.errorSnackBar(context, s.message);
                      } else if (s is CreateWithdrawLoaded) {
                        Utils.showSnackBar(context, s.message, whiteColor, 2000);
                        Future.delayed(const Duration(milliseconds: 1000),(){
                          context.read<DashBoardCubit>().getDashBoard();
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    builder: (context, state) {
                      final s = state.withdrawState;
                      if (s is CreateWithdrawLoading) {
                        return const LoadingWidget();
                      }
                      return PrimaryButton(
                          text: Utils.translatedText(context, 'Send Withdraw Request'),
                          onPressed: () {
                            Utils.closeKeyBoard(context);
                            withdrawCubit.createWithdrawMethod();
                          });
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  _detail(BuildContext context,MethodModel ? item){
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
                    text: Utils.translatedText(context, 'Application Details'),
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
                    // WithdrawKeyValue(title: 'Name',value: profile.profile?.name??''),
                    // WithdrawKeyValue(title: 'Phone',value: profile.profile?.phone??''),
                    // WithdrawKeyValue(title: 'Email',value:  profile.profile?.email??''),
                    // WithdrawKeyValue(title: 'Address',value: profile.profile?.address??''),
                    WithdrawKeyValue(title: 'Apply Date',value: Utils.timeWithData(item?.createdAt??'',false)),
                    WithdrawKeyValue(title: 'Message',value: item?.description??'' ,showDivider: false,maxLine: 6),
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
