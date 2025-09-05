import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:work_zone/presentation/widgets/circle_image.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '/presentation/widgets/custom_image.dart';
import '/presentation/widgets/custom_text.dart';
import '/presentation/widgets/primary_button.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/job_post.dart';
import '../../../data/models/service/review_model.dart';
import '../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/error_text.dart';
import '../../widgets/horizontal_line.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {

  late ServiceDetailCubit detailCubit;

  @override
  void initState() {
    detailCubit = context.read<ServiceDetailCubit>();
    Future.microtask(() => detailCubit.jobPostDetail());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'Job Details')),
      body: PageRefresh(
        onRefresh: () async {
          detailCubit.jobPostDetail();
        },
        child: BlocConsumer<ServiceDetailCubit, ReviewModel>(
          listener: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.detail == null) {
                detailCubit.jobPostDetail();
              }
            }
          },
          builder: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateLoading) {
              return const LoadingWidget();
            } else if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.jobDetail != null) {
                return LoadedJobDetails(model: detailCubit.jobDetail);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is JobsDetailStateLoaded) {
              return LoadedJobDetails(model: state.detailModel);
            }

            if (detailCubit.jobDetail != null) {
              return LoadedJobDetails(model: detailCubit.jobDetail);
            } else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedJobDetails extends StatelessWidget {
  const LoadedJobDetails({super.key, this.model});
  final JobPostModel? model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor),
              child: Padding(
                padding: Utils.symmetric(v: 20.0, h: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${Utils.translatedText(context, 'From')} - ${Utils.formatAmount(context, model?.jobPost?.regularPrice??0.0)}",
                      fontSize: 16,
                    ),
                     CustomText(
                      text: model?.jobPost?.title??'',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      maxLine: 2,
                    ),
                    Utils.verticalSpace(6.0),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500.0),
                            color: const Color(0xFFEDEBE7),
                          ),
                          child: Padding(
                            padding: Utils.symmetric(v: 5.0, h: 10.0),
                            child: Row(
                              children: [
                                const CustomImage(path: KImages.location),
                                Utils.horizontalSpace(4.0),
                                 const CustomText(
                                    text: 'Dhaka',
                                    color: Color(0xFF13544E),
                                    fontSize: 12.0)
                              ],
                            ),
                          ),
                        ),
                        Utils.horizontalSpace(8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500.0),
                            color: const Color(0xFFEDEBE7),
                          ),
                          child: Padding(
                            padding: Utils.symmetric(v: 5.0, h: 10.0),
                            child:  CustomText(
                                text:model?.jobPost?.jobType??'',
                                color: const Color(0xFF13544E),
                                fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    Utils.verticalSpace(20.0),
                    const HorizontalLine(),
                    Utils.verticalSpace(20.0),
                    CustomText(
                      text: Utils.translatedText(context, 'Job Description'),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),

                    HtmlWidget(model?.jobPost?.description ?? ''),
                    if(Utils.isSeller(context))...[
                      Utils.verticalSpace(20.0),
                      PrimaryButton(
                        text: Utils.translatedText(context, 'Apply Now'),
                        borderRadiusSize: 45.0,
                        onPressed: (){
                          context.read<JobPostCubit>().clear();
                          _applyJobPost(context,model);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Utils.verticalSpace(20.0),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor),
              child: Padding(
                padding: Utils.symmetric(v: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleImage(
                          size: 50.0,
                          type: ImageType.rectangle,
                          radius: 4.0,
                          fit: BoxFit.fill,
                           image: RemoteUrls.imageUrl(
                      (model?.author?.image.isNotEmpty ?? false)
                          ? model?.author?.image ??
                          Utils.defaultImg(context)
                          : Utils.defaultImg(context))
                        ),
                        Utils.horizontalSpace(10.0),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: model?.author?.name??'',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                              Flexible(
                                child: CustomText(
                                  text: model?.author?.address??'',
                                  fontSize: 12.0,
                                  maxLine: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                                                   ),
                         )
                      ],
                    ),
                    Utils.verticalSpace(20.0),
                    const HorizontalLine(),
                    Utils.verticalSpace(10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CustomImage(path: KImages.member),
                            Utils.horizontalSpace(6.0),
                            CustomText(
                              text: Utils.translatedText(context, 'Member Since'),
                              fontSize: 16,
                              maxLine: 1,
                            )
                          ],
                        ),
                        Flexible(child: CustomText(text: Utils.timeWithData(model?.author?.createdAt??'',false))),
                      ],
                    ),
                    Utils.verticalSpace(10.0),
                    const HorizontalLine(),
                    Utils.verticalSpace(10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CustomImage(path: KImages.tOrder),
                            Utils.horizontalSpace(6.0),
                            CustomText(
                              text: Utils.translatedText(context, 'Category'),
                              fontSize: 16,
                            )
                          ],
                        ),
                         CustomText(text: model?.jobPost?.category?.name??'',),
                      ],
                    ),
                    Utils.verticalSpace(10.0),
                    const HorizontalLine(),
                    Utils.verticalSpace(10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CustomImage(path: KImages.jobBeg),
                            Utils.horizontalSpace(6.0),
                            CustomText(
                              text: Utils.translatedText(context, 'Total Job'),
                              fontSize: 16.0,
                            )
                          ],
                        ),
                         CustomText(text: model?.totalJobByAuthor.toString()??'0'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Utils.verticalSpace(20.0),
          ],
        ),
      ),
    );
  }



   _applyJobPost(BuildContext context,JobPostModel? model) {
    final subsCubit = context.read<JobPostCubit>();

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
                    text: Utils.translatedText(context, 'Submit Proposal'),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.clear, color: redColor)),
                ],
              ),
              Utils.verticalSpace(14.0),
              BlocBuilder<JobPostCubit, JobPostItem>(
                builder: (context, state) {
                  final amount = state.postState;
                  return CustomFormWidget(
                    label: Utils.translatedText(context, 'Write your proposal'),
                    bottomSpace: 14.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.description,
                          onChanged: subsCubit.descriptionChange,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Write your proposal',true),
                              border:  outlineBorder(10.0),
                              enabledBorder: outlineBorder(10.0),
                              focusedBorder: outlineBorder(10.0),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                        ),
                        if (amount is JobPostApplyFormError) ...[
                          if (amount.errors.description.isNotEmpty)
                            ErrorText(text: amount.errors.description.first)
                        ]
                      ],
                    ),
                  );
                },
              ),
              BlocConsumer<JobPostCubit, JobPostItem>(
                listener: (context, state) {
                  final coupon = state.postState;
                  if (coupon is JobPostApplyError) {
                    // if (coupon.statusCode == 401) {
                    //   Navigator.of(context).pop();
                    // }
                    Navigator.of(context).pop();
                    Utils.errorSnackBar(context, coupon.message);

                  } else if (coupon is JobPostApplyLoaded) {
                    Navigator.of(context).pop();
                    // orderCubit.getSingleOrderList(widget.id);
                    Utils.showSnackBar(context, coupon.message);
                  }
                },
                builder: (context, state) {
                  final coupon = state.postState;
                  final isEmptyField = state.description.trim().isNotEmpty;

                  if (coupon is JobPostAddingLoading) {
                    return const LoadingWidget();
                  }
                  return PrimaryButton(
                      text: Utils.translatedText(context, 'Submit Proposal'),
                      bgColor: isEmptyField ? primaryColor : grayColor,
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        if (isEmptyField) {
                          // debugPrint('idddd ${model?.jobPost?.id}');
                          subsCubit.applyJobPost(model?.jobPost?.id.toString()??'');
                        }
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

