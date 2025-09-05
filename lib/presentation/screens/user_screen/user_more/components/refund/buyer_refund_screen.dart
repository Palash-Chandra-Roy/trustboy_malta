import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../utils/k_images.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../order/components/order_summary_widget.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/utils/language_string.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '/presentation/widgets/custom_text.dart';
import '/presentation/widgets/primary_button.dart';
import '../../../../../../data/models/refund/refund_item.dart';
import '../../../../../../logic/cubit/refund/refund_cubit.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/page_refresh.dart';

class BuyerRefundScreen extends StatefulWidget {
  const BuyerRefundScreen({super.key});

  @override
  State<BuyerRefundScreen> createState() => _BuyerRefundScreenState();
}

class _BuyerRefundScreenState extends State<BuyerRefundScreen> {

  late RefundCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<RefundCubit>();

    Future.microtask((){
      termCubit.getRefunds();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'Refund')),
      body: PageRefresh(
        onRefresh: () async {
          termCubit.getRefunds();
        },
        child: Utils.logout(
          child: BlocConsumer<RefundCubit, RefundItem>(
            listener: (context, service) {
              final state = service.refundState;
              if (state is RefundStateError) {
                if (state.statusCode == 503) {
                  termCubit.getRefunds();
                }

                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }
            },
            builder: (context, service) {
              final state = service.refundState;
              if (state is RefundLoading) {
                return const LoadingWidget();
              } else if (state is RefundStateError) {
                if (state.statusCode == 503) {
                  return RefundLoadedView(refunds: termCubit.refunds);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is RefundLoaded) {
                return RefundLoadedView(refunds: state.refunds);
              }
              if (termCubit.refunds.isNotEmpty) {
                return RefundLoadedView(refunds: termCubit.refunds);
              } else {
                return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          )
        ),
      ),
    );
  }
}

class RefundLoadedView extends StatelessWidget {
  const RefundLoadedView({super.key, required this.refunds});
  final List<RefundItem> refunds;

  @override
  Widget build(BuildContext context) {
    if(refunds.isNotEmpty){
       return Padding(
        padding: Utils.symmetric(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ...List.generate(refunds.length, (index) {
                final item = refunds[index];
                return Padding(
                  padding: Utils.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (index){
                        return  Dialog(
                          backgroundColor: whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      color: borderColor
                                  ),
                                  color: whiteColor
                              ),
                              child: Padding(
                                padding: Utils.symmetric(v: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(text: Utils.translatedText(context, 'Refund Details'),fontSize: 18.0,fontWeight: FontWeight.w600,),
                                    Utils.verticalSpace(8.0),
                                    _divider(),
                                    Utils.verticalSpace(8.0),
                                    OrderSummaryWidget(
                                      title: 'Order Id',
                                      value: item.orderId.toString(),
                                    ),
                                    Utils.verticalSpace(8.0),
                                    _divider(),
                                    Utils.verticalSpace(8.0),
                                    OrderSummaryWidget(
                                      title: 'Amount',
                                      value: Utils.formatAmount(context, item.refundAmount,2),
                                    ),
                                    Utils.verticalSpace(8.0),
                                    _divider(),
                                    Utils.verticalSpace(8.0),
                                    OrderSummaryWidget(
                                      title: 'Apply Date',
                                      value: Utils.timeWithData(item.createdAt,false),
                                    ),
                                    Utils.verticalSpace(8.0),
                                    _divider(),
                                    Utils.verticalSpace(8.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(text: Utils.translatedText(context, 'Status')),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: Colors.grey.withOpacity(0.3)),
                                          child: Padding(
                                            padding: Utils.symmetric(h: 8.0, v: 4.0),
                                            child:  CustomText(text: Utils.capitalizeFirstLetter(item.status)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Utils.verticalSpace(12.0),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(text: '${Utils.translatedText(context, 'Reason')}:',fontWeight: FontWeight.w500,),
                                        Utils.horizontalSpace(6.0),
                                        Expanded(
                                          child: CustomText(text: item.note,
                                            maxLine: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Utils.verticalSpace(12.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: whiteColor),
                      child: Padding(
                        padding: Utils.symmetric(v: 10.0),
                        child: Column(
                          children: [
                            // OrderSummaryWidget(
                            //   title: 'Order Id',
                            //   value: item.orderId.toString(),
                            // ),
                            // Utils.verticalSpace(8.0),
                            // _divider(),
                            Utils.verticalSpace(8.0),
                            OrderSummaryWidget(
                              title: 'Amount',
                              value: Utils.formatAmount(context, item.refundAmount,2),
                            ),
                            Utils.verticalSpace(8.0),
                            _divider(),
                            Utils.verticalSpace(8.0),
                            OrderSummaryWidget(
                              title: 'Apply Date',
                              value: Utils.timeWithData(item.createdAt,false),
                            ),
                            Utils.verticalSpace(8.0),
                            _divider(),
                            Utils.verticalSpace(8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(text: Utils.translatedText(context, 'Status')),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.grey.withOpacity(0.3)),
                                  child: Padding(
                                    padding: Utils.symmetric(h: 8.0, v: 4.0),
                                    child:  CustomText(text: Utils.capitalizeFirstLetter(item.status)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      );
    }else{
      return EmptyWidget(
      image: KImages.emptyImage,
      isSliver: false,
      height: Utils.mediaQuery(context).height * 0.8);
    }
  }



  Widget _divider() {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: gray5B.withOpacity(0.2),
    );
  }
}

