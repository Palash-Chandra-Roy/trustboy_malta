import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/logic/cubit/currency/currency_cubit.dart';
import '/logic/cubit/currency/currency_state_model.dart';

import '../../../../data/models/dashboard/dashboard_model.dart';
import '../../../../logic/cubit/dashboard/dashboard_cubit.dart';
import '../../../../logic/cubit/withdraw/withdraw_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/fetch_error_text.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/page_refresh.dart';
import '../../../widgets/primary_button.dart';
import '../../user_screen/order/components/user_order_card.dart';
import '../../user_screen/user_more/components/withdraw/withdraw_screen.dart';
import 'components/seller_dashboard_header.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {

  late DashBoardCubit serviceCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<DashBoardCubit>();

    //Future.microtask(()=>serviceCubit.getDashBoard());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SellerDashboardHeader(),
      body:PageRefresh(
        onRefresh: () async {
          serviceCubit.getDashBoard();
        },
        child: Utils.logout(
          child: BlocConsumer<DashBoardCubit, DashBoardState>(
            listener: (context, service) {
              final state = service;
              if (state is DashBoardStateError) {
                if (state.status == 503 || serviceCubit.providerDashboard == null) {
                  serviceCubit.getDashBoard();
                }
                if(state.status == 401){
                  Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false);
                }
              }

            },
            builder: (context, service) {
              final state = service;
              if (state is DashBoardStateLoading) {
                return const LoadingWidget();
              } else if (state is DashBoardStateError) {
                if (state.status == 503 || serviceCubit.providerDashboard != null) {
                  return LoadedSellerDashboard(dashboard: serviceCubit.providerDashboard);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is DashBoardStateLoaded) {
                return LoadedSellerDashboard(dashboard: state.providerDashBoard);
              }
              if (serviceCubit.providerDashboard != null) {
                return LoadedSellerDashboard(dashboard: serviceCubit.providerDashboard);
              } else {
                return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadedSellerDashboard extends StatelessWidget {
  const LoadedSellerDashboard({super.key, required this.dashboard});
final DashboardModel? dashboard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0AF7F5F0),
            blurRadius: 40,
            offset: Offset(0, 2),
            spreadRadius: 10,
          )
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: BlocBuilder<CurrencyCubit, CurrencyStateModel>(
          builder: (context, state) {
            return Column(
              children: [
                // const SellerDashboardHeader(),
                // Utils.verticalSpace(20.0),
                Padding(
                  padding: Utils.symmetric(v: 16.0),
                  child: PrimaryButton(
                      text: Utils.translatedText(context, 'New Withdraw'),
                      onPressed: () {
                        context.read<WithdrawCubit>().removeData();
                        Navigator.pushNamed(context, RouteNames.newWithdrawScreen);
                      }),
                ),
                // Utils.verticalSpace(20.0),
                Wrap(
                  runSpacing: Utils.vSize(10.0),
                  spacing: Utils.vSize(10.0),
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    DashboardCard(icon:KImages.activeOrder,count: dashboard?.activeOrders.toString()??'0', title:'Active Order'),
                    DashboardCard(icon:KImages.completeOrder,count: dashboard?.completeOrders.toString()??'0',title: 'Complete Order'),
                    DashboardCard(icon:KImages.cancelOrder,count: dashboard?.cancelOrders.toString()??'0', title:'Cancel Order'),
                    DashboardCard(icon:KImages.rejectOrder,count: dashboard?.rejectedOrders.toString()??'0', title:'Rejected Order'),
                    DashboardCard(icon:KImages.currentBalance,count: dashboard?.totalIncome.toStringAsFixed(2)??'0.0',title: 'Total Earnings',isPrice:true),
                    DashboardCard(icon:KImages.totalBalance,count: dashboard?.totalCommission.toStringAsFixed(2)??'0.0',title: 'Commission Deducted',isPrice:true),
                    DashboardCard(icon:KImages.totalBalance,count: dashboard?.totalIncome.toStringAsFixed(2)??'0.0',title: 'Net Earnings',isPrice:true),DashboardCard(icon:KImages.currentBalance,count: dashboard?.currentBalance.toStringAsFixed(2)??'0.0',title: 'Current Balance',isPrice:true),
                    // DashboardCard(icon:KImages.totalBalance,count: dashboard?.currentBalance.toStringAsFixed(2)??'0.0',title: 'Available Balance',isPrice:true),
                  ],
                ),
                Utils.verticalSpace(20.0),
                if(dashboard?.orders?.isNotEmpty??false)...[
                  Padding(
                    padding: Utils.symmetric(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: Utils.translatedText(context, 'Recent Order'),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        if((dashboard?.orders?.length ?? 0) > 2)...[
                          GestureDetector(
                            onTap: ()=>Navigator.pushNamed(context,RouteNames.buyerSellerOrderScreen,arguments: 'success'),
                            child: CustomText(
                              text: Utils.translatedText(context, 'See all'),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if(dashboard?.orders?.isNotEmpty??false)...[
                  ...List.generate(((dashboard?.orders?.length??0) > 2?2:(dashboard?.orders?.length??0)), (index){
                    final item = dashboard?.orders?[index];
                    return Padding(
                      padding: Utils.symmetric(h: 20.0, v: 6.0),
                      child: UserOrderCard(item: item),
                    );
                  })
                ],
                Utils.verticalSpace(20.0),
                if(dashboard?.withdraws?.isNotEmpty??false)...[
                  Padding(
                    padding: Utils.symmetric(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: Utils.translatedText(context, 'Latest Withdraw'),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        if((dashboard?.withdraws?.length ?? 0) > 2)...[
                          GestureDetector(
                            onTap: ()=>Navigator.pushNamed(context,RouteNames.withdrawScreen),
                            child: CustomText(
                              text: Utils.translatedText(context, 'See all'),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                if(dashboard?.withdraws?.isNotEmpty??false)...[
                  Utils.verticalSpace(14.0),
                  ...List.generate(((dashboard?.withdraws?.length??0) > 2?2:(dashboard?.withdraws?.length??0)), (index){

                    final item = dashboard?.withdraws?[index];
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
                  }),
                  Utils.verticalSpace(14.0),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.icon, required this.count, required this.title, this.isPrice});
  final String icon;
  final String count;
  final String title;
  final bool? isPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utils.vSize(65.0),
      width: Utils.hSize(162.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: Utils.borderRadius(r: 10.0),
      ),
      child: Padding(
        padding: Utils.all(value: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(isPrice??false)...[
                    Flexible(
                      child: CustomText(
                        text: Utils.formatAmount(context, count),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                        maxLine: 1,
                      ),
                    ),
                  ]else...[
                    Flexible(
                      child: CustomText(
                        text: count.padLeft(2, '0'),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                        maxLine: 1,
                      ),
                    ),
                  ],

                  Flexible(
                    child: CustomText(
                      text: Utils.translatedText(context, title),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: blackColor,
                      maxLine: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Utils.vSize(45.0),
              width: Utils.vSize(45.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: secondaryColor),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.5),
                child: CustomImage(
                  path: icon,
                  height: 25.0,
                  width: 25.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
