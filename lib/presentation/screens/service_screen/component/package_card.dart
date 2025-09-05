import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/widgets/primary_button.dart';

import '/data/models/setting/currencies_model.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_image.dart';
import '/presentation/widgets/custom_text.dart';
import '../../../../data/models/service/service_package_model.dart';
import '../../../../logic/cubit/payment/payment_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';


class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package,this.showButton});

  final ServicePackageModel? package;
  final bool ? showButton;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PaymentCubit,CurrenciesModel>(
      builder: (context,state){
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            color: whiteColor,
          ),
          child: Padding(
            padding: Utils.symmetric(v: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                if(state.id == 0)...[
                  _packageName(context,package?.basicName??'',package?.basicPrice??0.0),
                ]else if(state.id == 1)...[
                  _packageName(context,package?.standardName??'',package?.standardPrice??0.0),
                ]else...[
                  _packageName(context,package?.premiumName??'',package?.premiumPrice??0.0),
                ],

                if(state.id == 0)...[
                  _description(package?.basicDescription??''),
                ]else if(state.id == 1)...[
                  _description(package?.standardDescription??''),
                ]else...[
                  _description(package?.premiumDescription??''),
                ],
                Utils.verticalSpace(10.0),
                if(state.id == 0)...[
                  _deliveryRevision(context,package?.basicDeliveryDate??0,package?.basicRevision??0),
                ]else if(state.id == 1)...[
                  _deliveryRevision(context,package?.standardDeliveryDate??0,package?.standardRevision??0),
                ]else...[
                  _deliveryRevision(context,package?.premiumDeliveryDate??0,package?.premiumRevision??0),
                ],

                Utils.verticalSpace(20.0),

                if(state.id == 0)...[
                  _featureItem(Utils.translatedText(context, 'Functional Website'),package?.basicFnWebsite.toLowerCase() == 'yes'),
                  _featureItem('${package?.basicPage??0} ${Utils.translatedText(context, 'Pages')}',true),
                  _featureItem(Utils.translatedText(context, 'Responsive design'),package?.basicResponsive.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Source file'),package?.basicSourceCode.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Content upload'),package?.basicContentUpload.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Speed optimization'),package?.basicSpeedOptimized.toLowerCase() == 'yes'),
                ]else if(state.id == 1)...[
                  _featureItem(Utils.translatedText(context, 'Functional Website'),package?.standardFnWebsite.toLowerCase() == 'yes'),
                  _featureItem('${package?.standardPage??0} ${Utils.translatedText(context, 'Pages')}',true),
                  _featureItem(Utils.translatedText(context, 'Responsive design'),package?.standardResponsive.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Source file'),package?.standardSourceCode.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Content upload'),package?.standardContentUpload.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Speed optimization'),package?.standardSpeedOptimized.toLowerCase() == 'yes'),
                ]else...[
                  _featureItem(Utils.translatedText(context, 'Functional Website'),package?.premiumFnWebsite.toLowerCase() == 'yes'),
                  _featureItem('${package?.premiumPage??0} ${Utils.translatedText(context, 'Pages')}',true),
                  _featureItem(Utils.translatedText(context, 'Responsive design'),package?.premiumResponsive.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Source file'),package?.premiumSourceCode.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Content upload'),package?.premiumContentUpload.toLowerCase() == 'yes'),
                  _featureItem(Utils.translatedText(context, 'Speed optimization'),package?.premiumSpeedOptimized.toLowerCase() == 'yes'),
                ],
                Utils.verticalSpace(10.0),
                if(showButton??true)...[
                  PrimaryButton(text: Utils.translatedText(context, 'Order Now'), onPressed: (){
                    if(Utils.isLoggedIn(context)){
                      Navigator.pushNamed(context,RouteNames.buyerPaymentScreen);
                    }else{
                      Utils.showSnackBarWithLogin(context);
                    }
                  }),
                ]
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _deliveryRevision(BuildContext context,int date,int revision) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomImage(path: KImages.clockIcon, height: 20.0),
              Utils.horizontalSpace(6.0),
              Flexible(
                child: CustomText(
                    text: "$date ${Utils.translatedText(context, 'Day Delivery')}",
                    fontSize: 18.0,maxLine: 2),
              )
            ],
          ),
        ),
        Utils.horizontalSpace(6.0),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomImage(path: KImages.reloadIcon, height: 20.0),
              Utils.horizontalSpace(6.0),
              Flexible(
                child: CustomText(
                    text: "$revision ${Utils.translatedText(context, 'Revisions')}",
                    fontSize: 18.0, maxLine: 2
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _description(String des) {
    return CustomText(
      text: des,
      fontSize: 14.0, color: gray5B,maxLine: 3,height: 1.6,
    );
  }

  Widget _packageName(BuildContext context,String name,double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: CustomText(
              text: name,
              fontSize: 18.0,
              color: blackColor,
              fontWeight: FontWeight.w500,
              maxLine: 2),
        ),
        Flexible(
          child: CustomText(
            text: Utils.formatAmount(context, price,2),
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _featureItem(String feature,bool isYes ){
    return Padding(
      padding: Utils.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 15.0,
            width: 15.0,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey.withOpacity(0.3)),
            child:  Icon(isYes? Icons.done:Icons.clear, size: 12.0),
          ),
          Utils.horizontalSpace(6.0),
          Flexible(
            child: CustomText(
                text: feature,
                fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}