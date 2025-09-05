import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/data_provider/remote_url.dart';
import '../../../../../data/models/service/service_item.dart';
import '../../../../../logic/cubit/service/service_cubit.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/k_images.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/circle_image.dart';
import '../../../../widgets/confirm_dialog.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/horizontal_line.dart';

class ManageServiceCard extends StatelessWidget {
  const ManageServiceCard({super.key, required this.item});

  final ServiceItem? item;

  @override
  Widget build(BuildContext context) {
    final jCubit = context.read<ServiceCubit>();
    return Container(
      width:  Utils.mediaQuery(context).width * 0.46,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Utils.mediaQuery(context).height * 0.16,
            width: Utils.mediaQuery(context).width,
            // padding: Utils.symmetric(h: 6.0, v: 10.0).copyWith(top: 0.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleImage(
                    image:  item?.thumbImage != 'default.png'? RemoteUrls.imageUrl(item?.thumbImage??Utils.defaultImg(context,false)):Utils.defaultImg(context,false),
                    // image: RemoteUrls.imageUrl(((item?.thumbImage.isNotEmpty??false) && item?.thumbImage != 'default.png')?item?.thumbImage??Utils.defaultImg(context,false):Utils.defaultImg(context,false)),
                    type: ImageType.rectangle,
                  radius: 5.0,
                  size: Utils.mediaQuery(context).height * 0.16,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: Utils.vSize(10.0),
                  right: Utils.hSize(10.0),
                    child: GestureDetector(
                      onTap: (){
                          debugPrint('delete-id ${item?.id}');
                          // debugPrint('state ${jCubit.state}');
                          // jCubit.allJobs(item?.id??0);
                          // jCubit..updateId(item?.id??0)..deleteJobPost();
                          // if(item?.id != 0){
                          // jCubit.deleteGalleryImg(item?.id??0,false);
                          // }

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ConfirmDialog(
                              image: const CustomImage(path: KImages.deleteIcon, color: whiteColor),
                              bgColor: redColor,
                              confirmHeading: 'Delete Confirmation',
                              message: 'Are you realy want to delete this item ?',
                              confirmText: 'Yes, Delete It',
                              //Delete Confirmation
                              onTap: (){
                                Navigator.of(context).pop();
                                if(item?.id != 0){
                                jCubit.deleteGalleryImg(item?.id??0,false);
                                }
                              },
                            ),
                          );
                        },
                      child: const CircleAvatar(
                        backgroundColor: whiteColor,
                        child: Icon(
                          Icons.delete_forever,
                          size: 28.0,
                          color: redColor,
                        ),
                      ),
                    ),
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
                          text: Utils.formatAmount(context, item?.regularPrice??0.0),
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
                        CustomText(text: '${item?.avgRating}', color: gray5B,fontSize: 12.0,),
                        // CustomText(text: '${item.avgRating} (${item.totalRating})', color: gray5B),
                      ],
                    ),
                    // CustomText(text: Utils.timeWithData(item?.createdAt??'',false))
                  ],
                ),
                Utils.verticalSpace(4.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: CustomText(
                    text: item?.title??'',
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    maxLine: 3,
                    overflow: TextOverflow.ellipsis,
                    height: 1.4,
                  ),
                ),
                const HorizontalLine(),
                Utils.verticalSpace(5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20.0,
                      width: 40.0,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: item?.status == 'enable',
                          activeColor: primaryColor,
                          onChanged: (bool? val){
                            jCubit.serviceStatus(item?.id??0);
                            // if(online is! GetProfileLoading){
                            //   profile.updateProfileAvatar(true);
                            // }
                          },
                          // onChanged: (val) {
                          //   final homeController = MainController();
                          //   if (loginBloc.userInfo != null &&
                          //       loginBloc.userInfo!.isVendor == 0) {
                          //     Utils.showSnackBarWithAction(
                          //         context,
                          //         Utils.translatedText(context, "You are not a vendor"),
                          //             () => Navigator.pushNamed(
                          //             context, RouteNames.becomeSellerScreen));
                          //   } else {
                          //     if (val) {
                          //       homeController.naveListener.add(3);
                          //     } else {
                          //       //homeController.naveListener.add(2);
                          //     }
                          //     loginBloc.add(RememberIsSellerEvent(state.isSeller));
                          //   }
                          // },
                        ),
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          debugPrint('edit-id ${item?.id}');
                          context.read<ServiceCubit>().serviceId(item?.id??0);
                          Navigator.pushNamed(context, RouteNames.addUpdateServiceScreen);
                        },
                        child: Container(
                          padding: Utils.symmetric(h: 10.0,v: 4.0),
                          margin: Utils.only(left: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: Utils.borderRadius(),
                            color: blackColor,
                          ),
                          child: CustomText(
                            text: Utils.translatedText(context, 'Edit Job'),
                            color: whiteColor,
                            fontSize: 12.0,
                            maxLine: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
