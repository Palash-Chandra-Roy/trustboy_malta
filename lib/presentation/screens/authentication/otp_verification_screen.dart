import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../../presentation/routes/route_names.dart';
import '../../../logic/bloc/signup/sign_up_bloc.dart';
import '../../../logic/bloc/signup/sign_up_event.dart';
import '../../../logic/bloc/signup/sign_up_state.dart';
import '../../../logic/bloc/signup/sign_up_state_model.dart';
import '../../../logic/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../logic/cubit/forgot_password/forgot_password_state_model.dart';
import '../../utils/constraints.dart';
import '../../utils/language_string.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.isNewUser});

  final bool isNewUser;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool finishTime = true;

  late LoginBloc loginBloc;
  late SignUpBloc signUpBloc;
  late ForgotPasswordCubit passwordCubit;

  @override
  void initState() {
    loginBloc = context.read<LoginBloc>();
    signUpBloc = context.read<SignUpBloc>();
    passwordCubit = context.read<ForgotPasswordCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('is-new ${widget.isNewUser}');
    return Scaffold(
      appBar: const DefaultAppBar(title: ''),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SignUpBloc, SignUpStateModel>(
            listener: (context, state) {
              final signUpState = state.signUpState;
              if (signUpState is SignUpStateLoading || signUpState is SignUpStateResendCodeLoading) {
                Utils.loadingDialog(context);
              } else {
                Utils.closeDialog(context);
                if (signUpState is SignUpStateError) {
                  Utils.errorSnackBar(context, signUpState.errorMsg);
                } else if (signUpState
                    is SignUpStateNewUserVerificationLoaded) {
                  loginBloc.add(LoginEventUserEmail(signUpBloc.state.email));
                  loginBloc.add(LoginEventPassword(signUpBloc.state.password));
                  //Utils.showSnackBar(context, signUpState.message);
                  Utils.closeDialog(context);
                  setState(() => finishTime = false);
                  /*showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => LoginDialog(
                          success: signUpState.message,
                          isNewUser: widget.isNewUser));*/
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.successfulScreen, (route) => false);
                } else if (signUpState is SignUpStateResendCodeLoaded) {
                  Utils.closeDialog(context);
                  Utils.showSnackBar(context, signUpState.message);
                  setState(() => finishTime = true);
                }
              }
            },
          ),
          BlocListener<ForgotPasswordCubit, PasswordStateModel>(
            listener: (context, state) {
              final password = state.passwordState;
              if (password is VerifyingForgotPasswordLoading) {
                Utils.loadingDialog(context);
              } else {
                Utils.closeDialog(context);
                if (password is VerifyingForgotPasswordCodeLoaded) {
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteNames.updatePasswordScreen, (route) => false);
                }
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // CustomText(
                  //   text: Utils.translatedText(context, 'OTP verified'),
                  //   fontSize: 24.0,
                  //   maxLine: 2,
                  //   fontWeight: FontWeight.w700,
                  // ),
                  // Utils.verticalSpace(12.0),
                  // CustomText(
                  //  text: passwordCubit.state.message,
                  //   color: const Color(0xFF64748B),
                  //   maxLine: 2,
                  // ),
                  // Utils.verticalSpace(24),
                  Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
                  CustomText(
                    text: Utils.translatedText(context, 'Verify OTP'),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: Utils.translatedText(context, 'Please check your email or Phone to see the  verification code.'),
                    fontSize: 16.0,
                    height: 1.6,
                    textAlign: TextAlign.start,
                  ),

                  Utils.verticalSpace(20.0),
                  Center(
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: PinTheme(
                        height: Utils.vSize(70.0),
                        width: Utils.hSize(70.0),
                        textStyle: GoogleFonts.ibmPlexSansDevanagari(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(color: stockColor),
                          shape: BoxShape.circle
                        ),
                      ),
                      onChanged: (String code) {
                        if (widget.isNewUser) {
                          debugPrint('new user change');
                          signUpBloc.add(SignUpEventVerificationCode(code));
                        } else {
                          passwordCubit.changeCode(code);
                          debugPrint('forgot password change');
                        }
                      },
                      onCompleted: (String code) {
                        if (widget.isNewUser) {
                          debugPrint('new user completed');
                          signUpBloc.add(SignUpEventNewUserSubmit());
                        } else {
                          if (code.isNotEmpty) {
                            passwordCubit.verifyForgotPasswordCode();
                          }
                          debugPrint('forgot password completed');
                        }
                      },
                    ),
                  ),
                  Utils.verticalSpace(24),
                  if(widget.isNewUser)...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: Utils.translatedText(context, 'Resend code reload in')),
                        finishTime
                            ? _countDownTime()
                            : GestureDetector(
                          onTap: ()=> signUpBloc.add(const SignUpEventResendVerificationSubmit()),
                          child: CustomText(
                            text: Utils.translatedText(context, Language.resendCode),
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Utils.verticalSpace(12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _countDownTime() {
    final signUpBloc = context.read<SignUpBloc>();
    // if (finishTime) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: TimerCountdown(
            format: CountDownTimerFormat.minutesSeconds,
            enableDescriptions: false,
            spacerWidth: 6.0,
            timeTextStyle: GoogleFonts.ibmPlexSansDevanagari(
              fontSize: 16.0,
              color: blueColor,
              fontWeight: FontWeight.w500,
            ),
            colonsTextStyle: GoogleFonts.ibmPlexSansDevanagari(
              fontSize: 16.0,
              color: blueColor,
              fontWeight: FontWeight.w500,
            ),
            endTime: DateTime.now().add(
              const Duration(seconds: 30),
            ),
            onEnd: () {
              print('finish');
              setState(() => finishTime = false);
            },
          ),
        ),
      ],
    );
    // } else {
    //   return Column(
    //     children: [
    //       const CustomText(
    //           text: 'Don\'t get verification code ?', fontSize: 18.0),
    //       Utils.verticalSpace(16),
    //       PrimaryButton(
    //           text: Utils.translatedText(context,Language.resendCode),
    //           fontSize: 14,
    //           onPressed: () {
    //             signUpBloc.add(const SignUpEventResendVerificationSubmit());
    //           }),
    //     ],
    //   );
    // }
  }

