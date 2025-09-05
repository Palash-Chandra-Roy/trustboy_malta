import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:work_zone/presentation/widgets/product_rating.dart';

import '../../data/data_provider/remote_url.dart';
import '../../data/models/service/review_model.dart';
import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'circle_image.dart';
import 'custom_text.dart';

class ReviewItems extends StatelessWidget {
  const ReviewItems({super.key, required this.model});

  final ReviewModel? model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: Utils.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: Utils.borderRadius(r: 6.0),
      ),
      child: Padding(
        padding: Utils.symmetric(v: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductRating(rating: model?.rating??0),
                CustomText(
                  text: Utils.timeWithData(model?.createdAt??'', false),
                  fontSize: 12.0,
                  color: grayColor,
                  height: 1.6,
                ),
              ],
            ),
            Utils.verticalSpace(6.0),
            ReadMoreText(
              model?.review??'',
              trimLines:2,
              // colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimLength: 120,
              trimCollapsedText: Utils.translatedText(context, 'See more'),
              trimExpandedText: Utils.translatedText(context, 'See less'),
              style: GoogleFonts.ibmPlexSansDevanagari(
                fontSize: 14.0,
                color: gray5B,
                height: 1.2
              ),
              moreStyle: GoogleFonts.roboto(
                fontSize: 12.0,
                color: primaryColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),

              lessStyle: GoogleFonts.roboto(
                fontSize: 14.0,
                color: primaryColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            /*Utils.verticalSpace(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // const CircleAvatar(
                    //     maxRadius: 12.0,
                    //     backgroundColor: primaryColor,
                    //     backgroundImage: AssetImage(KImages.profilePicture)),
                    if (model.user?.image.isNotEmpty ?? false) ...[
                      CircleImage(
                          image: model.user?.image.isNotEmpty ?? false
                              ? RemoteUrls.imageUrl(model.user?.image ?? '')
                              : RemoteUrls.imageUrl(
                                  settingCubit.setting?.setting?.defaultAvatar ??
                                      ''),
                          size: 40.0),
                      Utils.horizontalSpace(6.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'By ',
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                color: grayColor,
                              ),
                            ),
                            TextSpan(
                              text: model.user?.name ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                ProductRating(rating: 0, avgRating: model.rating),
                // Row(
                //   children: List.generate(
                //       model.rating.toInt(),
                //       (index) => const Icon(
                //             Icons.star,
                //             color: secondaryColor,
                //             size: 18.0,
                //           )),
                // )
              ],
            )*/
            Utils.verticalSpace(10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Flexible(
                //   child: CustomText(
                //     text: seller.name,
                //     color: blackColor,
                //     fontSize: 16.0,
                //     maxLine: 1,
                //     fontWeight: FontWeight.w700,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                // if(seller.kycStatus == 1)...[
                //   Padding(
                //     padding: Utils.only(left: 6.0,bottom: 3.0),
                //     child: const Icon(Icons.verified,color: primaryColor,size: 18.0,),
                //   )
                // ],
                CircleImage(size: 40.0,image: RemoteUrls.imageUrl((model?.buyer?.image.isNotEmpty??false)?model?.buyer?.image??Utils.defaultImg(context):Utils.defaultImg(context))),
                Utils.horizontalSpace(10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: model?.buyer?.name??'No name found',
                      color: blackColor,
                      fontSize: 14.0,
                      maxLine: 1,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CustomText(
                      text: model?.buyer?.designation??'No designation found',
                      color: gray5B,
                      fontSize: 12.0,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
