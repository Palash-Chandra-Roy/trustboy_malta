import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';
import 'package:work_zone/presentation/widgets/loading_widget.dart';

import '../../../logic/bloc/signup/sign_up_bloc.dart';
import '../../../logic/bloc/signup/sign_up_event.dart';
import '../../../logic/bloc/signup/sign_up_state.dart';
import '../../../logic/bloc/signup/sign_up_state_model.dart';
import '../../../logic/cubit/forgot_password/forgot_password_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpBloc signUpBloc;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    signUpBloc = context.read<SignUpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: const DefaultAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils.symmetric(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Utils.verticalSpace(Utils.mediaQuery(context).height * 0.0),
              BlocBuilder<SignUpBloc, SignUpStateModel>(
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 10.0,
                      children: signUpBloc.types(context).map((category) {
                        final isSelected = state.userType == category;
                        return ChoiceChip(
                          labelPadding: Utils.symmetric(h: 20.0, v: 4.0),
                          label: CustomText(
                            text: category,
                            color: isSelected ? whiteColor : blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                          selected: isSelected,
                          selectedColor: primaryColor,
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: Utils.borderRadius(r: 40.0),
                            side: const BorderSide(color: primaryColor),
                          ),
                          onSelected: (bool selected) {
                            signUpBloc.add(SignUpEventUserType(category));
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              Utils.verticalSpace(20.0),
              CustomText(
                text: Utils.translatedText(context, 'Welcome to WorkZone'),
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: Utils.translatedText(context, 'Sign Up'),
                fontSize: 20.0,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
              ),
              Utils.verticalSpace(20.0),
              BlocBuilder<SignUpBloc, SignUpStateModel>(
                  builder: (context, state) {
                final validate = state.signUpState;
                return CustomFormWidget(
                  label: Utils.translatedText(context, 'Name'),
                  bottomSpace: 14.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: state.name,//Utils.validateName()
                        onChanged: (String name) =>
                            signUpBloc.add(SignUpEventName(name)),
                        decoration: InputDecoration(
                          hintText: Utils.translatedText(context, 'Name', true),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      if (validate is SignUpStateFormValidate) ...[
                        if (validate.errors.name.isNotEmpty)
                          ErrorText(text: validate.errors.name.first),
                      ]
                    ],
                  ),
                );
              },
              ),

              BlocBuilder<SignUpBloc, SignUpStateModel>(
                  builder: (context, state) {
                final validate = state.signUpState;
                return CustomFormWidget(
                  label: Utils.translatedText(context, 'Email'),
                  bottomSpace: 14.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: state.email,
                        onChanged: (String email) =>
                            signUpBloc.add(SignUpEventEmail(email)),
                        decoration: InputDecoration(
                          hintText:
                              Utils.translatedText(context, 'Email', true),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      if (signUpBloc.state.name.isNotEmpty)
                        if (validate is SignUpStateFormValidate) ...[
                          if (validate.errors.email.isNotEmpty)
                            ErrorText(text: validate.errors.email.first),
                        ]
                    ],
                  ),
                );
              },
              ),

              BlocBuilder<SignUpBloc, SignUpStateModel>(
                  builder: (context, state) {
                final validate = state.signUpState;
                return CustomFormWidget(
                  label: Utils.translatedText(context, 'Password'),
                  bottomSpace: 14.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: state.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: state.showPassword,
                        onChanged: (String password) =>
                            signUpBloc.add(SignUpEventPassword(password)),
                        decoration: InputDecoration(
                          hintText:
                              Utils.translatedText(context, 'Password', true),
                          suffixIcon: IconButton(
                            splashRadius: 18.0,
                            onPressed: () =>
                                signUpBloc.add(const SignUpEventShowPassword()),
                            icon: Icon(
                                state.showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: grayColor),
                          ),
                        ),
                      ),
                      if (state.email.isNotEmpty)
                        if (validate is SignUpStateFormValidate) ...[
                          if (validate.errors.password.isNotEmpty)
                            ErrorText(text: validate.errors.password.first),
                        ]
                    ],
                  ),
                );
              },
              ),

              BlocBuilder<SignUpBloc, SignUpStateModel>(
                  builder: (context, state) {
                final validate = state.signUpState;
                return CustomFormWidget(
                  label: Utils.translatedText(context, 'Confirm Password'),
                  bottomSpace: 14.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: state.confirmPassword,
                        onChanged: (String confirmPassword) => signUpBloc
                            .add(SignUpEventPasswordConfirm(confirmPassword)),
                        decoration: InputDecoration(
                          hintText: Utils.translatedText(
                              context, 'Confirm Password', true),
                          suffixIcon: IconButton(
                            splashRadius: 18.0,
                            onPressed: () => signUpBloc
                                .add(const SignUpEventShowConfirmPassword()),
                            icon: Icon(
                                state.showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: grayColor),
                          ),
                        ),
                        obscureText: state.showConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      if (state.confirmPassword.isNotEmpty ||
                          (state.confirmPassword.isEmpty &&
                              !state.confirmPassword.contains(state.password)))
                        if (validate is SignUpStateFormValidate) ...[
                          if (validate.errors.password.isNotEmpty)
                            ErrorText(text: validate.errors.password.first),
                        ]
                    ],
                  ),
                );
              }),
              // _buildRemember(context),
              Utils.verticalSpace(24),
              BlocConsumer<SignUpBloc, SignUpStateModel>(
                listener: (context, state) {
                  final provider = state.signUpState;
                  if (provider is SignUpStateError) {
                    Utils.errorSnackBar(context, provider.errorMsg);
                  } else if (provider is SignUpStateLoaded) {
                    context.read<ForgotPasswordCubit>().message(provider.msg);
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.verificationScreen, (route) => false, arguments: true);
                    // Utils.showSnackBar(context, provider.msg);
                  }
                },
                builder: (context, states) {
                  final state = states.signUpState;
                  if(state is SignUpStateLoading){
                    return const LoadingWidget();
                  }
                  return PrimaryButton(
                      text: Utils.translatedText(context, 'Sign Up'),
                      fontSize: 16.0,
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        if(states.password == states.confirmPassword){
                          debugPrint('password-match ${states.password} | ${states.confirmPassword}');
                          signUpBloc.add(SignUpEventSubmit());
                        }else{
                          Utils.showSnackBar(context, Utils.translatedText(context, 'Confirm password does not match'));
                        }
                      });
                },
              ),
              Utils.verticalSpace(16),
              Center(
                child: Text.rich(TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign in",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, RouteNames.authScreen),
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
              // Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
              // const SocialBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: Utils.only(top: 0.0),
              child: Checkbox(
                  value: true,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(Utils.radius(2.4))),
                  activeColor: primaryColor,
                  onChanged: (bool? val) {}),
            ),
            const CustomText(
              text: 'Remember me',
              color: gray5B,
              height: 1.6,
            ),
          ],
        ),
        GestureDetector(
          // onTap: () =>
          //     Navigator.pushNamed(context, RouteNames.forgotPassScreen),
          child: const CustomText(
            text: 'Forgot Password',
            color: primaryColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
