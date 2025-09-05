import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';

import '../../../logic/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../logic/cubit/forgot_password/forgot_password_state_model.dart';
import '../../routes/route_names.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordCubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      appBar: const DefaultAppBar(title: ''),
      body: BlocListener<ForgotPasswordCubit, PasswordStateModel>(
        listener: (context, state) {
          final password = state.passwordState;
          if (password is ForgotPasswordStateError) {
            Utils.errorSnackBar(context, password.message);
          } else if (password is ForgotPasswordStateLoaded) {
            Utils.showSnackBar(context, password.message);
            Navigator.pushNamed(context, RouteNames.verificationScreen,
                arguments: false);
          }
        },
        child: ListView(
          padding: Utils.symmetric(),
          children: [
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
            CustomText(
              text: Utils.translatedText(context, 'Forget Password'),
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: Utils.translatedText(context, 'Please provider your existing email address from which you can reset you password'),
              fontSize: 14.0,
              textAlign: TextAlign.start,
            ),

            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.05),
            // Utils.verticalSpace(Utils.mediaQuery(context).height * 0.1),
            BlocBuilder<ForgotPasswordCubit, PasswordStateModel>(
            builder: (context, state) {
              final password = state.passwordState;
              return CustomFormWidget(
                label: 'Email Address',
                bottomSpace: 30.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'your email address'),
                      keyboardType: TextInputType.emailAddress,
                      initialValue: state.email,
                      onChanged: (String text) =>
                          passwordCubit.changeEmail(text),
                    ),
                    if (password
                    is ForgotPasswordFormValidateError) ...[
                      if (password.errors.email.isNotEmpty)
                        ErrorText(text: password.errors.email.first),
                    ]
                  ],
                ),
              );
            },
          ),
            BlocBuilder<ForgotPasswordCubit, PasswordStateModel>(
              builder: (context, state) {
                final password = state.passwordState;
                if (password is ForgotPasswordStateLoading) {
                  return const LoadingWidget();
                }
                return PrimaryButton(
                    text: Utils.translatedText(context, 'Send Code'),
                    onPressed: () {
                      Utils.closeKeyBoard(context);
                      passwordCubit.forgotPassWord();
                    });
              },
            ),
            // Utils.verticalSpace(20.0),
          ],
        ),
      ),
    );
  }
}
