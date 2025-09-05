import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/models/service/review_model.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/service/service_item.dart';
import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_image.dart';

class ServiceImageSection extends StatelessWidget {
  const ServiceImageSection({super.key, this.service});

  final ServiceItem? service;

  @override
  Widget build(BuildContext context) {
    final sdCubit = context.read<ServiceDetailCubit>();
    return CommonContainer(
      margin: Utils.all(),
      padding: Utils.all(value: 10.0),
      radius: Utils.borderRadius(r: 8.0),
      child: SizedBox(
        height: Utils.mediaQuery(context).height * 0.33,
        child: Stack(
          children: [
            PageView.builder(
                itemCount: sdCubit.galleries?.length,
                onPageChanged: sdCubit.carouselId,
                itemBuilder: (context,index){
                  final img = sdCubit.galleries?[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CustomImage(
                        path: RemoteUrls.imageUrl((img?.isNotEmpty ?? false)
                            ? img ?? Utils.defaultImg(context, false)
                            : Utils.defaultImg(context, false)),
                        fit: BoxFit.fill),
                  );
                }),
            if((sdCubit.galleries?.length ?? 0) > 1)...[
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 10.0,
                child: _buildDotIndicator(context),
              ),
            ]
          ],
        ),
      ),
    );
  }
  Widget _buildDotIndicator(BuildContext context) {
  final sdCubit = context.read<ServiceDetailCubit>();
    return BlocBuilder<ServiceDetailCubit, ReviewModel>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (sdCubit.galleries?.length ?? 0),
                (index) {
              final i = state.listingId == index;
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: Utils.vSize(6.0),
                width: Utils.hSize(i ? 24.0 : 6.0),
                margin: const EdgeInsets.only(right: 4.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  // color: i ? primaryColor : primaryColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(i ? 50.0 : 5.0),
                  //shape: i ? BoxShape.rectangle : BoxShape.circle,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
