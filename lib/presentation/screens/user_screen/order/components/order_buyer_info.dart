import 'package:flutter/material.dart';
import '/presentation/widgets/horizontal_line.dart';

import '../../../../../data/data_provider/remote_url.dart';
import '../../../../../data/models/home/seller_model.dart';
import '../../../../../data/models/order/order_detail_model.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/k_images.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/circle_image.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/custom_text.dart';

class OrderBuyerInfo extends StatelessWidget {
  const OrderBuyerInfo({super.key, required this.seller,required this.order});
  final SellerModel? seller;
  final OrderDetail? order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
              color: primaryColor.withOpacity(0.3),
            ),
            child:  Center(
                child: CustomText(
                  text: Utils.translatedText(context, 'Buyer Info'),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Padding(
            padding: Utils.symmetric(v: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 /*   Container(
                      height: 80.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: secondaryColor),
                      child:  CustomImage(path: RemoteUrls.imageUrl((seller?.image.isNotEmpty??false)?seller?.image??Utils.defaultImg(context):Utils.defaultImg(context)),),
                      // child:  CustomImage(path: KImages.jobLogo),
                    ),*/
                    CircleImage(image: RemoteUrls.imageUrl((seller?.image.isNotEmpty??false)?seller?.image??Utils.defaultImg(context):Utils.defaultImg(context)),size: 80.0,),
                    Utils.horizontalSpace(6.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: seller?.name??'',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          Utils.verticalSpace(2.0),
                          CustomText(
                            text: "(${seller?.designation??''})",
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                         if(seller?.address.isNotEmpty??false)...[
                           Utils.verticalSpace(2.0),
                           CustomText(
                             text: seller?.address.isNotEmpty??false?seller?.address??'No Address found!':'No Address found!',
                             fontSize: 12.0,
                             fontWeight: FontWeight.w400,
                             maxLine: 2,
                           ),
                         ]
                        ],
                      ),
                    ),
                  ],
                ),
                HorizontalLine(color: gray5B,margin: Utils.symmetric(h: 0.0,v: 10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomImage(path: KImages.member),
                        Utils.horizontalSpace(6.0),
                        CustomText(
                          text: Utils.translatedText(context, "Member Since"),
                          fontSize: 16.0,
                        )
                      ],
                    ),
                    CustomText(text: Utils.timeWithData(seller?.createdAt??'',false)),

                  ],
                ),
                Utils.verticalSpace(10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomImage(path: KImages.star,),
                        Utils.horizontalSpace(6.0),
                        CustomText(
                          text: Utils.translatedText(context, 'Reviews'),
                          fontSize: 16.0,
                        )
                      ],
                    ),
                    CustomText(text: seller?.totalRating.toString()??'0'),
                  ],
                ),
                Utils.verticalSpace(10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomImage(path: KImages.begIcon),
                        Utils.horizontalSpace(6.0),
                        CustomText(
                          text: Utils.translatedText(context, "Total Job"),
                          fontSize: 16.0,
                        )
                      ],
                    ),
                    CustomText(text: order?.totalJob.toString()??''),
                  ],
                ),
                Utils.verticalSpace(10.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
