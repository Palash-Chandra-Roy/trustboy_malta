import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/dashboard/dashboard_model.dart';
import '../../../../logic/cubit/dashboard/dashboard_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/fetch_error_text.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/page_refresh.dart';
import '../../buyer_screen/dashboard/seller_dashboard_screen.dart';
import '../order/components/user_order_card.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {

  late DashBoardCubit serviceCubit;
  //final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<DashBoardCubit>();

    Future.microtask(()=>serviceCubit.getDashBoard());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Dashboard')),
      body: PageRefresh(
        onRefresh: () async {
          serviceCubit.getDashBoard();
          debugPrint('called');
        },
        child: Utils.logout(
          child: BlocConsumer<DashBoardCubit, DashBoardState>(
            listener: (context, service) {
              final state = service;
              if (state is DashBoardStateError) {
                if (state.status == 503 || serviceCubit.providerDashboard == null) {
                  serviceCubit.getDashBoard();
                }
                if (state.status == 401) {
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, service) {
              final state = service;
              if (state is DashBoardStateLoading) {
                return const LoadingWidget();
              } else if (state is DashBoardStateError) {
                if (state.status == 503 || serviceCubit.providerDashboard != null) {
                  return DashboardLoadedView(dashboard: serviceCubit.providerDashboard);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is DashBoardStateLoaded) {
                return DashboardLoadedView(dashboard: state.providerDashBoard);
              }
              if (serviceCubit.providerDashboard != null) {
                return DashboardLoadedView(dashboard: serviceCubit.providerDashboard);
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

class DashboardLoadedView extends StatelessWidget {
  const DashboardLoadedView({super.key, required this.dashboard});
  final DashboardModel? dashboard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Utils.verticalSpace(10.0),
          Wrap(
            runSpacing: Utils.vSize(10.0),
            spacing: Utils.vSize(10.0),
            alignment: WrapAlignment.spaceEvenly,
            children: [
              DashboardCard(icon:KImages.activeOrder,count: dashboard?.activeOrders.toString()??'0', title:'Active Order'),
              DashboardCard(icon:KImages.completeOrder,count: dashboard?.completeOrders.toString()??'0',title: 'Complete Order'),
              DashboardCard(icon:KImages.cancelOrder,count: dashboard?.cancelOrders.toString()??'0', title:'Cancel Order'),
              DashboardCard(icon:KImages.rejectOrder,count: dashboard?.rejectedOrders.toString()??'0', title:'Rejected Order'),
            ],
          ),

          Utils.verticalSpace(20.0),
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
                if((dashboard?.orders?.length ?? 0) > 4)...[
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
          if(dashboard?.orders?.isNotEmpty??false)...[
            ...List.generate(((dashboard?.orders?.length??0) > 4?4:(dashboard?.orders?.length??0)), (index){
              final item = dashboard?.orders?[index];
              return Padding(
                padding: Utils.symmetric(h: 20.0, v: 6.0),
                child: UserOrderCard(item: item),
              );
            })
          ],
          Utils.verticalSpace(Utils.mediaQuery(context).height * 0.2),
          // Utils.verticalSpace(20.0),
        ],
      ),
    );
  }
}
