import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/logic/cubit/profile/profile_cubit.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';
import 'package:work_zone/presentation/widgets/horizontal_line.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/home/job_post.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/status_view.dart';
import '../../user_screen/user_more/components/withdraw/withdraw_screen.dart';

class SellerJobApplicationCard extends StatelessWidget {
  const SellerJobApplicationCard({super.key, required this.item});
  final JobReqItem? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Utils.symmetric(h: 14.0,v: 6.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.all(value: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Row(
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
                    child: CustomImage(path: RemoteUrls.imageUrl(item?.jobPost?.thumbImage.isNotEmpty??false?item?.jobPost?.thumbImage??Utils.defaultImg(context,false):Utils.defaultImg(context,false)),fit: BoxFit.fill,height: Utils.vSize(70.0),
                      width: Utils.vSize(70.0),),
                  ),

                  Utils.horizontalSpace(6.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Utils.verticalSpace(20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: Utils.formatAmount(context, item?.jobPost?.regularPrice,2),
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            StatusView(status: Utils.jobReqStatusText(context,item),bgColor: Utils.jobReqStatusBg(context,item),),
                           /* Row(
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      debugPrint('edit-id ${item?.id}');
                                      context.read<JobPostCubit>().updateId(item?.id??0);
                                      Navigator.pushNamed(context, RouteNames.addJobScreen);
                                    },
                                    child: const CustomImage(path: KImages.editIcon)),
                                Utils.horizontalSpace(6.0),
                                GestureDetector(
                                    onTap: (){
                                      debugPrint('delete-id ${item?.id}');
                                      context.read<JobPostCubit>()..updateId(item?.id??0)..deleteJobPost();
                                    },
                                    child: const CustomImage(path: KImages.deleteIcon)),
                              ],
                            )*/
                          ],
                        ),

                        CustomText(
                          // text: 'Senior Marketing Finance and Administration',
                          text: item?.jobPost?.title??'',
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
                color: grayColor.withOpacity(0.4),
                margin: Utils.symmetric(h: 0.0,v: 10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: Utils.translatedText(context, 'Date'),
                    color: gray5B,
                  ),
                  CustomText(
                    text: Utils.translatedText(context, Utils.timeWithData(item?.createdAt ??'',false)),
                    color: grayColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CustomText(
              //       text: Utils.translatedText(context, Language.status),
              //       fontSize: 12,
              //     ),
              //     Utils.horizontalSpace(10.0),
              //     Container(
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(25),
              //           color: const Color(0xFFEDEBE7)),
              //       child: Padding(
              //         padding: Utils.symmetric(h: 8.0, v: 4.0),
              //         child:  CustomText(text: Utils.jobStatusText(context,item)),
              //       ),
              //     ),
              //   ],
              // ),
              // Utils.verticalSpace(14.0),
              // PrimaryButton(
              //     bgColor:(item?.totalJobApplication??0) > 0? blackColor:gray5B,
              //     text: '${Utils.translatedText(context, Language.viewApplied)} (${item?.totalJobApplication})',
              //     minimumSize: const Size(double.infinity, 42.0),
              //     onPressed: (item?.totalJobApplication??0) > 0? () {
              //       context.read<JobPostCubit>().applicantId(item?.id??0);
              //       Navigator.pushNamed(context, RouteNames.appliedListScreen);
              //     }:null),
              Utils.verticalSpace(10.0),
              PrimaryButton(
                  text: Utils.translatedText(context, 'Application Details'),
                  minimumSize: const Size(double.infinity, 44.0),
                  onPressed: () =>_detail(context,item))
          ],
        ),
      ),
    );
  }
  _detail(BuildContext context,JobReqItem ? item){
    final profile = context.read<ProfileCubit>();
    Utils.showCustomDialog(
      bgColor: whiteColor,
      context,
      padding: Utils.symmetric(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: Utils.symmetric(v: 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Spacer(),
                  CustomText(
                    text: Utils.translatedText(context, 'Application Details'),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.clear, color: redColor)),
                ],
              ),
              const Divider(color: stockColor),
              Utils.verticalSpace(14.0),
              Container(
                padding: Utils.all(value: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: stockColor),
                  borderRadius: Utils.borderRadius(),
                ),
                child: Column(
                  children: [
                    WithdrawKeyValue(title: 'Name',value: profile.profile?.name??''),
                    WithdrawKeyValue(title: 'Phone',value: profile.profile?.phone??''),
                    WithdrawKeyValue(title: 'Email',value:  profile.profile?.email??''),
                    WithdrawKeyValue(title: 'Address',value: profile.profile?.address??''),
                    WithdrawKeyValue(title: 'Apply Date',value: Utils.timeWithData(item?.createdAt??'',false)),
                    WithdrawKeyValue(title: 'Message',value: item?.description??'' ,showDivider: false,maxLine: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
