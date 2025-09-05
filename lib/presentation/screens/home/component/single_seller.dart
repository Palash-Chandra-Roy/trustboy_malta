import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/home/seller_model.dart';
import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/circle_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/primary_button.dart';

class SingleSeller extends StatelessWidget {
  const SingleSeller({super.key, required this.seller, this.width});
  final SellerModel seller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Utils.mediaQuery(context).width * 0.5,
      padding: Utils.symmetric(v: 12.0, h: 0.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: Utils.borderRadius(r: 12.0),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: Utils.symmetric(h: 8.0, v: 6.0),
              margin: Utils.symmetric(h: 10.0).copyWith(bottom: 10.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: Utils.borderRadius(r: 50.0),
              ),
              child: CustomText(
                text: '${Utils.formatAmount(context, seller.hourlyPayment)}/${Utils.translatedText(context, 'hr')}',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: whiteColor,
                maxLine: 1,
              ),
            ),
          ),
           Stack(
            children: [
              CircleImage(image: RemoteUrls.imageUrl(seller.image.isNotEmpty?seller.image:Utils.defaultImg(context))),
              // CircleImage(image: KImages.defaultImg, type: ImageType.circle, size: 120.0),
              if(seller.onlineStatus == 1)...[
                const Positioned(
                    right: 10.0,
                    bottom: 5.0,
                    child: CircleAvatar(
                        backgroundColor: whiteColor,maxRadius: 8.0,
                        child: CircleAvatar(backgroundColor: primaryColor,maxRadius: 6.0,))),
              ],
            ],
          ),
          Utils.verticalSpace(10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Flexible(
                 child: CustomText(
                  text: seller.name,
                  color: blackColor,
                  fontSize: 16.0,
                  maxLine: 1,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis),
               ),
              if(seller.kycStatus == 1)...[
                Padding(
                  padding: Utils.only(left: 6.0,bottom: 3.0),
                  child: const Icon(Icons.verified,color: primaryColor,size: 16.0,),
                )
              ],
            ],
          ),
         if(seller.designation.isNotEmpty)...[
           Utils.verticalSpace(4.0),
           CustomText(
             text: seller.designation.isNotEmpty?seller.designation:Utils.translatedText(context, 'Not found'),
             color: gray5B,
             fontSize: 10.0,
             fontWeight: FontWeight.w400,
             maxLine: 1,
             overflow: TextOverflow.ellipsis,
           ),
         ],
          Utils.verticalSpace(4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Utils.only(bottom: 2.0, right: 2.0),
                child: const Icon(
                  Icons.star,
                  color: blackColor,
                  size: 16.0,
                ),
              ),
               CustomText(text: '${seller.avgRating} (${seller.totalRating} ${Utils.translatedText(context, 'Reviews')})', color: gray5B),
            ],
          ),
          Utils.verticalSpace(10.0),
          PrimaryButton(
            text: Utils.translatedText(context, Language.viewProfile),
            onPressed: () {
              context.read<ServiceDetailCubit>()..addType('seller')..addSlug(seller.username);
              Navigator.pushNamed(context, RouteNames.sellerDetailsScreen);
            },
            padding: Utils.symmetric(h: 12.0),
            minimumSize: const Size(double.infinity, 34.0),
            bgColor: stockColor,
            borderRadiusSize: 40.0,
            textColor: blackColor,
            fontWeight: FontWeight.w400,
           // buttonType: ButtonType.iconButton,
            borderColor: transparent,
            fontSize: 14.0,
            // icon: const Icon(
            //   Icons.arrow_forward,
            //   color: blackColor,
            // ),
          ),
        ],
      ),
    );
  }
}
