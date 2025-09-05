import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/bloc/login/login_bloc.dart';
import '../../../logic/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../logic/cubit/forgot_password/forgot_password_state_model.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';


class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordCubit = context.read<ForgotPasswordCubit>();
    final loginBloc = context.read<LoginBloc>();
    return Scaffold(
      appBar: const DefaultAppBar(title: ''),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: Utils.symmetric(),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
                  CustomText(
                    text: Utils.translatedText(context, 'Create New Password'),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: Utils.translatedText(context, 'Your new password must be different from previously used passwords'),
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                  ),

                  Utils.verticalSpace(20.0),
                  BlocBuilder<ForgotPasswordCubit, PasswordStateModel>(
                    builder: (context, state) {
                      final validate = state.passwordState;
                      return CustomFormWidget(
                        label: Utils.translatedText(context, 'Password'),
                        bottomSpace: 24.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: (String password) =>
                                  passwordCubit.changePassword(password),
                              decoration: InputDecoration(
                                  hintText: Utils.translatedText(context, 'Password',false),
                                  suffixIcon: IconButton(
                                    splashRadius: 16.0,
                                    onPressed: () =>
                                        passwordCubit.showPassword(),
                                    icon: Icon(
                                        !state.showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: grayColor),
                                  )),
                              initialValue: state.password,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: state.showPassword,
                            ),
                            if (validate
                            is ForgotPasswordFormValidateError) ...[
                              if (validate.errors.password.isNotEmpty)
                                ErrorText(text: validate.errors.password.first),
                            ]
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<ForgotPasswordCubit, PasswordStateModel>(
                    builder: (context, state) {
                      final validate = state.passwordState;
                      return CustomFormWidget(
                        label: Utils.translatedText(context, 'Confirm Password'),
                        bottomSpace: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              onChanged: (String password) =>
                                  passwordCubit.changeConfirmPassword(password),
                              decoration: InputDecoration(
                                  hintText: Utils.translatedText(context, 'Confirm Password',false),
                                  suffixIcon: IconButton(
                                    splashRadius: 16.0,
                                    onPressed: () =>
                                        passwordCubit.showConfirmPassword(),
                                    icon: Icon(
                                        !state.showConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: grayColor),
                                  )),
                              initialValue: state.confirmPassword,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: state.showConfirmPassword,
                            ),
                            if (state.password.isNotEmpty)
                              if (validate
                              is ForgotPasswordFormValidateError) ...[
                                if (validate.errors.password.isNotEmpty)
                                  ErrorText(
                                      text: validate.errors.password.first),
                              ]
                          ],
                        ),
                      );
                    },
                  ),
                  BlocConsumer<ForgotPasswordCubit, PasswordStateModel>(
                    listener: (context, state) {
                      final password = state.passwordState;
                      if(password is ForgotPasswordStateError){
                        // loginBloc.add(LoginEventUserEmail(passwordCubit.state.email));
                        // loginBloc.add(LoginEventPassword(passwordCubit.state.password));
                        // debugPrint('new-email ${passwordCubit.state.email}');
                        // debugPrint('new-password ${passwordCubit.state.confirmPassword}');
                        //
                        // Navigator.pushNamedAndRemoveUntil(context, RouteNames.successfulScreen, (route) => false);
                        Utils.errorSnackBar(context, password.message);

                      }else if (password is PasswordStateUpdated) {
                        loginBloc.add(LoginEventUserEmail(passwordCubit.state.email));
                        loginBloc.add(LoginEventPassword(passwordCubit.state.password));
                        debugPrint('new-email ${passwordCubit.state.email}');
                        debugPrint('new-password ${passwordCubit.state.confirmPassword}');
                        Navigator.pushNamedAndRemoveUntil(context, RouteNames.successfulScreen, (route) => false);
                      }
                    },
                    builder: (context, state) {
                      final password = state.passwordState;
                      if (password is ForgotPasswordStateLoading) {
                        return const LoadingWidget();
                      }
                      return PrimaryButton(
                          text: Utils.translatedText(context, 'Update Password'),
                          onPressed: () {
                            Utils.closeKeyBoard(context);
                            passwordCubit.updatePassword();
                          });
                    },
                  ),
                  Utils.verticalSpace(20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*_successDialog(BuildContext context) {
    Utils.showCustomDialog(
      context,
      child: Padding(
        padding: Utils.symmetric(v: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              text: 'Successfully Updated',
              fontSize: 26.0,
              color: blackColor,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            Utils.verticalSpace(5.0),
            const CustomImage(path: KImages.updatePasswordIcon),
            const CustomText(
              text: 'Thank You',
              fontSize: 30.0,
              color: blackColor,
              fontWeight: FontWeight.bold,
            ),
            Utils.verticalSpace(10.0),
            const CustomText(
              text: 'Your password has been updated',
              fontSize: 18.0,
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
            Utils.verticalSpace(30.0),
            PrimaryButton(
              text: 'Back to Login',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.authenticationScreen, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }*/
}

