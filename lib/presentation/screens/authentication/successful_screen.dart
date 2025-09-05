import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/utils/k_images.dart';
import 'package:work_zone/presentation/utils/utils.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';
import 'package:work_zone/presentation/widgets/primary_button.dart';

import '../../../data/models/auth/login_state_model.dart';
import '../../../logic/bloc/login/login_bloc.dart';
import '../../routes/route_names.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_widget.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({super.key});

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {

  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: const DefaultAppBar(title: '',isShowBackButton: false),
      body: Padding(
        padding: Utils.symmetric(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
                alignment: Alignment.center,
                child: CustomImage(path: KImages.successIcon)),
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.1),
            CustomText(
              text: Utils.translatedText(context, 'Your are Successfully Change'),
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
            ),
            Utils.verticalSpace(6.0),
            CustomText(
              text: Utils.translatedText(context, 'Nice to see you again. Let’s find your Needs.'),
              fontSize: 14.0,
              textAlign: TextAlign.center,
              color: gray5B,
            ),
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
            BlocConsumer<LoginBloc, LoginStateModel>(
              listener: (context, state) {
                final login = state.loginState;
                if (login is LoginStateError) {
                  Utils.errorSnackBar(context, login.message);
                } else if (login is LoginStateLoaded) {
                  loginBloc.add(const LoginEventSaveCredential());
                  Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                  // if (login.responses.userType.isNotEmpty) {
                  //   final isBuyer = login.responses.userType;
                  //   if (isBuyer.toLowerCase() == 'buyer') {
                  //     Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerMainScreen, (route) => false);
                  //   } else {
                  //     Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                  //   }
                  // }
                }
              },
              builder: (context, state) {
                final loading = state.loginState;
                if (loading is LoginStateLoading) {
                  return const LoadingWidget();
                }
                return PrimaryButton(
                  text: Utils.translatedText(context, 'Login Now'),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    // debugPrint('email-pass ${state.email} | ${state.password}');
                    loginBloc.add(const LoginEventSubmit());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
