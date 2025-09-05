import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '/data/models/setting/currencies_model.dart';
import '/logic/cubit/service_detail/service_detail_cubit.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '/presentation/widgets/custom_text.dart';
import '../../../data/models/service/review_model.dart';
import '../../../data/models/service/service_model.dart';
import '../../../logic/cubit/payment/payment_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/common_container.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/review_item.dart';
import 'component/package_card.dart';
import 'component/service_image_section.dart';
import 'component/service_seller_info.dart';

class ServiceDetailsScreen extends StatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late ServiceDetailCubit detailCubit;

  @override
  void initState() {
    detailCubit = context.read<ServiceDetailCubit>();
    Future.microtask(() => detailCubit.serviceDetail());
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Service Detail')),
      body: PageRefresh(
        onRefresh: () async {
          detailCubit.serviceDetail();
        },
        child: BlocConsumer<ServiceDetailCubit, ReviewModel>(
          listener: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.detail == null) {
                detailCubit.serviceDetail();
              }
            }
          },
          builder: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateLoading) {
              return const LoadingWidget();
            } else if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.detail != null) {
                return LoadedDetailView(model: detailCubit.detail!);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ServiceDetailStateLoaded) {
              return LoadedDetailView(model: state.detailModel);
            }

            if (detailCubit.detail != null) {
              return LoadedDetailView(model: detailCubit.detail!);
            } else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedDetailView extends StatefulWidget {
  const LoadedDetailView({super.key, required this.model});

  final ServiceModel model;

  @override
  State<LoadedDetailView> createState() => _LoadedDetailViewState();
}

class _LoadedDetailViewState extends State<LoadedDetailView> {
  late ServiceDetailCubit detailCubit;
  late PaymentCubit paymentCubit;

  late ServiceModel? model;

  @override
  void initState() {
    detailCubit = context.read<ServiceDetailCubit>();
    paymentCubit = context.read<PaymentCubit>();
    model = detailCubit.detail;
    paymentCubit..currentIndex(0)..serviceId(model?.servicePackage?.id??0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///service header start

            ServiceImageSection(service: model?.service),
            ///service header end

            ServiceSellerInfo(detail: model),

            ///service detail start
            CommonContainer(
              margin: Utils.only(bottom: 25.0),
              padding: Utils.symmetric(v: 20.0),
              radius: Utils.borderRadius(r: 8.0),
              child: BlocBuilder<ServiceDetailCubit, ReviewModel>(
                builder: (context, state) {
                  String displayText = model?.service?.description ?? '';
                  String appHexColor = "#${primaryColor.value.toRadixString(16).substring(2).toUpperCase()}";
                  String moreStyle = 'style="color: $appHexColor; font-weight: bold; text-decoration: none;"';

                  if (!state.readMore && displayText.length > 150) {
                    displayText = '${displayText.substring(0, 150)}...'
                        '<a href="#" $moreStyle>${Utils.translatedText(context, 'Read More')}</a>';
                  } else {
                    displayText = '${model?.service?.description ?? ''}' // Full text
                        '<a href="#" $moreStyle>${Utils.translatedText(context, 'Less Read')}</a>'; // Inline "Less Read"
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: model?.service?.title ?? '',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        maxLine: 2,
                      ),
                      Utils.verticalSpace(14.0),
                      HtmlWidget(
                        displayText,
                        onTapUrl: (url) {
                          detailCubit.readMore();
                          return true;
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            ///service detail end
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                color: Color(0xFFEDEBE7),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<PaymentCubit,CurrenciesModel>(
                  builder: (context,state){
                    return Row(
                      children: List.generate(
                        tabTitle(context).length,
                            (index) {
                          final active = state.id  == index;
                          return GestureDetector(
                            onTap: () => paymentCubit.currentIndex(index),
                            // onTap: () => setState(() => _currentIndex = index),
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: active ? primaryColor : transparent, width: 2))),
                              duration: const Duration(seconds: 0),
                              padding: Utils.symmetric(v: 12.0, h: 23.0),
                              child: CustomText(
                                text: tabTitle(context)[index],
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: blackColor,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            if (model?.servicePackage != null) ...[
              PackageCard(package: model?.servicePackage),
            ],
            Utils.verticalSpace(20.0),

            CustomText(
              text: Utils.translatedText(context, 'Reviews'),
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            ),
            Utils.verticalSpace(8.0),
            Row(
              children: [
                Container(
                  width: Utils.hSize(90.0),
                  height: Utils.vSize(110.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: whiteColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: model?.service?.avgRating.toStringAsFixed(1) ??
                            '0.0',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text:
                            "${model?.service?.totalRating} ${Utils.translatedText(context, 'Reviews')}",
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
                Utils.horizontalSpace(10.0),
                Expanded(
                  child: Column(
                    children: model?.ratingData?.entries.map((entry) {
                          return buildRatingBar(entry.key, entry.value);
                        }).toList() ??
                        [],
                  ),
                ),
              ],
            ),
            if (model?.reviews?.isNotEmpty ?? false) ...[
              Utils.verticalSpace(20.0),
              Column(
                  children: List.generate(model?.reviews?.length ?? 0,
                      (index) => ReviewItems(model: model?.reviews?[index]))),
            ],
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.1),

          ],
        ),
      ),
    );
  }
}

List<String> tabTitle(BuildContext context) => [
      Utils.translatedText(context, 'Basic'),
      Utils.translatedText(context, 'Standard'),
      Utils.translatedText(context, 'Premium')
    ];

Widget buildRatingBar(String star, ReviewModel review) {
  return Row(
    children: [
      CustomText(text: '$star★'),
      Utils.horizontalSpace(8.0),
      Expanded(
        child: LinearProgressIndicator(
          value: review.percentage / 100.0,
          backgroundColor: Colors.grey[300],
          color: primaryColor,
          minHeight: 8,
        ),
      ),
      Utils.horizontalSpace(8.0),
      CustomText(text: '(${review.count})'),
    ],
  );
}
