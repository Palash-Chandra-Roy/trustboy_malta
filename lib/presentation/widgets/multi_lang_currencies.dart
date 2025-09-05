import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/logic/cubit/dashboard/dashboard_cubit.dart';

import '../../../../logic/cubit/currency/currency_state_model.dart';

import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../../logic/cubit/currency/currency_cubit.dart';
import '../../data/models/auth/login_state_model.dart';
import '../../data/models/setting/currencies_model.dart';
import '../../data/models/setting/languages_model.dart';
import '../../logic/cubit/home/home_cubit.dart';
import '../../logic/cubit/setting/setting_cubit.dart';
import 'custom_image.dart';
import 'custom_text.dart';
import '../utils/constraints.dart';
import '../utils/k_images.dart';
import '../utils/utils.dart';


class MultiLanguage extends StatefulWidget {
  const MultiLanguage({super.key, this.isLanguage});

  final bool? isLanguage;

  @override
  State<MultiLanguage> createState() => _MultiLanguageState();
}

class _MultiLanguageState extends State<MultiLanguage> {
  late SettingCubit websiteCubit;
  late LoginBloc loginBloc;
  late CurrencyCubit cCubit;

  CurrenciesModel? currency;

  LanguagesModel? language;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    loginBloc = context.read<LoginBloc>();
    websiteCubit = context.read<SettingCubit>();
    cCubit = context.read<CurrencyCubit>();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLanguage ?? true) {
      return BlocListener<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingStateLoading) {
            Utils.loadingDialog(context);
          } else {
            Utils.closeDialog(context);
            if (state is SettingStateError) {
              if (state.statusCode == 503) {
                if (cCubit.state.languages.isNotEmpty) {
                  //websiteCubit.loadWebSetting(cCubit.state.languages.first.langCode);
                } else {
                  //websiteCubit.loadWebSetting(loginBloc.state.langCode);
                }
              } else {
                Utils.errorSnackBar(context, state.message);
              }
            }
          }
        },
        child: BlocBuilder<LoginBloc, LoginStateModel>(
          builder: (context, state) {
            if(state.langCode.isNotEmpty && (websiteCubit.settingModel?.languageList?.isNotEmpty??false)){
              // debugPrint('login.langCode ${state.langCode}');
              language = websiteCubit.settingModel?.languageList?.where((e)=>e.langCode == state.langCode).first;
            }else if(cCubit.state.languages.isNotEmpty){
              // debugPrint('cCubit.langCode ${cCubit.state.languages.first.langCode}');
              language = cCubit.state.languages.first;
            }
            return Column(
              children: [
                Row(
                  children: [
                    titleIcon('Languages',KImages.languageIcon),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 3,
                        child: DropdownButtonFormField<LanguagesModel>(
                        dropdownColor: whiteColor,
                        isDense: true,
                        isExpanded: true,
                        value: language,

                        decoration: const InputDecoration(
                          filled: false,
                          fillColor: transparent,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                          borderRadius: Utils.borderRadius(r: 5.0),

                          hint:  CustomText(
                          text: Utils.translatedText(context, 'Select Language'),
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: blackColor,
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_sharp,
                            color: blackColor),
                        items:
                            websiteCubit.settingModel?.languageList?.isNotEmpty ??
                                    false
                                ? websiteCubit.settingModel?.languageList
                                    ?.map<DropdownMenuItem<LanguagesModel>>(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // Container(
                                            //   height: 35.0,
                                            //   margin: Utils.only(right: 10.0),
                                            //   child:  const CustomImage(path: KImages.languageIcon,fit: BoxFit.fill),
                                            //   // child:  CustomImage(path: 'https://flagsapi.com/${e.langName}/flat/64.png',fit: BoxFit.fill),
                                            // ),
                                            // const Spacer(flex: 1),
                                            Flexible(
                                              flex: 2,
                                                child: CustomText(
                                                text: e.langName,
                                                // text: '${e.langName} - ${e.langCode}',
                                                fontSize: 16.0,
                                                color: blackColor,
                                                maxLine: 2,
                                              ),
                                           ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [],
                        onChanged: (value) {
                          if (value == null) return;
                          if (cCubit.state.languages.isNotEmpty) {
                            cCubit.state.languages.clear();
                          }
                          if (value.langCode != loginBloc.state.langCode) {
                            // cCubit.clearLanguage();
                            cCubit.addNewLanguage(value);
                            loginBloc.add(LoginEventLanguageCode(cCubit.state.languages.first.langCode));
                            websiteCubit.getSetting(cCubit.state.languages.first.langCode);

                            if(Utils.isSeller(context)){
                              context.read<DashBoardCubit>().getDashBoard();
                            }else{
                              context.read<HomeCubit>().getHomeData(cCubit.state.languages.first.langCode);
                            }

                          }
                        },
                      )),
                  ],
                ),
                _divider(Utils.only(right: 20.0,bottom: 10.0)),
              ],
            );
          },
        ),
      );
    } else {
      return BlocBuilder<CurrencyCubit, CurrencyStateModel>(
        builder: (context, state) {
          if (state.currencies.isNotEmpty) {
            currency = state.currencies.first;
          }
           return Expanded(
             // flex: 3,
             flex: 1,
             child: DropdownButtonFormField<CurrenciesModel>(
               dropdownColor: blackColor,
               isDense: false,
               isExpanded: true,
               value: currency,
               decoration: const InputDecoration(
                 filled: false,
                 fillColor: transparent,
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 enabledBorder: InputBorder.none,
               ),
               hint:  CustomText(
                 text: Utils.translatedText(context, 'Select Currency'),
                 fontWeight: FontWeight.w400,
                 fontSize: 16.0,
                 color: whiteColor,
               ),
               borderRadius: Utils.borderRadius(r: 5.0),

               icon: const Icon(Icons.keyboard_arrow_down_sharp,
                   color: whiteColor),
               items:
               websiteCubit.settingModel?.currencyList?.isNotEmpty ??
                   false
                   ? websiteCubit.settingModel?.currencyList
                   ?.map<DropdownMenuItem<CurrenciesModel>>(
                     (e) => DropdownMenuItem(
                       value: e,
                       child: Row(
                         children: [
                           // Container(
                           //   height: 35.0,
                           //   margin: Utils.only(right: 10.0),
                           //   child:  const CustomImage(path: KImages.currencyIcon,fit: BoxFit.cover),
                           //   // child:  CustomImage(path: 'https://flagsapi.com/${e.langName}/flat/64.png',fit: BoxFit.fill),
                           // ),
                           // const Spacer(flex: 1),
                           Flexible(
                             child: CustomText(
                               text: '${e.currencyIcon} - ${e.currencyName}',
                               fontSize: 16.0,
                               color: whiteColor,
                               maxLine: 2,
                             ),
                           ),
                         ],
                       ),
                 ),
               )
                   .toList()
                   : [],
               onChanged: (val) {
                 if (val == null) return;
                 // if (state.currencies.isNotEmpty) {
                 //   state.currencies.clear();
                 // }
                 cCubit..clearCurrency()..addNewCurrency(val)..getRealtimeCurrency();
               },
             ),
           );
          ///previous code
         /* return Column(
            children: [
              Row(
                children: [
                  titleIcon('Multi Currency',KImages.currencyIcon),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<CurrenciesModel>(
                      dropdownColor: whiteColor,
                      isDense: true,
                      isExpanded: true,
                      value: currency,
                      decoration: const InputDecoration(
                        filled: false,
                        fillColor: transparent,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                        borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,

                      hint:  CustomText(
                        text: Utils.translatedText(context, 'Select Currency'),
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: blackColor,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp,
                          color: blackColor),
                      items:
                          websiteCubit.settingModel?.currencyList?.isNotEmpty ??
                                  false
                              ? websiteCubit.settingModel?.currencyList
                                  ?.map<DropdownMenuItem<CurrenciesModel>>(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   height: 35.0,
                                          //   margin: Utils.only(right: 10.0),
                                          //   child:  const CustomImage(path: KImages.currencyIcon,fit: BoxFit.cover),
                                          //   // child:  CustomImage(path: 'https://flagsapi.com/${e.langName}/flat/64.png',fit: BoxFit.fill),
                                          // ),
                                          // const Spacer(flex: 1),
                                          Flexible(
                                            child: CustomText(
                                              text: '${e.currencyIcon} - ${e.currencyName}',
                                              fontSize: 16.0,
                                              color: blackColor,
                                              maxLine: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList()
                              : [],
                      onChanged: (val) {
                        if (val == null) return;
                        // if (state.currencies.isNotEmpty) {
                        //   state.currencies.clear();
                        // }
                        cCubit..clearCurrency()..addNewCurrency(val)..getRealtimeCurrency();
                      },
                    ),
                  ),
                ],
              ),
              _divider(Utils.only(right: 20.0,bottom: 20.0)),
            ],
          );*/

        },
      );
    }
  }

  Widget _divider(EdgeInsets margin) {
    return Container(
      margin: margin,
      //margin: Utils.only(right: 20.0,bottom: 20.0),
      // padding: Utils.symmetric(),
      width: double.infinity,
      height: 1.0,
      color: stockColor,
    );
  }

  Widget titleIcon(String title,String icon) {
    return  Padding(
      padding: Utils.symmetric(h: 0.0, v: 0.0),
      child: Row(
        children: [
           CustomImage(
            path: icon,
            width: 24.0,
            height: 24.0,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 15.0),
          CustomText(
            text: Utils.translatedText(context, title),
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: blackColor,
          ),
        ],
      ),
    );
  }
}
