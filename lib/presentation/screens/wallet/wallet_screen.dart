
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/widgets/primary_button.dart';

import '../../../data/models/wallet/wallet_model.dart';
import '../../../data/models/wallet/wallet_transaction_model.dart';
import '../../../logic/cubit/wallet/wallet_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../buyer_screen/dashboard/seller_dashboard_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  late WalletCubit walletCubit;
  //final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    walletCubit = context.read<WalletCubit>();

    Future.microtask(()=>walletCubit.getBuyerWallet());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Wallet')),
      body: PageRefresh(
        onRefresh: () async {
          walletCubit.getBuyerWallet();
        },
        child: Utils.logout(
          child: BlocConsumer<WalletCubit, WalletTransaction>(
            listener: (context, service) {
              final state = service.walletState;
              if (state is WalletError) {
                if (state.status == 503 || walletCubit.wallet == null) {
                  walletCubit.getBuyerWallet();
                }
                if (state.status == 401) {
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, service) {
              final state = service.walletState;
                if (state is WalletLoading) {
                  return const LoadingWidget();
                } else if (state is WalletError) {
                  if (state.status == 503 || walletCubit.wallet != null) {
                    return LoadedWalletView(wallet: walletCubit.wallet);
                  } else {
                    return FetchErrorText(text: state.message);
                  }
                } else if (state is WalletLoaded) {
                  return LoadedWalletView(wallet: state.wallets);
                }
                if (walletCubit.wallet != null) {
                  return LoadedWalletView(wallet: walletCubit.wallet);
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

class LoadedWalletView extends StatelessWidget {
  const LoadedWalletView({super.key, required this.wallet});
  final WalletModel? wallet;

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
        padding: Utils.symmetric(),
        child: Column(
          children: [
            Utils.verticalSpace(16.0),
            PrimaryButton(text: Utils.translatedText(context, 'Add Balance'),
                onPressed: (){
                  context.read<WalletCubit>().clearField();
                  Navigator.pushNamed(context,RouteNames.addBalanceScreen);
                },),
            Utils.verticalSpace(16.0),
            Wrap(
              runSpacing: Utils.vSize(10.0),
              spacing: Utils.vSize(10.0),
              alignment: WrapAlignment.spaceEvenly,
              children: [
                DashboardCard(icon:KImages.activeOrder,count: wallet?.currentBalance.toString()??'0', title:'Current Balance',isPrice: true),
                DashboardCard(icon:KImages.completeOrder,count: wallet?.orderByWallet.toString()??'0',title: 'Used Balance',isPrice: true),
                DashboardCard(icon:KImages.cancelOrder,count: wallet?.myWallet?.balance.toString()??'0', title:'Total Balance',isPrice: true),
                SizedBox(width: Utils.hSize(162.0)),
              ],
            ),

            Utils.verticalSpace(20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: Utils.translatedText(context, 'Wallet Transaction'),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                // if((wallet?.walletTransaction?.length ?? 0) > 5)...[
                //   GestureDetector(
                //     //onTap: ()=>Navigator.pushNamed(context,RouteNames.buyerSellerOrderScreen),
                //     child: CustomText(
                //       text: Utils.translatedText(context, 'See all'),
                //       fontSize: 14.0,
                //     ),
                //   ),
                // ],
              ],
            ),
            Utils.verticalSpace(20.0),
            if(wallet?.walletTransaction?.isNotEmpty??false)...[
              ...List.generate(wallet?.walletTransaction?.length??0, (index){
              // ...List.generate(((wallet?.walletTransaction?.length??0) > 5?5:(wallet?.walletTransaction?.length??0)), (index){
                final item = wallet?.walletTransaction?[index];
                return Container(
                  width: Utils.mediaQuery(context).width,
                  margin: Utils.symmetric(h: 0.0,v: 5.0),
                  padding: Utils.symmetric(h: 10.0,v: 10.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: Utils.borderRadius(r: 4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: Utils.formatAmount(context, item?.amount??0.0),color: blackColor,fontWeight: FontWeight.w500,),
                          CustomText(text: Utils.timeWithData(item?.createdAt??'',false),color: gray5B),
                        ],
                      ),
                      CustomText(text: item?.paymentGateway??'',color: gray5B,fontSize: 12.0,),
                    ],
                  ),
                );
              })
            ],
            Utils.verticalSpace(20.0),
          ],
        ),
      ),
    );
  }
}

