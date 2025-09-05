import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/k_images.dart';
import '/data/data_provider/remote_url.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/card_top_part.dart';
import '/presentation/widgets/custom_image.dart';
import '../../../../../data/models/payment/payment_model.dart';
import '../../../../../data/models/setting/currencies_model.dart';
import '../../../../../logic/cubit/payment/payment_cubit.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/loading_widget.dart';
import '../../../../widgets/page_refresh.dart';
import '../../../service_screen/component/package_card.dart';

class BuyerPaymentScreen extends StatefulWidget {
  const BuyerPaymentScreen({super.key});

  @override
  State<BuyerPaymentScreen> createState() => _BuyerPaymentScreenState();
}

class _BuyerPaymentScreenState extends State<BuyerPaymentScreen> {
  late PaymentCubit detailCubit;

  @override
  void initState() {
    detailCubit = context.read<PaymentCubit>();
    detailCubit.isNavigating = false;
    Future.microtask(() => detailCubit.getPaymentInfo());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // debugPrint('isNavigating ${detailCubit.isNavigating}');
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Payment')),
      body: PageRefresh(
        onRefresh: () async {
          detailCubit.getPaymentInfo();
        },
        child: Utils.logout(
          child: BlocConsumer<PaymentCubit, CurrenciesModel>(
            listener: (context, states) {
              final state = states.paymentState;
              if (state is PaymentStatePageInfoError) {
                if (state.statusCode == 503 || detailCubit.payment == null) {
                  detailCubit.getPaymentInfo();
                }
                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }

              if(detailCubit.isNavigating){
                return;
              }else{
                if (state is BankLoading){
                  Utils.loadingDialog(context);
                }else{
                  Utils.closeDialog(context);
                  if (state is BankError) {
                    if(state.statusCode == 401){
                      Utils.logoutFunction(context);
                    }
                    Utils.errorSnackBar(context, state.message);
                  } else if (state is BankLoadedState) {

                    Utils.showSnackBar(context, state.message, whiteColor, 2000);

                    Future.delayed(const Duration(milliseconds: 1000),(){
                      goToNext();
                    });

                  }
                }
              }
            },
            builder: (context, states) {
              final state = states.paymentState;
              if (state is PaymentStatePageInfoLoading) {
                return const LoadingWidget();
              } else if (state is PaymentStatePageInfoError) {
                if (state.statusCode == 503 || detailCubit.payment != null) {
                  return LoadedPaymentInfo(model: detailCubit.payment);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is PaymentStatePageInfoLoaded) {
                return LoadedPaymentInfo(model: state.payment);
              }

              if (detailCubit.payment != null) {
                return LoadedPaymentInfo(model: detailCubit.payment);
              } else {
                return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }

  goToNext(){
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerSellerOrderScreen,
            (route) {
          if (route.settings.name == RouteNames.mainScreen) {
            return true;
          } else {
            return false;
          }
        },arguments: 'success');
  }

}

class LoadedPaymentInfo extends StatelessWidget {
  const LoadedPaymentInfo({super.key, required this.model});
  final PaymentModel ? model;

  @override
  Widget build(BuildContext context) {
    final pCubit = context.read<PaymentCubit>();

    final List<Widget> paymentItems = [
      if (model?.setting?.stripeStatus == 1)
        paymentItemCard(context, model?.setting?.stripeImage, () {
          pCubit..clear()..isNavigating = true;
          Navigator.pushNamed(context, RouteNames.buyerStripePaymentScreen).then((_) {
            pCubit.isNavigating = false;
          });
        }),

      if (model?.setting?.paypalStatus == 1)
        paymentItemCard(context, model?.setting?.paypalImage, () {
          Navigator.pushNamed(context, RouteNames.paypalScreen, arguments: pCubit.paymentUrl(WebPayType.paypal));
        }),

      if (model?.setting?.razorpayStatus == 1)
        paymentItemCard(context, model?.setting?.razorpayImage, () {
          Navigator.pushNamed(context, RouteNames.razorpayScreen, arguments: pCubit.paymentUrl(WebPayType.razorpay));
        }),

      if (model?.setting?.flutterwaveStatus == 1)
        paymentItemCard(context, model?.setting?.flutterwaveLogo, () {
          Navigator.pushNamed(context, RouteNames.flutterWaveScreen, arguments: pCubit.paymentUrl(WebPayType.flutterWave));
        }),

      if (model?.setting?.mollieStatus == 1)
        paymentItemCard(context, model?.setting?.mollieImage, () {
          Navigator.pushNamed(context, RouteNames.molliePaymentScreen, arguments: pCubit.paymentUrl(WebPayType.molli));
        }),

      if (model?.setting?.paystackStatus == 1)
        paymentItemCard(context, model?.setting?.paystackImage, () {
          Navigator.pushNamed(context, RouteNames.paystackPaymentScreen, arguments: pCubit.paymentUrl(WebPayType.payStack));
        }),

      if (model?.setting?.instamojoStatus == 1)
        paymentItemCard(context, model?.setting?.instamojoImage, () {
          Navigator.pushNamed(context, RouteNames.instamojoPaymentScreen, arguments: pCubit.paymentUrl(WebPayType.instamojo));
        }),

      if (model?.setting?.bankStatus == 1)
        paymentItemCard(context, model?.setting?.bankImage, () {
          pCubit..clear()..isNavigating = true;
          Navigator.pushNamed(context, RouteNames.buyerBankPaymentScreen).then((_) {
            pCubit.isNavigating = false;
          });
        }),

      if (Utils.isAddon(context)?.wallet == true)
        paymentItemCard(context, KImages.walletImage, () {
          pCubit.clear();
          pCubit.bankWalletPayment(false);
        }, false),
    ];


    return ListView(
      padding: Utils.symmetric().copyWith(bottom: 30.0),
      children: [

       const CardTopPart(title: 'Package Information'),
        PackageCard(package: model?.listingPackage,showButton: false),

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
        )

      ],
    );
  }
}
/*
Widget paymentItemCard(BuildContext context,bool visible, String? image,VoidCallback onTap,[bool isNetwork = true]){
  if(visible){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Utils.vSize(20.0),
        width: Utils.hSize(140.0),
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          borderRadius: Utils.borderRadius(r: 6.0),
          color: scaffoldBgColor,
        ),
        child: CustomImage(path: isNetwork? RemoteUrls.imageUrl(image??Utils.defaultImg(context)):image),
      ),
    );
  }else{
    return const SizedBox.shrink();
  }
}*/
Widget paymentItemCard(BuildContext context, String? image, VoidCallback onTap, [bool isNetwork = true]) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: Utils.vSize(20.0),
      width: Utils.hSize(140.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: Utils.borderRadius(r: 6.0),
        color: scaffoldBgColor,
      ),
      child: CustomImage(path: isNetwork ? RemoteUrls.imageUrl(image ?? Utils.defaultImg(context)) : image),
    ),
  );
}

