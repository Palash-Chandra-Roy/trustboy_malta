import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/state_injection_packages.dart';
import '/presentation/utils/utils.dart';
import '../../routes/route_names.dart';
import '../../utils/k_images.dart';
import '../../widgets/custom_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late LoginBloc loginBloc;
  late SettingCubit settingCubit;
  late CurrencyCubit currencyCubit;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    loginBloc = context.read<LoginBloc>();
    debugPrint('login ${loginBloc.userInformation?.user?.name}');
    settingCubit = context.read<SettingCubit>();
    currencyCubit = context.read<CurrencyCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<InternetStatusBloc, InternetStatusState>(
            listener: (context, state) {
              if (state is InternetStatusBackState) {
                settingCubit.getSetting(loginBloc.state.langCode);
              } else if (state is InternetStatusLostState) {
                Utils.showSnackBar(context, state.message);
              }
            },
          ),
          BlocListener<SettingCubit, SettingState>(
            listener: (context, state) {
              if (state is SettingStateLoaded) {
                final setting = state;

                if (setting.settingModel.languageList?.isNotEmpty ?? false) {
                  for (int i = 0; i < setting.settingModel.languageList!.length; i++) {
                    final defaultLanguage = setting.settingModel.languageList?[i].isDefault;
                    if (defaultLanguage?.toLowerCase() == 'yes') {
                      final langCode = setting.settingModel.languageList?[i].langCode;
                      loginBloc.add(LoginEventLanguageCode(langCode ?? 'en'));
                      currencyCubit.addNewLanguage(setting.settingModel.languageList![i]);
                    }
                  }
                }

                if (setting.settingModel.currencyList?.isNotEmpty ?? false) {
                  for (int i = 0; i < setting.settingModel.currencyList!.length; i++) {
                    final defaultLanguage = setting.settingModel.currencyList?[i].isDefault;
                    if (defaultLanguage?.toLowerCase() == 'yes') {
                      final langCode = setting.settingModel.currencyList?[i].currencyIcon;
                      // loginBloc.add(LoginEventLanguageCode(langCode ?? 'en'));
                      currencyCubit.addNewCurrency(setting.settingModel.currencyList![i]);
                    }
                  }
                }

                if(state.settingModel.setting?.maintenanceStatus == 0){
                  if (loginBloc.isLoggedIn) {
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                    // if (loginBloc.userInformation?.user != null) {
                    //   final isBuyer = loginBloc.userInformation?.user?.isSeller ?? 0;
                    //   debugPrint('isBuyer $isBuyer');
                    //   if (isBuyer == 0) {
                    //     // debugPrint('already-login-buyer ${loginBloc.userInformation?.userType}');
                    //     Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                    //   } else {
                    //     // debugPrint('already-login-seller ${loginBloc.userInformation?.userType}');
                    //     Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerMainScreen, (route) => false);
                    //   }
                    // }
                  } else if (settingCubit.showOnBoarding) {
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.authScreen, (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.onBoardingScreen, (route) => false);
                  }
                }else{
                  Navigator.pushNamedAndRemoveUntil(context, RouteNames.maintainScreen, (route) => false);
                }

              } else if (state is SettingStateLoading) {
              } else if (state is SettingStateError) {
                Utils.errorSnackBar(context, state.message);
              }
            },
          ),
        ],
        child: Center(
          child: SizedBox(
            height: Utils.vSize(80.0),
            width: Utils.hSize(200.0),
            child: const CustomImage(
              path: KImages.splashBg,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
