import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/change_password/change_password_cubit.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/common_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  late ChangePasswordCubit passwordCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    passwordCubit = context.read<ChangePasswordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Change Password')),
      body: Utils.logout(
        child: CommonContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: Utils.translatedText(context, 'Update your Password'),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                Utils.verticalSpace(4.0),
                CustomText(
                  text: Utils.translatedText(context, 'Do you want to change your password, please fill out the form below'),
                  fontSize: 12.0,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                ),
                Utils.verticalSpace(24.0),
                BlocBuilder<ChangePasswordCubit, ChangePasswordStateModel>(
                  builder: (context, state) {
                    final s = state.status;
                    return CustomFormWidget(
                      label: Utils.translatedText(context, 'Current Password'),
                      bottomSpace: 14.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: Utils.translatedText(context, 'Current Password',false),
                              border:  outlineBorder(),
                              enabledBorder: outlineBorder(),
                              focusedBorder: outlineBorder(),
                              suffixIcon: IconButton(
                                splashRadius: 16.0,
                                onPressed: () => passwordCubit.showCurrentPassword(),
                                icon: Icon(
                                    state.isShowCurrentPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: grayColor),
                              ),
                            ),
                            initialValue: state.currentPassword,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (val) =>
                                passwordCubit.changeCurrentPassword(val),
                            obscureText: state.isShowCurrentPassword,
                          ),
                          if (s is ChangePasswordStateFormError) ...[
                            if (s.errors.currentPassword.isNotEmpty)
                              ErrorText(text: s.errors.currentPassword.first)
                          ]
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<ChangePasswordCubit, ChangePasswordStateModel>(
                  builder: (context, state) {
                    final s = state.status;
                    return CustomFormWidget(
                      label: Utils.translatedText(context, 'New Password'),
                      bottomSpace: 14.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: Utils.translatedText(context, 'New Password',false),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder(),
                                suffixIcon: IconButton(
                                  splashRadius: 16.0,
                                  onPressed: () => passwordCubit.showNewPassword(),
                                  icon: Icon(
                                      state.isShowNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: grayColor),
                                )),
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: passwordCubit.changeNewPassword,
                            obscureText: state.isShowNewPassword,
                            initialValue: state.newPassword,
                          ),
                          if (state.currentPassword.isNotEmpty)
                            if (s is ChangePasswordStateFormError) ...[
                              if (s.errors.password.isNotEmpty)
                                ErrorText(text: s.errors.password.first)
                            ]
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<ChangePasswordCubit, ChangePasswordStateModel>(
                  builder: (context, state) {
                    final s = state.status;
                    return CustomFormWidget(
                      label: Utils.translatedText(context, 'Confirm Password'),
                      bottomSpace: 30.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: Utils.translatedText(context, 'Confirm Password',false),
                                border:  outlineBorder(),
                                enabledBorder: outlineBorder(),
                                focusedBorder: outlineBorder(),
                                suffixIcon: IconButton(
                                  splashRadius: 16.0,
                                  onPressed: () =>
                                      passwordCubit.showConfirmPassword(),
                                  icon: Icon(
                                      state.isShowConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: grayColor),
                                )),
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: passwordCubit.changeConfirmChange,
                            obscureText: state.isShowConfirmPassword,
                            initialValue: state.confirmationPassword,
                          ),
                          if (state.newPassword.isNotEmpty)
                            if (s is ChangePasswordStateFormError) ...[
                              if (s.errors.password.isNotEmpty)
                                ErrorText(text: s.errors.password.first)
                            ]
                        ],
                      ),
                    );
                  },
                ),
                BlocConsumer<ChangePasswordCubit, ChangePasswordStateModel>(
                  listener: (context, state) {
                    final s = state.status;
                    if (s is ChangePasswordStateError) {
                      if(s.statusCode == 401){
                        Utils.logoutFunction(context);
                      }
                      Utils.errorSnackBar(context, s.message);
                    } else if (s is ChangePasswordStateLoaded) {
                      Utils.showSnackBar(context, s.message, whiteColor, 2000);
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    final s = state.status;
                    if (s is ChangePasswordStateLoading) {
                      return const LoadingWidget();
                    }
                    return PrimaryButton(
                        text: Utils.translatedText(context, 'Update Password'),
                        onPressed: () {
                          Utils.closeKeyBoard(context);
                          passwordCubit.changePasswordForm();
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