// Widget _resendButton() {
//   final signUpBloc = context.read<SignUpBloc>();
//   return Column(
//     children: [
//       const CustomText(
//           text: 'Don\'t get verification code ?', fontSize: 18.0),
//       Utils.verticalSpace(16),
//       PrimaryButton(
//           text: "Resend Code",
//           fontSize: 14,
//           onPressed: () {
//             signUpBloc.add(const SignUpEventResendVerificationSubmit());
//           }),
//     ],
//   );
// }
}

/*class LoginDialog extends StatelessWidget {
  const LoginDialog(
      {super.key, required this.success, required this.isNewUser});

  final String success;
  final bool isNewUser;

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    final signUpBloc = context.read<SignUpBloc>();
    final size = MediaQuery.sizeOf(context);
    return BlocListener<LoginBloc, LoginStateModel>(
      listener: (context, state) {
        final login = state.loginState;
        if (login is LoginStateLoading) {
          Utils.loadingDialog(context);
        } else {
          Utils.closeDialog(context);
          if (login is LoginStateError) {
            Utils.errorSnackBar(context, login.message);
          } else if (login is LoginStateLoaded) {
            Navigator.pop(context);
            //Utils.closeDialog(context);
            Navigator.pushNamedAndRemoveUntil(
                context, RouteNames.mainScreen, (route) => false);
            // if (isNewUser) {
            //   debugPrint('new user registration');
            //   signUpBloc.add(const SignUpEventFormDataClear());
            // } else {
            //   debugPrint('not new user');
            // }
          }
        }
      },
      child: CustomDialog(
        icon: KImages.done,
        height: size.height * 0.3,
        child: Column(
          children: [
            CustomText(
              text: success,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: blackColor,
              textAlign: TextAlign.center,
            ),
            Utils.verticalSpace(45.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    //registerBloc.add(RegisterEventClear());
                    Navigator.pushNamedAndRemoveUntil(context,
                        RouteNames.authenticationScreen, (route) => false);
                  },
                  child: Container(
                    padding: Utils.symmetric(v: 10.0, h: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: blackColor,
                    ),
                    child: const CustomText(
                      text: 'Cancel',
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    loginBloc.add(const LoginEventSubmit());
                  },
                  child: Container(
                    padding: Utils.symmetric(v: 10.0, h: 30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: greenColor,
                    ),
                    child: const CustomText(
                      text: 'Login',
                      color: whiteColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     PrimaryButton(
            //       text: 'Cancel',
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //         //registerBloc.add(RegisterEventClear());
            //         Navigator.pushNamedAndRemoveUntil(context,
            //             RouteNames.authenticationScreen, (route) => false);
            //       },
            //       borderRadiusSize: 6.0,
            //       bgColor: blackColor,
            //       fontSize: 16.0,
            //       minimumSize: Size(Utils.hSize(125.0), Utils.vSize(52.0)),
            //     ),
            //     PrimaryButton(
            //       text: 'Login',
            //       onPressed: () => loginBloc.add(const LoginEventSubmit()),
            //       bgColor: greenColor,
            //       borderRadiusSize: 6.0,
            //       fontSize: 16.0,
            //       minimumSize: Size(Utils.hSize(125.0), Utils.vSize(52.0)),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}*/
