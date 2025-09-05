import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/service/service_item.dart';
import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/circle_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/favourite_button.dart';

class SingleService extends StatelessWidget {
  const SingleService({super.key, required this.item, this.width, this.imageHeight});
  final ServiceItem item;
  final double ? width;
  final double ? imageHeight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<ServiceDetailCubit>()..addType('service')..addSlug(item.slug);
        Navigator.pushNamed(context, RouteNames.serviceDetailsScreen);
      },
      child: Container(
        width: width ?? Utils.mediaQuery(context).width * 0.46,
        padding: Utils.symmetric(v: 6.0, h: 6.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: Utils.borderRadius(r: 8.0),
          boxShadow:  [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.06),
              blurRadius: 30.0,
              offset: const Offset(0, 0),
              spreadRadius: 5.0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight?? Utils.mediaQuery(context).height * 0.16,
              width: Utils.mediaQuery(context).width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleImage(
                      image: RemoteUrls.imageUrl(item.thumbImage),
                      type: ImageType.rectangle,
                      radius: 5.0,
                      size: imageHeight?? Utils.mediaQuery(context).height * 0.16,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    top: Utils.vSize(10.0),
                    right: Utils.hSize(10.0),
                    child:  FavouriteButton(id: item.id),
                  ),
                ],
              ),
            ),
            Padding(
              padding: Utils.symmetric(h: 10.0, v: 6.0).copyWith(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: CustomText(
                            text: Utils.formatAmount(context, item.regularPrice),
                            color: primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            maxLine: 1,
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: Utils.only(top: 0.0, right: 2.0),
                            child: const Icon(
                              Icons.star,
                              color: primaryColor,
                              size: 14.0,
                            ),
                          ),
                           CustomText(text: '${item.avgRating}', color: gray5B,fontSize: 12.0,),
                           // CustomText(text: '${item.avgRating} (${item.totalRating})', color: gray5B),
                        ],
                      ),
                    ],
                  ),
                  Utils.verticalSpace(4.0),
                   Flexible(
                    fit: FlexFit.loose,
                    child: CustomText(
                      text: item.title,
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                      maxLine: 3,
                      overflow: TextOverflow.ellipsis,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    height: 0.8,
                    margin: Utils.symmetric(h: 0.0, v: 8.0),
                    color: const Color(0xFFEDEBE7),
                    // color: gray5B.withOpacity(0.2),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Stack(
                         clipBehavior: Clip.none,
                         children: [
                           CircleImage(size: 25.0,image: RemoteUrls.imageUrl((item.seller?.image.isNotEmpty??false)?item.seller?.image??Utils.defaultImg(context):Utils.defaultImg(context))),
                           if(item.seller?.onlineStatus == 1)...[
                             Positioned(
                               bottom: 0.0,
                               right: 0.0,
                               child: Container(
                                 height: Utils.vSize(10.0),
                                 width: Utils.vSize(10.0),
                                 padding: Utils.all(value: 1.5),
                                 decoration: const BoxDecoration(
                                   color: whiteColor,
                                   shape: BoxShape.circle,
                                 ),
                                 child: const DecoratedBox(
                                   decoration: BoxDecoration(
                                     color: primaryColor,
                                     shape: BoxShape.circle,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ],
                       ),
                      Utils.horizontalSpace(10.0),
                       Flexible(
                        child: CustomText(
                          text: (item.seller?.name.isNotEmpty??false)?item.seller?.name??'Demo name':'Demo name',
                          color: blackColor,
                          fontSize: 12.0,
                          maxLine: 1,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                        if(item.seller?.kycStatus == 1)...[
                          Padding(
                            padding: Utils.only(bottom: 3.0,left: 4.0),
                            child: const Icon(Icons.verified,color: primaryColor,size: 14.0,),
                          )
                        ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
