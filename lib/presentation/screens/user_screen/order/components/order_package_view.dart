import 'package:flutter/material.dart';
import '../../../../../data/models/service/service_package_model.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_text.dart';

import '../../../../utils/utils.dart';


class OrderPackageView extends StatelessWidget {
  const OrderPackageView({super.key, required this.index, required this.package});

  final int index;
  final ServicePackageModel? package;

  @override
  Widget build(BuildContext context) {
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
            if(index == 0)...[
              _featureItem(Utils.translatedText(context, 'Functional Website'),package?.basicFnWebsite.toLowerCase() == 'yes'),
              _featureItem('${package?.basicPage??0} ${Utils.translatedText(context, 'Pages')}',true),
              _featureItem(Utils.translatedText(context, 'Responsive design'),package?.basicResponsive.toLowerCase() == 'yes'),
              _featureItem(Utils.translatedText(context, 'Source file'),package?.basicSourceCode.toLowerCase() == 'yes'),
              _featureItem(Utils.translatedText(context, 'Content upload'),package?.basicContentUpload.toLowerCase() == 'yes'),
              _featureItem(Utils.translatedText(context, 'Speed optimization'),package?.basicSpeedOptimized.toLowerCase() == 'yes'),
            ]else if(index == 1)...[
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

          ],
        ),
      ),
    );
  }

  Widget _featureItem(String feature,bool isYes ){
    if(isYes == true){
      return Row(
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
      );
    }else{
      return const SizedBox.shrink();
    }
  }
}