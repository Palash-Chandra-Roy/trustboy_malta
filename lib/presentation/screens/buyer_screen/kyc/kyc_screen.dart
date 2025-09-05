import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../data/data_provider/remote_url.dart';
import '/presentation/widgets/custom_app_bar.dart';

import '../../../../data/models/kyc/kyc_model.dart';
import '../../../../logic/cubit/kyc/kyc_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/card_top_part.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/error_text.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/primary_button.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  late KycCubit kycCubit;
  KycItem? _kycItem;
  late String? type;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    kycCubit = context.read<KycCubit>();
    kycCubit.getKycInfo();
    _initKycInfo();

  }


  _initKycInfo(){
    if(kycCubit.kycModel?.kyc != null && (kycCubit.kycModel?.kycType?.isNotEmpty??false)){
      type = kycCubit.kycModel?.kycType?.where((e)=>e.id == kycCubit.kycModel?.kyc?.kycId).first.name;
    }else{
      type = 'None';
    }
  }

  String getKycStatus(int? id){
    if(id == 1){
      return 'Approved';
    } else if(id == 1){
      return 'Rejected';
    }else{
      return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'KYC Verifaction'),
      body: Utils.logout(
        child: BlocConsumer<KycCubit, KycItem>(
          listener: (context,states){
            final state = states.kycState;
            if(state is KycInfoError){
              if(state.statusCode == 401){
                Utils.logoutFunction(context);
              }
            }
          },
          builder: (context, state) {
            _initKycInfo();
            return ListView(
              children: [
                CardTopPart(title: 'KYC Verifaction',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0),),
                CommonContainer(
                  child: Column(
                    children: [

                      if(kycCubit.kycModel?.kyc == null)...[
                        CustomFormWidget(
                          label: Utils.translatedText(context, 'Document Type'),
                          bottomSpace: 24.0,
                          isRequired: true,
                          child: BlocBuilder<KycCubit, KycItem>(
                            builder: (context, state) {
                              final post = state.kycState;
                              if (state.kycId != 0 && (kycCubit.kycModel?.kycType?.isNotEmpty??false)) {
                                _kycItem = kycCubit.kycModel?.kycType?.where((e)=>e.id == state.kycId)
                                    .first;
                              } else {
                                _kycItem =  null;
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField<KycItem>(
                                    hint:  CustomText(text:Utils.translatedText(context, 'Document Type')),
                                    isDense: true,
                                    isExpanded: true,
                                    value: _kycItem,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border:  outlineBorder(),
                                        enabledBorder: outlineBorder(),
                                        focusedBorder: outlineBorder()
                                    ),
                                    borderRadius: Utils.borderRadius(r: 5.0),
                                    dropdownColor: whiteColor,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      kycCubit.kycType(value.id);
                                    },
                                    items: kycCubit.kycModel?.kycType?.isNotEmpty??false?kycCubit.kycModel?.kycType?.map<DropdownMenuItem<KycItem>>(
                                          (KycItem value) => DropdownMenuItem<KycItem>(
                                        value: value,
                                        child: CustomText(text: value.name),
                                      ),
                                    ).toList():[],
                                  ),
                                  if (post is KycSubmitFormError) ...[
                                    if (post.errors.kycId.isNotEmpty)
                                      ErrorText(text: post.errors.kycId.first),
                                  ]
                                ],
                              );
                            },
                          ),
                        ),

                        /*CustomFormWidget(
                    label: Utils.translatedText(context, 'Bank/Account Information'),
                    bottomSpace: 20.0,
                    child:  BlocBuilder<KycCubit, KycItem>(
                      builder: (context, state) {
                        final post = state.kycState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.message,
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                              onChanged: (String name) => kycCubit.kycMessage(name),
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Bank/Account Information',true),
                                  border:  outlineBorder(10.0),
                                  enabledBorder: outlineBorder(10.0),
                                  focusedBorder: outlineBorder(10.0)
                              ),
                              // inputFormatters: Utils.inputFormatter,
                            ),
                            // if (post is CreateWithdrawFormError) ...[
                            //   if (state.withdrawAmount.isNotEmpty)
                            //     if (post.errors.accountInfo.isNotEmpty)
                            //       ErrorText(text: post.errors.accountInfo.first),
                            // ]
                          ],
                        );
                      },
                    ),
                  ),*/

                        BlocBuilder<KycCubit, KycItem>(
                          builder: (context, state) {
                            //print('file ${state.file}');
                            final editState = state.kycState;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.file.isNotEmpty) ...[
                                  Stack(
                                    children: [
                                      if (state.file.endsWith('.jpg') ||
                                          state.file.endsWith('.jpeg') ||
                                          state.file.endsWith('.png')) ...[
                                        Container(
                                          height: Utils.hSize(180.0),
                                          margin: Utils.symmetric(v: 16.0, h: 0.0),
                                          width: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: Utils.borderRadius(),
                                            child: CustomImage(
                                              path: state.file,
                                              isFile: state.file.isNotEmpty,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 20,
                                          child: InkWell(
                                            onTap: () => kycCubit.kycFileClear(),
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
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius: Utils.borderRadius(r: 6.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: state.file.split('/').last,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              InkWell(
                                                onTap: () => kycCubit.kycFileClear(),
                                                child: const Icon(Icons.clear,
                                                    color: blackColor, size: 26.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  )
                                ] else ...[
                                  GestureDetector(
                                    onTap: () async {
                                      final image = await Utils.pickSingleFile();
                                      if (image != null && image.isNotEmpty) {
                                        kycCubit.kycFile(image);
                                      }
                                    },
                                    child: Container(
                                      height: Utils.hSize(50.0),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: Utils.borderRadius(),
                                      ),
                                      child: DottedBorder(
                                        padding: Utils.symmetric(v: 14.0),
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(Utils.radius(10.0)),
                                        color: primaryColor,
                                        dashPattern: const [6, 3],
                                        strokeCap: StrokeCap.square,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add_box_rounded,
                                              color: grayColor,
                                            ),
                                            Utils.horizontalSpace(5.0),
                                            CustomText(
                                              text: Utils.translatedText(context, 'Choose File'),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: grayColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                                if (editState is KycSubmitFormError) ...[
                                  if (editState.errors.file.isNotEmpty)
                                    ErrorText(text: editState.errors.file.first)
                                ],
                                Utils.verticalSpace(24.0),
                              ],
                            );
                          },
                        ),

                        Utils.verticalSpace(16.0),

                        BlocConsumer<KycCubit, KycItem>(
                          listener: (context, state) {
                            final s = state.kycState;
                            if (s is KycSubmitError) {
                              if(s.statusCode == 401){
                                Utils.logoutFunction(context);
                              }
                              Utils.errorSnackBar(context, s.message);
                            } else if (s is KycSubmitLoaded) {
                              Utils.showSnackBar(context, s.message, whiteColor, 2000);
                              Future.delayed(const Duration(milliseconds: 1000),(){
                                kycCubit.getKycInfo();
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          builder: (context, state) {
                            final s = state.kycState;
                            if (s is KycSubmitLoading) {
                              return const LoadingWidget();
                            }
                            return PrimaryButton(
                                text: Utils.translatedText(context, 'Send KYC Verifaction'),
                                onPressed: () {
                                  Utils.closeKeyBoard(context);
                                  kycCubit.submitKyc();
                                });
                          },
                        ),
                      ]else...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: Utils.vSize(100.0),
                              width: Utils.vSize(100.0),
                              alignment: Alignment.center,
                              margin: Utils.only(right: 10.0),
                              child: CustomImage(path: RemoteUrls.imageUrl(kycCubit.kycModel?.kyc?.file??''),fit: BoxFit.fill),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(text: type??Utils.translatedText(context, 'None'),fontSize: 16.0,fontWeight: FontWeight.w500),
                                  HtmlWidget(Utils.decodeHtmlEntities(kycCubit.kycModel?.kyc?.message??'',)),

                                  Chip(
                                      padding: Utils.all(),
                                      labelPadding: Utils.symmetric(h: 10.0),
                                      shape: RoundedRectangleBorder(side: const BorderSide(color: transparent),borderRadius: Utils.borderRadius(r: 20.0)),
                                      backgroundColor: kycCubit.kycModel?.kyc?.status == 1? greenColor.withOpacity(0.2):redColor.withOpacity(0.2),
                                      // labelPadding: Utils.all(),
                                      label: CustomText(
                                        color: kycCubit.kycModel?.kyc?.status == 1? greenColor:redColor,
                                        fontWeight: FontWeight.w500,
                                        text: Utils.translatedText(context, getKycStatus(kycCubit.kycModel?.kyc?.status)),
                                      )
                                  )

                                  // CustomText(
                                  //   text: kycCubit.kycModel?.kyc?.message??'',
                                  //   fontSize: 14.0,
                                  //   fontWeight: FontWeight.w600,
                                  //   maxLine: 2,
                                  // ),
                                  // Utils.verticalSpace(6.0),
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       context.read<ServiceDetailCubit>().addSlug(item.slug);
                                  //       Navigator.pushNamed(context, RouteNames.jobDetailsScreen);
                                  //     },
                                  //     child: CustomText(
                                  //       text: Utils.translatedText(context, 'Apply Now'),
                                  //       fontSize: 16.0,
                                  //     )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
