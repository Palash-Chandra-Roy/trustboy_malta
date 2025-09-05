import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/primary_button.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_app_bar.dart';

import '../../../../data/models/order/order_detail_model.dart';
import '../../../../data/models/refund/refund_item.dart';
import '../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../utils/utils.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/page_refresh.dart';
import 'components/order_basic_info_view.dart';
import 'components/order_buyer_info.dart';
import 'components/order_file_submission.dart';
import 'components/order_services_view.dart';

class BuyerSellerOrderDetails extends StatefulWidget {
  const BuyerSellerOrderDetails({super.key});

  @override
  State<BuyerSellerOrderDetails> createState() => _BuyerSellerOrderDetailsState();
}

class _BuyerSellerOrderDetailsState extends State<BuyerSellerOrderDetails> {

  late BuyerOrderCubit orderCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    orderCubit = context.read<BuyerOrderCubit>();
    Future.microtask((){orderCubit.getBuyerOrderDetail();});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: Utils.translatedText(context, 'Order Details')),
      body: PageRefresh(
        onRefresh: () async {
          orderCubit.getBuyerOrderDetail();
        },
        child: Utils.logout(
          child: BlocConsumer<BuyerOrderCubit, RefundItem>(
            listener: (context, service) {
              final state = service.orderState;
              if (state is BuyerOrderDetailError) {
                if (state.statusCode == 503 || orderCubit.detail == null && state.statusCode != 403) {
                  orderCubit.getBuyerOrderDetail();
                }
                if(state.statusCode == 401){
                  Utils.logoutFunction(context);
                }
              }

              if(service.isListen){
                if (state is BuyerOrderDeleteLoading) {
                  Utils.loadingDialog(context);
                } else {
                  Utils.closeDialog(context);
                  if (state is BuyerOrderDeleteError) {
                    Utils.errorSnackBar(context, state.message);
                  } else if (state is BuyerOrderDeleteLoaded) {

                    Utils.showSnackBar(context, state.message);

                    Future.delayed(const Duration(milliseconds: 800), () {
                      orderCubit
                        ..getBuyerOrder()
                        ..initPage()
                        ..getBuyerOrderDetail();
                    });

                  }
                }
              }

            },
            builder: (context, service) {
              final state = service.orderState;
              if (state is BuyerOrderDetailsLoading) {
                return const LoadingWidget();
              } else if (state is BuyerOrderDetailError) {
                if (state.statusCode == 403) {
                  return FetchErrorText(text: state.message);
                }

                if (state.statusCode == 503 || orderCubit.detail != null) {
                  return LoadedOrderDetail(orders: orderCubit.detail);
                } else {
                  return FetchErrorText(text: state.message);
                }

              } else if (state is BuyerOrderDetailsLoaded) {
                return LoadedOrderDetail(orders: state.detail);
              }
              if (orderCubit.orders != null) {
                return LoadedOrderDetail(orders: orderCubit.detail);
              } else {
                return FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BlocBuilder<BuyerOrderCubit, RefundItem>(
      builder: (context, states) {
        final state = states.orderState;
        if(state is BuyerOrderDetailsLoading){
          return const SizedBox.shrink();
        }else if(state is BuyerOrderDetailError){
          if(state.statusCode  != 403){
            return _bottomButtons(context);
          }else{
            return const SizedBox.shrink();
          }
        }else if(state is BuyerOrderDetailsLoaded && Utils.orderAction(context, orderCubit.detail?.order)){
          // debugPrint('action-result ${Utils.orderAction(context, orderCubit.detail?.order)}');
          return _bottomButtons(context);
        }else if(orderCubit.detail != null && Utils.orderAction(context, orderCubit.detail?.order)){
          // debugPrint('action-result ${Utils.orderAction(context, orderCubit.detail?.order)}');
          return _bottomButtons(context);
        }else if(state is BuyerOrderDetailsLoaded && Utils.orderAction(context, orderCubit.detail?.order,false)){
          // debugPrint('action-result ${Utils.orderAction(context, orderCubit.detail?.order)}');
          return _cancelOrder(context);
        }else if(orderCubit.detail != null &&  Utils.orderAction(context, orderCubit.detail?.order,false)){
          // debugPrint('action-result ${Utils.orderAction(context, orderCubit.detail?.order)}');
          return _cancelOrder(context);
        } else if(orderCubit.detail != null && Utils.refundOrder(context, orderCubit.detail)){
          //debugPrint('refund-result ${Utils.refundOrder(context, orderCubit.detail)}');
          return _refundButton(context);
        }else if(state is BuyerOrderDetailsLoaded && Utils.refundOrder(context, orderCubit.detail)){
          //debugPrint('refund-result ${Utils.refundOrder(context, orderCubit.detail)}');
          return _refundButton(context);
        }else{
          return const SizedBox.shrink();
        }

      },
    );
  }

  Widget _bottomButtons(BuildContext context) {

    String getButtonText([bool isPositive = true]){
      if(isPositive){
        if (Utils.isSeller(context)){
          return Utils.translatedText(context, 'Approved Now');
        }else{
          return Utils.translatedText(context, 'Complete Order');
        }
      }else{
        if (Utils.isSeller(context)){
          return Utils.translatedText(context, 'Rejected Order');
        }else{
          return Utils.translatedText(context, 'Cancel Order');
        }
      }
    }

    String getMessageText([bool isPositive = true]){
        if(isPositive){
          if (Utils.isSeller(context)){
            return Utils.translatedText(context, 'Are you realy want to approved this item?');
          }else{
            return Utils.translatedText(context, 'Are you realy want to approved this item?');
          }
        }else{
          if (Utils.isSeller(context)){
            return Utils.translatedText(context, 'Are you really want to rejected the order?');
          }else{
            return Utils.translatedText(context, 'Are you realy want to cancel this item?');
          }
        }
    }

    return Container(
      padding: Utils.symmetric(v: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PrimaryButton(
              text: getButtonText(),
              onPressed: (){

                     showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ConfirmDialog(
                        image: const CustomImage(path: KImages.successOrder),
                        bgColor: whiteColor,
                        confirmHeading: getButtonText(),
                        message: getMessageText(),
                        confirmText: Utils.translatedText(context, Utils.isSeller(context)?'Yes, Appoved It':'Yes, Complete It'),
                        //Delete Confirmation
                        onTap: (){
                          // Navigator.of(context).pop();
                          Navigator.pop(context);
                          orderCubit.orderAction(OrderType.accept);
                        },
                      ),
                );

              },

            ),
          ),
          Utils.horizontalSpace(10.0),
          Expanded(
            child: PrimaryButton(
              text: getButtonText(false),
              onPressed: (){

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ConfirmDialog(
                    image: const CustomImage(path: KImages.deleteIcon,color: whiteColor),
                    bgColor: redColor,
                    confirmHeading: getButtonText(false),
                    message: getMessageText(false),
                    confirmText: Utils.translatedText(context, Utils.isSeller(context)?'Yes, Rejected It' : 'Yes, Cancel It'),
                    //Delete Confirmation
                    onTap: (){
                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                      orderCubit.orderAction(Utils.isSeller(context)? OrderType.reject:OrderType.cancel);
                    },
                  ),
                );

              },
              bgColor: redColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancelOrder(BuildContext context) {

    return Container(
      padding: Utils.symmetric(v: 20.0),
      child: PrimaryButton(
        text: Utils.translatedText(context, 'Cancel Order'),
        onPressed: (){

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ConfirmDialog(
              image: const CustomImage(path: KImages.deleteIcon,color: whiteColor),
              bgColor: redColor,
              confirmHeading: '${Utils.translatedText(context, 'Cancel Order')}?',
              message: Utils.translatedText(context, 'Are you really want to cancel the order?'),
              confirmText: Utils.translatedText(context, 'Yes, Cancel It'),
              //Delete Confirmation
              onTap: (){
                Navigator.pop(context);
                // debugPrint('cancel-order');
                orderCubit.orderAction(OrderType.cancel);
              },
            ),
          );

        },
        bgColor: redColor,
      ),
    );
  }

  Widget _refundButton(BuildContext context) {
    final isRefund = orderCubit.detail?.refund == null;
    return Container(
      padding: Utils.symmetric(v: 20.0),
      child: PrimaryButton(
          onPressed: (){
            if(isRefund){
              orderCubit..isListen(false)..addRefundNote('');
              refReq(context);
            }else{
              refundDetail(context,orderCubit.detail?.refund);
            }

          }, text: Utils.translatedText(context, isRefund? 'Refund Request':'Refund Details')),
    );
  }

  void refReq(BuildContext context) {

    Utils.showCustomDialog(
      bgColor: grayBackgroundColor,
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
                    text: Utils.translatedText(context, 'Refund Request'),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                        orderCubit.isListen(true);
                      },
                      child: const Icon(Icons.clear, color: redColor)),
                ],
              ),
              Utils.verticalSpace(14.0),
              BlocBuilder<BuyerOrderCubit, RefundItem>(
                builder: (context, state) {
                  return CustomFormWidget(
                    label: Utils.translatedText(context, 'Write your reason'),
                    bottomSpace: 14.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.note,
                          onChanged: orderCubit.addRefundNote,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Write your reason',true),
                              border:  outlineBorder(10.0),
                              enabledBorder: outlineBorder(10.0),
                              focusedBorder: outlineBorder(10.0)
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                        ),
                        // if (amount is CouponAddUpdateFormError) ...[
                        //   if (amount.errors.offer.isNotEmpty)
                        //     ErrorText(text: amount.errors.offer.first)
                        // ]
                      ],
                    ),
                  );
                },
              ),

              BlocBuilder<BuyerOrderCubit, RefundItem>(
                builder: (context, state) {
                  final isEmptyField = state.note.trim().isNotEmpty;
                  return PrimaryButton(
                      text: Utils.translatedText(context, 'Submit Request'),
                      bgColor: isEmptyField ? primaryColor : grayColor,
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        if (isEmptyField) {
                          Navigator.of(context).pop();
                          orderCubit..isListen(true)..orderAction(OrderType.refund);
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

  refundDetail(BuildContext context,RefundItem ? item){
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
                    text: Utils.translatedText(context, 'Refund Details'),
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
                    WithdrawKeyValue(title: 'Amount',value: Utils.formatAmount(context, item?.refundAmount)),
                    WithdrawKeyValue(title: 'Apply Date',value: Utils.timeWithData(item?.createdAt??'',false)),
                    WithdrawKeyValue(title: 'Reason',value: item?.note??'',maxLine: 4),
                    WithdrawKeyValue(title: 'Status',value: Utils.capitalizeFirstLetter(item?.status??''),showDivider: false),
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

class LoadedOrderDetail extends StatelessWidget {

  const LoadedOrderDetail({super.key, required this.orders});

  final OrderDetail? orders;

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: Utils.symmetric(),
      child: ListView(
        children: [
          OrderBasicInfoView(orders:orders),
          OrderServicesView(orders: orders),
          if(Utils.isSeller(context) && orders?.order?.approvedBySeller == 'approved')...[
            const OrderFileSubmission(),
          ],
          if(Utils.isSeller(context))...[
            OrderBuyerInfo(seller: orders?.buyer,order: orders),
          ]else...[
            OrderBuyerInfo(seller: orders?.seller,order: orders),
          ],
          Utils.verticalSpace(20.0),
        ],
      ),
    );
  }
}