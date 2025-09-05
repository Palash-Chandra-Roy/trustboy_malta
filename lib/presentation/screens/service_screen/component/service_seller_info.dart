import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/widgets/loading_widget.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/chat/message_model.dart';
import '../../../../data/models/refund/refund_item.dart';
import '../../../../data/models/service/service_model.dart';
import '../../../../logic/cubit/chat/chat_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/circle_image.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/primary_button.dart';
import '../../seller/seller_details_screen.dart';

class ServiceSellerInfo extends StatelessWidget {
  const ServiceSellerInfo({super.key, this.detail,this.margin,this.isExpand});

  final ServiceModel? detail;
  final EdgeInsets? margin;
  final bool? isExpand;

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    return CommonContainer(
      margin: margin ?? Utils.symmetric(h: 0.0, v: 25.0),
      padding: Utils.symmetric(h: 10.0),
      radius: Utils.borderRadius(r: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: transparent,
            shadowColor: transparent,
            splashColor: transparent,
            splashFactory: NoSplash.splashFactory),
        child: ExpansionTile(
          childrenPadding: Utils.symmetric(h: 0.0,v: 16.0),
          tilePadding: Utils.all(),
          initiallyExpanded: isExpand ?? false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleImage(
                  size: 76.0,
                  type: ImageType.rectangle,
                  radius: 4.0,
                  fit: BoxFit.fill,
                  image: RemoteUrls.imageUrl(
                      (detail?.seller?.image.isNotEmpty ?? false)
                          ? detail?.seller?.image ?? Utils.defaultImg(context)
                          : Utils.defaultImg(context))),
              Utils.horizontalSpace(10.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: CustomText(
                              text: detail?.seller?.name ?? 'No name found',
                              color: blackColor,
                              fontSize: 16.0,
                              maxLine: 1,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (detail?.seller?.kycStatus == 1) ...[
                            Padding(
                              padding: Utils.only(left: 6.0, bottom: 2.0),
                              child: const Icon(
                                Icons.verified,
                                color: primaryColor,
                                size: 16.0,
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                    if (detail?.seller?.designation.isNotEmpty ?? false) ...[
                      Utils.verticalSpace(4.0),
                      CustomText(
                        text: detail?.seller?.designation ??
                            Utils.translatedText(context, 'Not found'),
                        color: gray5B,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    Utils.verticalSpace(4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Padding(
                                padding: Utils.only(bottom: 2.0, right: 2.0),
                                child: const Icon(
                                  Icons.star,
                                  color: blackColor,
                                  size: 16.0,
                                ),
                              ),
                              Flexible(
                                  child: CustomText(
                                text:
                                    '${detail?.seller?.avgRating ?? 0.0} (${detail?.seller?.totalRating ?? 0} ${Utils.translatedText(context, 'Reviews')})',
                                color: gray5B,
                                maxLine: 1,
                              )),
                            ],
                          ),
                        ),
                        if(detail?.seller?.isTopSeller == 'enable')...[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: Utils.borderRadius(r: 20.0),
                                color: stockColor,
                              ),
                              child: Padding(
                                padding: Utils.symmetric(v: 4.0, h: 6),
                                child: CustomText(
                                  fontSize: 10.0,
                                  color: gray5B,
                                  maxLine: 1,
                                  text:
                                  Utils.translatedText(context, 'Top Seller'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: Utils.borderRadius(r: 4.0),
                  color: scaffoldBgColor),
              child: Padding(
                padding: Utils.symmetric(v: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    sellerJobInfo(context,'Service','${detail?.totalService}'),
                    sellerJobInfo(context,'Rate',"${Utils.formatAmount(context, detail?.seller?.hourlyPayment ?? 0.0)}/${Utils.translatedText(context, 'hr')}"),
                    sellerJobInfo(context,'Jobs','${detail?.totalJobDone}'),
                  ],
                ),
              ),
            ),
           if(isExpand??false)...[
             Utils.verticalSpace(16.0),
             SummaryWidget(
               title: Utils.translatedText(context, 'Location'),
               value: detail?.seller?.address ?? '',
             ),
             SummaryWidget(
               title: Utils.translatedText(context, 'Member Since'),
               value: Utils.timeWithData(detail?.seller?.createdAt ?? '', false),
             ),
             SummaryWidget(
               title: Utils.translatedText(context, 'Gender'),
               value: detail?.seller?.gender ?? '',
             ),
             SummaryWidget(
               title: Utils.translatedText(context, 'Language'),
               value: formatLanguage(detail?.seller?.language),
             ),
             SummaryWidget(
               title: Utils.translatedText(context, 'Skills'),
               value: formatLanguage(detail?.seller?.skills),
             ),
           ],

            if(Utils.isAddon(context)?.liveChat == true)...[
              Utils.verticalSpace(10.0),
              PrimaryButton(
                text: Utils.translatedText(context, 'Send Message'),
                onPressed: () {
                 if(Utils.isLoggedIn(context)){
                   if(detail?.service?.sellerId != 0 && detail?.service?.id != 0){
                     chatCubit..addMessage('')..sellerId(detail?.service?.sellerId??0)..serviceId(detail?.service?.id??0);
                     sendMessage(context);
                   }
                 }else{
                   Utils.showSnackBarWithLogin(context);
                 }
                },
                minimumSize: const Size(double.infinity, 44.0),
                bgColor: blackColor,
                borderRadiusSize: 40.0,
                textColor: whiteColor,
                fontWeight: FontWeight.w600,
                borderColor: transparent,
                fontSize: 14.0,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void sendMessage(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
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
                    text: Utils.translatedText(context, 'Send Message'),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                        // orderCubit.isListen(true);
                      },
                      child: const Icon(Icons.clear, color: redColor)),
                ],
              ),
              Utils.verticalSpace(14.0),
              BlocBuilder<ChatCubit, MessageModel>(
                builder: (context, state) {
                  return CustomFormWidget(
                    label: Utils.translatedText(context, 'Message'),
                    bottomSpace: 14.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.message,
                          onChanged: chatCubit.addMessage,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Type your message',true),
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

              BlocConsumer<ChatCubit, MessageModel>(
                listener: (context,message){
                  final state = message.chatState;
                      if (state is SupportMessageError) {
                        Utils.errorSnackBar(context, state.message);
                      } else if (state is SupportMessaged) {

                        Navigator.of(context).pop();

                        Utils.showSnackBar(context, state.ticket);

                        chatCubit..initState()..addMessage('')..serviceId(0);

                        WidgetsBinding.instance.addPostFrameCallback((_){
                          Navigator.pushNamed(context,RouteNames.chatScreen);
                        });
                  }
                },
                builder: (context, message) {
                  final state = message.chatState;
                  final isEmptyField = message.message.trim().isNotEmpty;
                  if (state is SupportMessaging){
                    return LoadingWidget();
                  }
                  return PrimaryButton(
                      text: Utils.translatedText(context, 'Send Message'),
                      bgColor: isEmptyField ? primaryColor : grayColor,
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        if (isEmptyField) {
                          // Navigator.pop(context);
                          chatCubit.sendTicketMessage();
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
Widget sellerJobInfo(BuildContext context,String title,String value) {
  return Flexible(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: CustomText(text: Utils.translatedText(context, title), fontSize: 14.0,color: blackColor,maxLine: 1)),
        Utils.verticalSpace(12.0),
        Flexible(
          child: CustomText(
            text: value,
            fontSize: 14.0,
            color: gray5B,
            maxLine: 2,
          ),
        ),
      ],
    ),
  );
}

String formatLanguage(String? languageJson) {
  List<dynamic> languages = Utils.parseJsonToString(languageJson);
  return languages.isNotEmpty ? languages.join(', ') : '';
}
