import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_provider/remote_url.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/subscription/sub_detail_model.dart';
import '../../logic/cubit/subscription/subscription_cubit.dart';
import '../routes/route_names.dart';
import '../screens/buyer_screen/dashboard/components/buyer_payment_screen.dart';
import '../utils/constraints.dart';
import '../utils/utils.dart';
import '../widgets/card_top_part.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/fetch_error_text.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_refresh.dart';
import 'subscription_screen.dart';

class SubscriptionPaymentInfoScreen extends StatefulWidget {
  const SubscriptionPaymentInfoScreen({super.key});

  @override
  State<SubscriptionPaymentInfoScreen> createState() => _SubscriptionPaymentInfoScreenState();
}

class _SubscriptionPaymentInfoScreenState extends State<SubscriptionPaymentInfoScreen> {

  late SubscriptionCubit detailCubit;

  @override
  void initState() {
    detailCubit = context.read<SubscriptionCubit>();
    // detailCubit.isNavigating = false;
    Future.microtask(() => detailCubit.getPaymentInfo());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Payment')),
      body: PageRefresh(
        onRefresh: () async {
          detailCubit.getPaymentInfo();
        },
        child: Utils.logout(
          child: BlocConsumer<SubscriptionCubit, SubDetailModel>(
            listener: (context, states) {
              final state = states.subState;
              if (state is PaymentInfoStateError) {
                if (state.statusCode == 503 || detailCubit.paymentInfo == null) {
                  detailCubit.getPaymentInfo();
                }
                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, states) {
              final state = states.subState;
              if (state is PaymentInfoStateLoading) {
                return const LoadingWidget();
              } else if (state is PaymentInfoStateError) {
                if (state.statusCode == 503 || detailCubit.paymentInfo != null) {
                  return SubPaymentInfoLoaded(model: detailCubit.paymentInfo);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is PaymentInfoStateLoaded) {
                return SubPaymentInfoLoaded(model: state.paymentInfoModel);
              }

              if (detailCubit.paymentInfo != null) {
                return SubPaymentInfoLoaded(model: detailCubit.paymentInfo);
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

class SubPaymentInfoLoaded extends StatelessWidget {
  const SubPaymentInfoLoaded({super.key, required this.model});
  final PaymentModel ? model;

  @override
  Widget build(BuildContext context) {
    final pCubit = context.read<SubscriptionCubit>();
    final List<Widget> paymentItems = [
      if (model?.setting?.stripeStatus == 1)
        paymentItemCard(context, model?.setting?.stripeImage, () {
          pCubit..clearPayInfo()..addPlanName('stripe')..isNavigating = true;
          Navigator.pushNamed(context, RouteNames.buyerStripePaymentScreen).then((_) {
            pCubit.isNavigating = false;
          });
        }),

      if (model?.setting?.paypalStatus == 1)
        paymentItemCard(context, model?.setting?.paypalImage, () {
          Navigator.pushNamed(context, RouteNames.paypalScreen, arguments: pCubit.paymentUrl(SubsType.paypal));
        }),

      if (model?.setting?.razorpayStatus == 1)
        paymentItemCard(context, model?.setting?.razorpayImage, () {
          Navigator.pushNamed(context, RouteNames.razorpayScreen, arguments: pCubit.paymentUrl(SubsType.razorpay));
        }),

      if (model?.setting?.flutterwaveStatus == 1)
        paymentItemCard(context, model?.setting?.flutterwaveLogo, () {
          Navigator.pushNamed(context, RouteNames.flutterWaveScreen, arguments: pCubit.paymentUrl(SubsType.flutterWave));
        }),

      if (model?.setting?.mollieStatus == 1)
        paymentItemCard(context, model?.setting?.mollieImage, () {
          Navigator.pushNamed(context, RouteNames.molliePaymentScreen, arguments: pCubit.paymentUrl(SubsType.molli));
        }),

      if (model?.setting?.paystackStatus == 1)
        paymentItemCard(context, model?.setting?.paystackImage, () {
          Navigator.pushNamed(context, RouteNames.paystackPaymentScreen, arguments: pCubit.paymentUrl(SubsType.payStack));
        }),

      if (model?.setting?.instamojoStatus == 1)
        paymentItemCard(context, model?.setting?.instamojoImage, () {
          Navigator.pushNamed(context, RouteNames.instamojoPaymentScreen, arguments: pCubit.paymentUrl(SubsType.instamojo));
        }),

      if (model?.setting?.bankStatus == 1)
        paymentItemCard(context, model?.setting?.bankImage, () {
          pCubit..clearPayInfo()..addPlanName('bank');
          Navigator.pushNamed(context, RouteNames.buyerBankPaymentScreen).then((_) {
            pCubit.isNavigating = false;
          });
        }),

    ];


    return ListView(
      padding: Utils.symmetric().copyWith(bottom: 30.0),
      children: [

        // const CardTopPart(title: 'Package Information'),
        // PackageCard(package: model?.listingPackage,showButton: false),
        SelectedSubs(subModel: model?.plan),

        CardTopPart(title: 'Payment',margin: Utils.only(top: 30.0)),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            color: whiteColor,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            padding: Utils.symmetric(h: 14.0, v: 12.0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.0,
            ),
            itemBuilder: (context, index) => paymentItems[index],
          ),
        ),
        // Container(
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(10.0),
        //         bottomRight: Radius.circular(10.0)),
        //     color: whiteColor,
        //   ),
        //   child: GridView(
        //     shrinkWrap: true,
        //     padding: Utils.symmetric(h: 14.0,v: 12.0),
        //     physics: const NeverScrollableScrollPhysics(),
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       mainAxisSpacing: 10.0,
        //       crossAxisSpacing: 10.0,
        //       childAspectRatio: 2.0,
        //     ),
        //     children: [
        //       paymentItemCard(context,model?.setting?.stripeStatus == 1, model?.setting?.stripeImage,(){
        //         pCubit..clearPayInfo()..addPlanName('stripe')..isNavigating = true;
        //         // Navigator.pushNamed(context,RouteNames.subsStripePaymentScreen);
        //         Navigator.pushNamed(context,RouteNames.subsStripePaymentScreen).then((_){pCubit.isNavigating = false;});
        //       }),
        //       paymentItemCard(context,model?.setting?.paypalStatus == 1,model?.setting?.paypalImage,(){
        //         // debugPrint('paypal-url ${pCubit.paymentUrl(PaymentType.paypal)}');
        //         Navigator.pushNamed(context,RouteNames.paypalScreen,arguments: pCubit.paymentUrl(SubsType.paypal));
        //       }),
        //       paymentItemCard(context,model?.setting?.razorpayStatus == 1,model?.setting?.razorpayImage,(){
        //         Navigator.pushNamed(context,RouteNames.razorpayScreen,arguments: pCubit.paymentUrl(SubsType.razorpay));
        //       }),
        //       paymentItemCard(context,model?.setting?.flutterwaveStatus == 1,model?.setting?.flutterwaveLogo,(){
        //         Navigator.pushNamed(context,RouteNames.flutterWaveScreen,arguments: pCubit.paymentUrl(SubsType.flutterWave));
        //       }),
        //       paymentItemCard(context,model?.setting?.mollieStatus == 1,model?.setting?.mollieImage,(){
        //         Navigator.pushNamed(context,RouteNames.molliePaymentScreen,arguments: pCubit.paymentUrl(SubsType.molli));
        //       }),
        //       paymentItemCard(context,model?.setting?.paystackStatus == 1,model?.setting?.paystackImage,(){
        //         Navigator.pushNamed(context,RouteNames.paystackPaymentScreen,arguments: pCubit.paymentUrl(SubsType.payStack));
        //       }),
        //       paymentItemCard(context,model?.setting?.instamojoStatus == 1,model?.setting?.instamojoImage,(){
        //         Navigator.pushNamed(context,RouteNames.instamojoPaymentScreen,arguments: pCubit.paymentUrl(SubsType.instamojo));
        //       }),
        //       paymentItemCard(context,model?.setting?.bankStatus == 1,model?.setting?.bankImage,(){
        //         pCubit..clearPayInfo()..addPlanName('bank');
        //         Navigator.pushNamed(context,RouteNames.subsBankPaymentScreen);
        //       }),
        //       // _item(context,true,KImages.walletImage,(){
        //       //   // pCubit.clear();
        //       //   // Navigator.pushNamed(context,RouteNames.buyerBankPaymentScreen);
        //       //   pCubit.bankWalletPayment(false);
        //       // },false),
        //       // _item(context,model?.setting?.w),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
