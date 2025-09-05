import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/utils/k_images.dart';
import '/presentation/widgets/common_container.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '/presentation/widgets/custom_text.dart';
import '/presentation/widgets/empty_widget.dart';
import '/presentation/widgets/primary_button.dart';
import '../../../../../../data/models/dashboard/dashboard_model.dart';
import '../../../../../../data/models/withdraw/withdraw_model.dart';
import '../../../../../../logic/cubit/withdraw/withdraw_cubit.dart';
import '../../../../../../logic/cubit/withdraw/withdraw_state_model.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/page_refresh.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late WithdrawCubit orderCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    orderCubit = context.read<WithdrawCubit>();
    Future.microtask(()=>orderCubit.getAllWithdrawList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: Utils.translatedText(context, 'My Withdraw')),
      body: PageRefresh(
        onRefresh: () async {
          orderCubit.getAllWithdrawList();
        },
        child: Utils.logout(
          child: BlocConsumer<WithdrawCubit, WithdrawStateModel>(
            listener: (context, service) {
              final state = service.withdrawState;
              if (state is AccountInfoError) {
                if (state.statusCode == 503 || orderCubit.withdraws == null) {
                  orderCubit.getAllWithdrawList();
                }
                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, service) {
              final state = service.withdrawState;
              if (state is AccountInfoLoading) {
                return const LoadingWidget();
              } else if (state is AccountInfoError) {
                if (state.statusCode == 503 || orderCubit.withdraws != null) {
                  return LoadedWithdrawList(withdraw: orderCubit.withdraws);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is AllWithdrawListLoaded) {
                return LoadedWithdrawList(withdraw: state.withdrawList);
              }
              if (orderCubit.withdraws != null) {
                return LoadedWithdrawList(withdraw: orderCubit.withdraws);
              } else {
                return FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(),
    );
  }
}

class LoadedWithdrawList extends StatelessWidget {
  const LoadedWithdrawList({super.key, required this.withdraw});
  final DashboardModel ? withdraw;

  @override
  Widget build(BuildContext context) {
    if(withdraw?.withdraws?.isNotEmpty??false){
      return ListView.builder(
        itemCount: withdraw?.withdraws?.length,
        itemBuilder: (context,index){
          final item = withdraw?.withdraws?[index];
          return CommonContainer(
            onTap: ()=>detail(context,item),
            margin: Utils.symmetric(v: 6.0,h: 16.0),
            child: Column(
              children: [
                //WithdrawKeyValue(title: 'Method Name',value: item?.withdrawMethodName??'',),
                //WithdrawKeyValue(title: 'Total Amount',value: Utils.formatAmount(context, item?.totalAmount??0.0)),
                WithdrawKeyValue(title: 'Withdraw Amount',value: Utils.formatAmount(context, item?.withdrawAmount??0.0)),
                //WithdrawKeyValue(title: 'Withdraw Charge',value: Utils.formatAmount(context, item?.chargeAmount??0.0)),
                WithdrawKeyValue(title: 'Status',value: Utils.capitalizeFirstLetter(item?.status??'')),
                WithdrawKeyValue(title: 'Date',value: Utils.timeWithData(item?.createdAt??'',false),showDivider: false),
                //Utils.verticalSpace(10.0),
                //PrimaryButton(text: Utils.translatedText(context, 'Withdraw Details'), onPressed: ()=>detail(context,item),minimumSize: const Size(double.infinity,40.0),)
              ],
            ),
          );
        },
      );
    }else{
      return EmptyWidget(image: KImages.emptyImage,isSliver: false);
    }
  }
}
detail(BuildContext context,WithdrawModel ? item){
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
                  text: Utils.translatedText(context, 'Withdraw Detail'),
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
                  WithdrawKeyValue(title: 'Method Name',value: item?.withdrawMethodName??'',),
                  WithdrawKeyValue(title: 'Total Amount',value: Utils.formatAmount(context, item?.totalAmount??0.0)),
                  WithdrawKeyValue(title: 'Withdraw Amount',value: Utils.formatAmount(context, item?.withdrawAmount??0.0)),
                  WithdrawKeyValue(title: 'Withdraw Charge',value: Utils.formatAmount(context, item?.chargeAmount??0.0)),
                  WithdrawKeyValue(title: 'Status',value: Utils.capitalizeFirstLetter(item?.status??'')),
                  WithdrawKeyValue(title: 'Date',value: Utils.timeWithData(item?.createdAt??'',false)),
                  WithdrawKeyValue(title: 'Bank/Account Info',value: item?.description??'' ,showDivider: false),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class WithdrawKeyValue extends StatelessWidget {
  const WithdrawKeyValue({
    super.key,
    required this.title,
    required this.value, this.showDivider,this.maxLine
  });

  final String title;
  final String value;
  final bool? showDivider;
  final int ? maxLine;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: Utils.symmetric(h: 0.0,v: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText(
                  text: Utils.translatedText(context, title),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  maxLine: 1,
                ),
              ),
              Flexible(
                child: CustomText(
                  text: value,
                  fontSize: 14.0,
                  maxLine: maxLine?? 2,
                ),
              ),
            ],
          ),
        ),
        if(showDivider??true)...[
          Utils.verticalSpace(6.0),
          const Divider(color: stockColor),
        ],
      ],
    );
  }
}
