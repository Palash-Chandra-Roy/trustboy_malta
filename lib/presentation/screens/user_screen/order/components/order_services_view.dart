import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../../routes/route_names.dart';
import '../../../../widgets/card_top_part.dart';
import '../../../../widgets/horizontal_line.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_text.dart';
import '/presentation/widgets/primary_button.dart';

import '../../../../../data/models/order/order_detail_model.dart';
import '../../../../utils/utils.dart';
import '../components/order_package_view.dart';
import '../components/order_summary_widget.dart';

class OrderServicesView extends StatelessWidget {
  const OrderServicesView({super.key,  required this.orders});
  final OrderDetail? orders;
  @override
  Widget build(BuildContext context) {

    final download = context.read<BuyerOrderCubit>();

    int getIndex(String? package){
      if(package?.isNotEmpty??false){
        if(package == 'Basic'){
          return 0;
        } else if(package == 'Standard'){
          return 1;
        } else if(package == 'Premium'){
          return 2;
        }else{
          return 0;
        }
      }else{
        return 0;
      }
    }
    return Container(
      margin: Utils.symmetric(h: 0.0,v: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CardTopPart(title: 'Service & Package Information',bgColor: primaryColor.withOpacity(0.3)),

          Padding(
            padding: Utils.symmetric(v: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Utils.translatedText(context, 'Service & Package'),
                  fontSize: 16,
                ),
                HorizontalLine(color: gray5B,margin: Utils.symmetric(h: 0.0,v: 10.0)),
                OrderSummaryWidget(
                  title: "Service",
                  value: orders?.order?.listing?.title??'',
                  maxLine: 4,
                  flex: 2,
                  textColor: blueColor,
                  onTap: (){
                    if(orders?.order?.listing?.slug.isNotEmpty??false){
                      context.read<ServiceDetailCubit>()..addType('service')..addSlug(orders?.order?.listing?.slug??'');
                      Navigator.pushNamed(context, RouteNames.serviceDetailsScreen);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(text: '${Utils.translatedText(context, 'Package')}:'),
                    if (orders?.order?.listing?.listingPackage != null) ...[
                      Utils.horizontalSpace(20.0),
                      Flexible(child: OrderPackageView(index: getIndex(orders?.order?.packageName), package: orders?.order?.listing?.listingPackage)),
                    ],

                  ],
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //      CustomText(text: '${Utils.translatedText(context, 'Package')}:'),
                //     if (orders?.order?.listing?.listingPackage != null) ...[
                //       DetailPackageCard(index: getIndex(orders?.order?.packageName), package: orders?.order?.listing?.listingPackage),
                //     ],
                //   ],
                // ),

                if((orders?.order?.submitFile.isNotEmpty??false) && !Utils.isSeller(context))...[
                  Utils.verticalSpace(10.0),
                  PrimaryButton(
                      minimumSize: const Size(double.infinity, 42.0),
                      text: Utils.translatedText(context, 'Download File'),
                      onPressed: () async{
                        if(orders?.order?.submitFile.isNotEmpty??false){

                          String ? ext = orders?.order?.submitFile.split('.').last??'';

                          bool permissionGranted = await Utils.getStoragePermission();
                          if (permissionGranted) {
                            final result = await download.chatFileDownload(orders?.order?.submitFile??'',ext);

                            result.fold((failure) {
                              Utils.errorSnackBar(context, Utils.translatedText(context, 'Something went wrong'));
                            }, (success) {
                                if (success) {
                                  Utils.showSnackBar(context, Utils.translatedText(context, 'Successfully file downloaded'));
                                } else {
                                  Utils.errorSnackBar(context, Utils.translatedText(context, 'File download failed.'));
                                }
                               },
                            );
                          }
                          else {
                            Utils.errorSnackBar(context, Utils.translatedText(context, 'Storage permission is required to download files.'));
                          }
                        }
                      },
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}
