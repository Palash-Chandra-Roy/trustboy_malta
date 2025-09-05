import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/data_provider/remote_url.dart';
import '../../../../../../data/models/home/my_application_model.dart';
import '../../../../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../../../utils/constraints.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/circle_image.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../user_screen/user_more/components/withdraw/withdraw_screen.dart';

class JobAppliedCard extends StatelessWidget {
  const JobAppliedCard({super.key, required this.applicant});

  final ApplicationModel? applicant;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: whiteColor),
      child: Padding(
        padding: Utils.all(value: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  CircleImage(
                      image: RemoteUrls.imageUrl(
                          applicant?.seller?.image.isNotEmpty ?? false
                              ? applicant?.seller?.image ??
                                  Utils.defaultImg(context)
                              : Utils.defaultImg(context)),
                      size: 50.0),
                  Utils.horizontalSpace(10.0),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: CustomText(
                            text: applicant?.seller?.name ?? 'No name found',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            maxLine: 2,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFEDEBE7)),
                          child: Padding(
                            padding: Utils.symmetric(v: 4.0, h: 8.0),
                            child: CustomText(
                                text: Utils.capitalizeFirstLetter(
                                    applicant?.status ?? '')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: Utils.borderRadius(r: 30.0),
                  color: stockColor,
                ),
                padding: Utils.all(value: 6.0),
                child: const Icon(Icons.more_vert),
              ),
              splashRadius: 1.0,
              shadowColor: transparent,
              color: whiteColor,
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                borderRadius: Utils.borderRadius(r: 4.0),
              ),
              // constraints: BoxConstraints.expand(
              //   width: Utils.hSize(280.0),
              //   height: Utils.vSize(300.0),
              // ),
              onSelected: (value) {
                if (value == '1') {
                  _detail(context, applicant);
                } else if (value == '2') {
                  debugPrint('iddd ${applicant?.id}');
                  context
                      .read<JobPostCubit>()
                      .hiredApplicant(applicant?.id.toString() ?? '');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: '1',
                  child: CustomText(
                      text: Utils.translatedText(context, 'See more'),
                      maxLine: 2,
                      fontWeight: FontWeight.w500),
                ),
                if(applicant?.status == 'pending')...[
                  PopupMenuItem(
                    value: '2',
                    child: CustomText(
                        text: Utils.translatedText(context, 'Approve'),
                        maxLine: 2,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  _detail(BuildContext context, ApplicationModel? item) {
    // final profile = context.read<ProfileCubit>();
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
                    WithdrawKeyValue(
                        title: 'Name', value: item?.seller?.name ?? ''),
                    WithdrawKeyValue(
                        title: 'Phone', value: item?.seller?.phone ?? ''),
                    WithdrawKeyValue(
                        title: 'Email', value: item?.seller?.email ?? ''),
                    WithdrawKeyValue(
                        title: 'Address', value: item?.seller?.address ?? ''),
                    WithdrawKeyValue(
                        title: 'Apply Date',
                        value:
                            Utils.timeWithData(item?.createdAt ?? '', false)),
                    WithdrawKeyValue(
                        title: 'Message',
                        value: item?.description ?? '',
                        showDivider: false,
                        maxLine: 6),
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
