import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/widgets/custom_text.dart';
import '/presentation/widgets/primary_button.dart';

import '../../../../../data/models/refund/refund_item.dart';
import '../../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/card_top_part.dart';
import '../../../../widgets/common_container.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/loading_widget.dart';
import 'file_download_widget.dart';

class OrderFileSubmission extends StatefulWidget {
  const OrderFileSubmission({super.key});

  @override
  State<OrderFileSubmission> createState() => _OrderFileSubmissionState();
}

class _OrderFileSubmissionState extends State<OrderFileSubmission> {
  late BuyerOrderCubit orderCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    orderCubit = context.read<BuyerOrderCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         CardTopPart(title: 'File Submission',bgColor: primaryColor.withOpacity(0.3)),
         CommonContainer(
          margin: Utils.only(bottom: 20.0),
          child: Column(
            children: [
              BlocConsumer<BuyerOrderCubit, RefundItem>(

                listener: (context, state) {
                  final coupon = state.orderState;
                  if (coupon is BuyerFileSubmissionError) {
                    orderCubit.initPage();

                    Utils.errorSnackBar(context, coupon.message);
                  } else if (coupon is BuyerFileSubmitted) {
                    Utils.showSnackBar(context, coupon.message);
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      orderCubit
                        ..addFile('')
                        ..initPage()..getBuyerOrderDetail();
                      // orderCubit
                      //   ..initPage()
                      //   ..getProviderAllBookingList();
                      // orderCubit.isDownloadable(true);
                    });
                  }
                },
                builder: (context, state) {
                  String ? fileExtension = orderCubit.detail?.order?.submitFile.split('.').last ??'jpg';

                  debugPrint('file ${orderCubit.detail?.order?.submitFile}');
                  final editState = state.orderState;
                  final isEmptyField = state.createdAt.isNotEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(state.createdAt.isNotEmpty)...[
                        Stack(
                          children: [
                            if (state.createdAt.endsWith('.jpg') ||
                                state.createdAt.endsWith('.jpeg') ||
                                state.createdAt.endsWith('.png')) ...[
                              Container(
                                height: Utils.hSize(180.0),
                                margin: Utils.symmetric(v: 16.0, h: 0.0),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: Utils.borderRadius(),
                                  child: CustomImage(
                                    path: state.createdAt,
                                    isFile: state.createdAt.isNotEmpty,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10.0,
                                top: 20.0,
                                child: InkWell(
                                  onTap: () => orderCubit.kycFileClear(),
                                  child: const CircleAvatar(
                                    maxRadius: 16.0,
                                    backgroundColor: Color(0xff18587A),
                                    child: Icon(Icons.clear,
                                        color: Colors.white, size: 20.0),
                                  ),
                                ),
                              )
                            ] else ...[
                              Container(
                                padding: Utils.symmetric(v: 16.0, h: 10.0),
                                margin: Utils.only(bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: Utils.borderRadius(r: 30.0),
                                  border: Border.all(color: stockColor),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CustomText(
                                        text: state.createdAt.split('/').last,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        maxLine: 1,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => orderCubit.kycFileClear(),
                                      child: const Icon(Icons.clear,
                                          color: blackColor, size: 26.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),

                      ]else...[

                        GestureDetector(
                          onTap: () async {
                            final image = await Utils.pickSingleFile();
                            if (image != null && image.isNotEmpty) {
                              orderCubit.addFile(image);
                            }
                          },
                          child:  Container(
                            margin: Utils.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: Utils.borderRadius(r: 30.0),
                              border: Border.all(color: stockColor),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    padding: Utils.symmetric(h: 40.0,v: 12.0),
                                    margin: Utils.all(value: 4.0),
                                    decoration: BoxDecoration(
                                      color: scaffoldBgColor,
                                      borderRadius: Utils.borderRadius(r: 30.0),
                                    ),
                                    child: CustomText(text: Utils.translatedText(context, 'Choose File'),maxLine: 1),
                                  ),
                                ),
                                Flexible(child: CustomText(text: Utils.translatedText(context, 'No file chosen'),maxLine: 1)),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if(orderCubit.detail?.order?.submitFile.isNotEmpty??false)...[
                        FileDownloadWidget(id:  orderCubit.detail?.order?.submitFile??'' ,extension: fileExtension),
                        Utils.verticalSpace(10.0),
                      ],

                      if(editState is BuyerFileSubmitting)...[
                       const LoadingWidget(),
                      ]else...[
                        PrimaryButton(
                          text: Utils.translatedText(context, 'Submit Order'),
                          bgColor: isEmptyField ? primaryColor:grayColor,
                          borderColor: transparent,
                          onPressed: (){
                            // Utils.closeKeyBoard(context);
                            if (isEmptyField) {
                              orderCubit.fileSubmission();
                            }
                          },
                          buttonType: ButtonType.iconButton,
                          icon: const Icon(Icons.arrow_forward,color: whiteColor),minimumSize: const Size(double.infinity,42.0),)
                      ],

                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
