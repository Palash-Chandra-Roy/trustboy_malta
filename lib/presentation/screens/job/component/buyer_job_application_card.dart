import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';
import 'package:work_zone/presentation/widgets/horizontal_line.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/home/job_post.dart';
import '../../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/primary_button.dart';

class BuyerJobApplicationCard extends StatelessWidget {
  const BuyerJobApplicationCard({super.key, required this.item});
  final JobPostItem? item;

  @override
  Widget build(BuildContext context) {
    final jobCubit = context.read<JobPostCubit>();
    return Container(
      margin: Utils.symmetric(h: 14.0,v: 6.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.all(value: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  height: Utils.vSize(70.0),
                  width: Utils.vSize(70.0),
                  alignment: Alignment.center,
                  padding: Utils.all(value: 6.0),
                  margin: Utils.only(right: 6.0),
                  decoration: BoxDecoration(
                      borderRadius: Utils.borderRadius(r:5.0),
                      color: scaffoldBgColor),
                  child: CustomImage(path: RemoteUrls.imageUrl(item?.thumbImage.isNotEmpty??false?item?.thumbImage??Utils.defaultImg(context,false):Utils.defaultImg(context,false)),fit: BoxFit.fill,height: Utils.vSize(70.0),
                    width: Utils.vSize(70.0),),
                ),
                Utils.horizontalSpace(6.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: Utils.formatAmount(context, item?.regularPrice),
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    //debugPrint('edit-id ${item?.id}');
                                    context.read<JobPostCubit>().updateId(item?.id??0);
                                    Navigator.pushNamed(context, RouteNames.addJobScreen);
                                  },
                                  child: const CustomImage(path: KImages.editIcon)),
                              Utils.horizontalSpace(6.0),
                              GestureDetector(
                                  onTap: (){
                                    //debugPrint('delete-id ${item?.id}');

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
                                            jobCubit..updateId(item?.id??0)..deleteJobPost();
                                          }
                                        },
                                      ),
                                    );

                                  },
                                  child: const CustomImage(path: KImages.deleteIcon)),
                            ],
                          )
                        ],
                      ),

                      Utils.verticalSpace(4.0),
                      CustomText(
                        // text: 'Senior Marketing Finance and Administration',
                        text: item?.title??'',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        maxLine: 2,
                        height: 1.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            HorizontalLine(
              color: borderColor,
              margin: Utils.symmetric(h: 0.0,v: 12.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: Utils.translatedText(context, Language.status),
                  fontSize: 12.0,
                ),
                Utils.horizontalSpace(10.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Utils.jobStatusBg(context,item)),
                  child: Padding(
                    padding: Utils.symmetric(h: 8.0, v: 4.0),
                    child:  CustomText(text: Utils.jobStatusText(context,item)),
                  ),
                ),
              ],
            ),
            Utils.verticalSpace(14.0),
           /* PrimaryButton(
                bgColor:(item?.totalJobApplication??0) > 0? blackColor:gray5B,
                text: '${Utils.translatedText(context, Language.viewApplied)} (${item?.totalJobApplication})',
                minimumSize: const Size(double.infinity, 44.0),
                onPressed: (item?.totalJobApplication??0) > 0? () {
                  jobCubit.isNavigating = true;
                  context.read<JobPostCubit>().applicantId(item?.id??0);
                  Navigator.pushNamed(context, RouteNames.buyerJobAppliedListScreen).then((_){
                    jobCubit.isNavigating = false;
                  });
                }:null),
            Utils.verticalSpace(10.0),
            PrimaryButton(
                text: Utils.translatedText(context, Language.viewDetails),
                minimumSize: const Size(double.infinity, 44.0),
                onPressed: () {
                    if(item?.approvedByAdmin == 'approved'){
                    context.read<ServiceDetailCubit>().addSlug(item?.slug??'');
                    Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
                  }else{
                      Utils.showSnackBar(context, 'Please wait for admin approval');
                    }
                })*/
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if((item?.totalJobApplication??0) > 0)...[
                    Expanded(
                      flex: 7,
                      child: PrimaryButton(
                          bgColor:(item?.totalJobApplication??0) > 0? blackColor:gray5B,
                          text: '${Utils.translatedText(context, 'Applied')} (${item?.totalJobApplication})',
                          // minimumSize: const Size(double.infinity, 44.0),
                          onPressed: (item?.totalJobApplication??0) > 0? () {
                            jobCubit.isNavigating = true;
                            context.read<JobPostCubit>().applicantId(item?.id??0);
                            Navigator.pushNamed(context, RouteNames.buyerJobAppliedListScreen).then((_){
                              jobCubit.isNavigating = false;
                            });
                          }:null),
                    ),
                    const Spacer(),
                  ],
                  Expanded(
                    flex: 7,
                    child: PrimaryButton(
                        text: Utils.translatedText(context, item?.approvedByAdmin == 'approved'? Language.viewDetails:'Edit Job'),
                        // minimumSize: const Size(double.infinity, 44.0),
                        onPressed: () {
                        // Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
                          if(item?.approvedByAdmin == 'approved'){
                            context.read<ServiceDetailCubit>().addSlug(item?.slug??'');
                            Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
                          }else{
                            context.read<JobPostCubit>().updateId(item?.id??0);
                            Navigator.pushNamed(context, RouteNames.addJobScreen);
                            // Utils.showSnackBar(context, 'Please wait for admin approval');
                          }
                        }),
                  ),
                  ///refund button
                  // Flexible(
                  //   child: PrimaryButton(
                  //     text: Utils.translatedText(context, 'Refund Request'),
                  //     onPressed: () => refundReq(context),
                  //     bgColor: Utils.dynamicPrimaryColor(context),
                  //     textColor: whiteColor,
                  //     fontSize: 16.0,
                  //   ),
                  // )
                ]
            ),

          ],
        ),
      ),
    );
  }
}
