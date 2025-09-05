import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/utils/utils.dart';

import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/empty_widget.dart';
import '../../home/component/single_service.dart';

class ServiceTabScreen extends StatelessWidget {
  const ServiceTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceCubit = context.read<ServiceDetailCubit>();
    if (serviceCubit.sellerService?.sellerService?.isNotEmpty??false){
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Utils.mediaQuery(context).width,
              margin: Utils.only(top: 0.0),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                alignment:  WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  ...List.generate((serviceCubit.sellerService?.sellerService?.length ?? 0), (index) {
                    final item = serviceCubit.sellerService?.sellerService?[index];
                    if(item != null){
                      return SingleService(item: item ,width: Utils.mediaQuery(context).width * 0.45);
                    }else{
                      return const SizedBox.shrink();
                    }
                  }),
                  if((serviceCubit.sellerService?.sellerService?.length ?? 0) % 2 == 1)...[
                    SizedBox(width: Utils.mediaQuery(context).width * 0.45),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }else{
      return EmptyWidget(image: KImages.emptyImage,isSliver: false,height: Utils.mediaQuery(context).height * 0.8);
    }
  }

  GridView buildGridView(ServiceDetailCubit serviceCubit) {
    return GridView.builder(
    padding: Utils.only(bottom: 20.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.65,
    ),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: serviceCubit.detail?.sellerService?.length,
    itemBuilder: (context, int index) {
      return SingleService(item: serviceCubit.detail!.sellerService![index]);
    },
  );
  }
}
