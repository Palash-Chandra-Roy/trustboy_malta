import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/utils/k_images.dart';
import '/presentation/widgets/common_container.dart';
import '/presentation/widgets/custom_image.dart';

import '../../../../../data/models/refund/refund_item.dart';
import '../../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';

class EmptyOrder extends StatelessWidget {
  const EmptyOrder({super.key, this.empty, this.isShowSub});
  final String ? empty;
  final bool ? isShowSub;

  @override
  Widget build(BuildContext context) {
    final emptyList = [
      'You do not have any order',
      'You do not have any active order',
      'You do not have any awaiting order',
      'You do not have any rejected order',
      'You do not have any cancel order',
      'You do not have any complete order',
    ];

    return SliverToBoxAdapter(
      child: BlocBuilder<BuyerOrderCubit, RefundItem>(
        builder: (context, state) {
          return CommonContainer(
            padding: Utils.symmetric(v: 40.0),
            margin: Utils.symmetric(v: Utils.mediaQuery(context).height / 5.5)
                .copyWith(bottom: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomImage(path: KImages.emptyOrder),
                Utils.verticalSpace(10.0),
                CustomText(
                  text: Utils.translatedText(context, empty?? 'Order Empty'),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                if(isShowSub??true)...[
                  Utils.verticalSpace(10.0),
                  CustomText(
                      text:
                      Utils.translatedText(context, emptyList[state.buyerId]),
                      textAlign: TextAlign.center),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
