import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/review_item.dart';
import '../../service_screen/service_details_screen.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceCubit = context.read<ServiceDetailCubit>();
    return Column(
      children: [
        Utils.verticalSpace(20.0),
         CustomText(
          text: Utils.translatedText(context, 'Reviews'),
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
        ),
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
                    text: serviceCubit.sellerService?.avgRatings.toStringAsFixed(2) ??
                        '0.0',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text:
                    "${serviceCubit.sellerService?.totalRatings??0} ${Utils.translatedText(context, 'Reviews')}",
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            Utils.horizontalSpace(10.0),
            Expanded(
              child: Column(
                children: serviceCubit.sellerService?.ratingData?.entries.map((entry) {
                  return buildRatingBar(entry.key, entry.value);
                }).toList() ??
                    [],
              ),
            ),
          ],
        ),
        Utils.verticalSpace(20.0),
        if (serviceCubit.sellerService?.reviews?.isNotEmpty ?? false) ...[
          Column(
              children: List.generate(serviceCubit.sellerService?.reviews?.length ?? 0,
                      (index) => ReviewItems(model: serviceCubit.sellerService?.reviews?[index]))),
        ],
      ],
    );
  }
}
