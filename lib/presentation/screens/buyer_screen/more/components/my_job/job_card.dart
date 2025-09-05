import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/data_provider/remote_url.dart';
import '../../../../../../data/models/home/job_post.dart';
import '../../../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../../../routes/route_names.dart';
import '../../../../../utils/constraints.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_image.dart';
import '../../../../../widgets/custom_text.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.item});
  final JobPostItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ServiceDetailCubit>().addSlug(item.slug);
        Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: whiteColor),
        child: Padding(
          padding: Utils.all(value: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Utils.vSize(100.0),
                width: Utils.vSize(100.0),
                alignment: Alignment.center,
                padding: Utils.all(value: 6.0),
                margin: Utils.only(right: 12.0),
                decoration: BoxDecoration(
                    borderRadius: Utils.borderRadius(r:5.0),
                    color: scaffoldBgColor),
                child: CustomImage(path: RemoteUrls.imageUrl(item.thumbImage),fit: BoxFit.fill,height: Utils.vSize(100.0),
                  width: Utils.vSize(100.0),),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: Utils.only(right: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: scaffoldBgColor,
                          ),
                          child: Padding(
                            padding: Utils.symmetric(h: 8.0, v: 4.0),
                            child:  CustomText(text: item.jobType),
                          ),
                        ),
                        // Utils.horizontalSpace(10.0),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: CustomText(
                                  text: Utils.translatedText(context, 'From'),
                                  color: blackColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  maxLine: 1,
                                ),
                              ),
                              Utils.horizontalSpace(4.0),
                              Flexible(
                                flex: 2,
                                child: CustomText(
                                  text: Utils.formatAmount(context, item.regularPrice),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                  maxLine: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Utils.verticalSpace(10.0),
                    CustomText(
                      // text: 'Senior Marketing Finance and Administration',
                      text: item.title,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      maxLine: 2,
                      height: 1.5,
                    ),
                    // Utils.verticalSpace(6.0),
                    // GestureDetector(
                    //     onTap: () {
                    //       context.read<ServiceDetailCubit>().addSlug(item.slug);
                    //       Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
                    //     },
                    //     child: CustomText(
                    //       text: Utils.translatedText(context, 'Apply Now'),
                    //       fontSize: 16.0,
                    //     )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
