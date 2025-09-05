import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_zone/logic/bloc/signup/sign_up_event.dart';
import 'package:work_zone/state_injection_packages.dart';

import '/presentation/routes/route_packages_name.dart';
import '../../../data/models/auth/login_state_model.dart';
import '../../../logic/bloc/login/login_bloc.dart';
import '../../routes/route_names.dart';
import '../../utils/utils.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late LoginBloc loginBloc;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    _initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSavedData();
    });
  }

  _initState() {
    loginBloc = context.read<LoginBloc>();
  }

  Future<void> _initSavedData() async {
    preferences = await SharedPreferences.getInstance();
    final email = preferences.getString('email');
    final password = preferences.getString('password');
    if (email?.trim().isNotEmpty ?? false) {
      // debugPrint('exist-email $email');
      loginBloc.emailController.text = email ?? '';
      loginBloc.add(LoginEventUserEmail(email ?? ''));
      // debugPrint('state-exist-email $email');
    } else {
      // debugPrint('email-not-saved $email');
    }
    if (password?.trim().isNotEmpty ?? false) {
      // debugPrint('exist-password $password');
      loginBloc.passwordController.text = password ?? '';
      loginBloc.add(LoginEventPassword(password ?? ''));
      // debugPrint('state-exist-password $password');
    } else {
      // debugPrint('password-not-saved $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(backgroundColor: scaffoldBgColor),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ConfirmDialog(
                confirmText: 'Yes, Exit',
                onTap: () => SystemNavigator.pop(),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: Utils.symmetric(v: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Utils.verticalSpace(Utils.mediaQuery(context).height * 0.1),

                CustomText(
                  text: Utils.translatedText(context, 'Log in to your Account'),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
                Utils.verticalSpace(8.0),
                CustomText(
                  text: Utils.translatedText(context, 'You can login now with your credential'),
                  fontSize: 14.0,
                  color: gray5B,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                ),

                Utils.verticalSpace(20.0),
                BlocBuilder<LoginBloc, LoginStateModel>(
                  builder: (context, state) {
                    final validate = state.loginState;
                    return CustomFormWidget(
                      label: Utils.translatedText(context, 'Email'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            // initialValue: state.email,
                            controller: loginBloc.emailController,
                            decoration: InputDecoration(
                              hintText:
                              Utils.translatedText(context, 'Email', true),
                            ),
                            onChanged: (String email) =>
                                loginBloc.add(LoginEventUserEmail(email)),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          if (validate is LoginStateFormValidate) ...[
                            if (validate.errors.email.isNotEmpty)
                              ErrorText(text: validate.errors.email.first),
                          ]
                        ],
                      ),
                    );
                  },
                ),
                Utils.verticalSpace(16.0),
                BlocBuilder<LoginBloc, LoginStateModel>(
                  builder: (context, state) {
                    final validate = state.loginState;
                    return CustomFormWidget(
                      label: Utils.translatedText(context, 'Password'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: loginBloc.passwordController,
                            onChanged: (String password) =>
                                loginBloc.add(LoginEventPassword(password)),
                            decoration: InputDecoration(
                                hintText: Utils.translatedText(
                                    context, 'Password', true),
                                suffixIcon: IconButton(
                                  splashRadius: 16.0,
                                  onPressed: () =>
                                      loginBloc.add(LoginEventShowPassword()),
                                  icon: Icon(
                                      !state.show
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: grayColor),
                                )),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: state.show,
                          ),
                          if (state.email.isNotEmpty &&
                              validate is LoginStateFormValidate) ...[
                            if (validate.errors.password.isNotEmpty)
                              ErrorText(text: validate.errors.password.first),
                          ]
                        ],
                      ),
                    );
                  },
                ),
                _buildRemember(context),
                Utils.verticalSpace(24),
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

                      // if (login.responses.user != null) {
                      //   final isBuyer = login.responses.user?.isSeller ?? 0;
                      //   debugPrint('isBuyer $isBuyer');
                      // if (isBuyer == 0) {
                      //   // debugPrint('already-login-buyer ${loginBloc.userInformation?.userType}');
                      //   Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                      // } else {
                      //   // debugPrint('already-login-seller ${loginBloc.userInformation?.userType}');
                      //   Navigator.pushNamedAndRemoveUntil(context, RouteNames.buyerMainScreen, (route) => false);
                      // }
                      //}
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
                        loginBloc.add(const LoginEventSubmit());
                        //Navigator.pushNamed(context, RouteNames.mainScreen);
                      },
                    );
                  },
                ),
                Utils.verticalSpace(16),
                Center(
                  child: Text.rich(TextSpan(
                      text: "Dont have an account?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                      children: [
                        TextSpan(
                          text: Utils.translatedText(context, "Sign Up"),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                            context.read<SignUpBloc>().add(SignUpEventFormDataClear());
                              Navigator.pushNamed(
                                  context, RouteNames.signUpScreen);
                            },
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            fontFamily: bold700,
                            letterSpacing: 1,
                          ),
                        )
                      ])),
                ),
                Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
                GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context,RouteNames.mainScreen),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: Utils.translatedText(context, 'Guest Login'),
                      fontSize: 18.0,
                      color: primaryColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      decorationColor: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // Utils.verticalSpace(Utils.mediaQuery(context).height * 0.15),
                // const SocialBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildRemember(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return BlocBuilder<LoginBloc, LoginStateModel>(
      builder: (context, state) {
        return Padding(
          padding: Utils.only(top: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: Utils.hSize(20.0),
                    width: Utils.vSize(20.0),
                    margin: Utils.only(right: 10.0),
                    child: Checkbox(
                      onChanged: (v) => loginBloc.add(LoginEventRememberMe()),
                      value: state.isActive,
                      activeColor: primaryColor,
                    ),
                  ),
                  CustomText(
                    text: Utils.translatedText(context, 'Remember Me'),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                    height: 1.6,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // context.read<ForgotPasswordCubit>().clear();
                  Navigator.pushNamed(context, RouteNames.forgotPasswordScreen);
                },
                child: CustomText(
                  text: Utils.translatedText(context, 'Forget Password?'),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: redColor,
                  height: 1.6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
