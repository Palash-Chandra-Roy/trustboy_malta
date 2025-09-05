import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/order/order_item_model.dart';
import '../../../../data/models/order/order_model.dart';
import '../../../../data/models/refund/refund_item.dart';
import '../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/fetch_error_text.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/page_refresh.dart';
import '../../../widgets/please_signin_widget.dart';
import 'components/empty_order.dart';
import 'components/user_order_card.dart';

class BuyerSellerOrderScreen extends StatefulWidget {
  const BuyerSellerOrderScreen({super.key, required this.isPayment});
  final String isPayment;

  @override
  State<BuyerSellerOrderScreen> createState() => _BuyerSellerOrderScreenState();
}

class _BuyerSellerOrderScreenState extends State<BuyerSellerOrderScreen> {

  late BuyerOrderCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<BuyerOrderCubit>();
    termCubit.isPayment(widget.isPayment);

    Future.microtask(()=>termCubit.getBuyerOrder());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageRefresh(
        onRefresh: () async {
          termCubit.getBuyerOrder();
        },
        child: Utils.logout(
          child: BlocConsumer<BuyerOrderCubit, RefundItem>(
            listener: (context, service) {
              final state = service.orderState;
              if (state is BuyerOrderError) {
                if (state.statusCode == 503 || termCubit.orders == null) {
                  termCubit.getBuyerOrder();
                }

                if(state.statusCode == 401 && state.message.isNotEmpty){
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, service) {
              final state = service.orderState;
              if (state is BuyerOrderLoading) {
                return const LoadingWidget();
              } else if (state is BuyerOrderError) {
                if (state.statusCode == 503 || termCubit.orders != null) {
                  return OrderLoadedView(orders: termCubit.orders);
                } else if(state.statusCode == 401) {
                  return const PleaseLoginFirst();
                }else{
                  return FetchErrorText(text: state.message);
                }
              } else if (state is BuyerOrderLoaded) {
                return OrderLoadedView(orders: state.orders);
              }
              if (termCubit.orders != null) {
                return OrderLoadedView(orders: termCubit.orders);
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

class OrderLoadedView extends StatefulWidget {
  const OrderLoadedView({super.key, required this.orders});
  final OrderModel? orders;

  @override
  State<OrderLoadedView> createState() => _OrderLoadedViewState();
}

class _OrderLoadedViewState extends State<OrderLoadedView> {
  late List<List<OrderItem>?> filteredList;
  late BuyerOrderCubit jCubit ;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init(){
    jCubit = context.read<BuyerOrderCubit>();
    if(Utils.isLoggedIn(context)){
      filteredList = [
        widget.orders?.orders,
        widget.orders?.activeOrders,
        widget.orders?.awaitingOrders,
        widget.orders?.rejectedOrders,
        widget.orders?.cancelOrders,
        widget.orders?.completedOrders,
      ];
    }else{
      filteredList = [];
    }

  }

  @override
  void dispose() {
   jCubit.addTabIndex(0);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 40,
            offset: Offset(0, 2),
            spreadRadius: 10,
          )
        ],
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            leading:  jCubit.state.isPayment.isNotEmpty? const BackButtonWidget():null,
            surfaceTintColor: scaffoldBgColor,
            backgroundColor: scaffoldBgColor,
            toolbarHeight: Utils.vSize(80.0),
            centerTitle: true,
            title:  CustomText(
              text: Utils.translatedText(context, Language.myOrder),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: blackColor,
            ),
            bottom: const OrderTabContent(),
          ),

          if (filteredList[jCubit.state.buyerId]?.isNotEmpty??false) ...[

            SliverList.list(
              children: List.generate(
                  filteredList[jCubit.state.buyerId]?.length??0,(index) {
                final item = filteredList[jCubit.state.buyerId]?[index];
                  return Padding(
                    padding: Utils.symmetric(h: 20.0, v: 6.0),
                    child: UserOrderCard(item: item),
                  );
                },
              ),
            ),
            
          ] else ...[
            const EmptyOrder(),
          ],
          SliverToBoxAdapter(child: Utils.verticalSpace(Utils.mediaQuery(context).height * 0.06)),

        ],
      ),
    );
  }
}

class OrderTabContent extends StatefulWidget implements PreferredSizeWidget {
  const OrderTabContent({super.key});

  @override
  State<OrderTabContent> createState() => _OrderTabContentState();

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(40.0));
}

class _OrderTabContentState extends State<OrderTabContent> {

  @override
  Widget build(BuildContext context) {
    final jCubit = context.read<BuyerOrderCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: BlocBuilder<BuyerOrderCubit, RefundItem>(
        builder: (context, state) {
          List<String> orderTabItems = [
            '${Utils.translatedText(context, 'All')}(${jCubit.orders?.orders?.length??0})',
            '${Utils.translatedText(context, 'Active')}(${jCubit.orders?.activeOrders?.length??0})',
            '${Utils.translatedText(context, 'Awaiting')}${jCubit.orders?.awaitingOrders?.length??0})',
            '${Utils.translatedText(context, 'Rejected')}(${jCubit.orders?.rejectedOrders?.length??0})',
            '${Utils.translatedText(context, 'Cancel')}(${jCubit.orders?.cancelOrders?.length??0})',
            '${Utils.translatedText(context, 'Complete')}(${jCubit.orders?.completedOrders?.length??0})',
          ];
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: Utils.hPadding()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  orderTabItems.length,
                      (index) {
                        final active = jCubit.state.buyerId == index;
                    // final active = _currentIndex == index;
                    return GestureDetector(
                      onTap: () => jCubit.addTabIndex(index),
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 0),
                        decoration: BoxDecoration(
                          border: active?null: Border.all(color: primaryColor),
                          color: active ? primaryColor : Colors.transparent,
                          borderRadius: Utils.borderRadius(r: 25.0),
                        ),
                        padding: Utils.symmetric(v: 8.0, h: 24.0),
                        margin: Utils.only(
                            left: index == 0 ? 0.0 : 18.0, bottom: 10.0, top: 14.0),
                        child: CustomText(
                          text: orderTabItems[index],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: active?whiteColor: blackColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
        },
),
    );
  }
}