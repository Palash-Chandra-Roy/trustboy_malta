import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/contact/contact_cubit.dart';
import '../../../../logic/cubit/profile/profile_cubit.dart';
import '/logic/cubit/setting/setting_cubit.dart';
import '/presentation/widgets/loading_widget.dart';
import '../../../widgets/multi_lang_currencies.dart';
import '../../buyer_screen/more/seller_more_screen.dart';
import '/presentation/widgets/custom_form.dart';
import '/presentation/widgets/primary_button.dart';


import '../../../../logic/cubit/change_password/change_password_cubit.dart';
import '../../../../logic/cubit/delete/delete_cubit.dart';
import '../../../../logic/cubit/forgot_password/forgot_password_state_model.dart';
import '../../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/error_text.dart';

class UserMoreScreen extends StatelessWidget {
  const UserMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar:  CustomAppBar(title: Utils.translatedText(context, 'Buyer Menu'), visibleLeading: false,bgColor: whiteColor,),
      body: Padding(
        padding: Utils.symmetric(v: 20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: BlocBuilder<SettingCubit, SettingState>(
            builder: (context, state) {
              return Column(
                children: [
                  DrawerItem(
                      icon: KImages.dashboardIcon,
                      title: Utils.translatedText(context, Language.dashboard),
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.buyerDashboardScreen);
                      }),
                  DrawerItem(
                      icon: KImages.jobPost,
                      title: Utils.translatedText(context, 'Post a Job'),
                      onTap: () {
                        context.read<JobPostCubit>().clear();
                        Navigator.pushNamed(context, RouteNames.addJobScreen);
                        // Navigator.pushNamed(context, RouteNames.createServiceScreen);
                      }),
                  DrawerItem(
                      icon: KImages.myJob,
                      title: Utils.translatedText(context, 'My Job'),
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.buyerJobApplicationScreen);
                      }),

                  if(Utils.isAddon(context)?.refund == true)...[
                    DrawerItem(icon: KImages.refund, title: Utils.translatedText(context, 'Refund'),
                        onTap: (){
                          Navigator.pushNamed(context, RouteNames.buyerRefundScreen);
                        }),
                  ],


                  if(Utils.isAddon(context)?.wallet == true)...[
                    DrawerItem(
                        icon: KImages.walletTrn,
                        title: Utils.translatedText(context, Utils.translatedText(context, 'Wallet')),
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.walletScreen);
                        }),
                  ],

                  DrawerItem(
                      icon: KImages.love,
                      title: Utils.translatedText(context, Language.wishlist),
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.wishlistScreen);
                      }),
                  DrawerItem(
                      icon: KImages.profile,
                      title: Utils.translatedText(context, Language.editProfile),
                      // padding: Utils.only(bottom: 10.0),
                      onTap: () {
                        context.read<ProfileCubit>().resetState();
                        Navigator.pushNamed(context, RouteNames.updateProfileScreen);
                      }),
                  DrawerItem(
                      icon: KImages.lock,
                      title: Utils.translatedText(context, 'Change Password'),
                      onTap: () {
                        context.read<ChangePasswordCubit>().clearFormData();
                        Navigator.pushNamed(context, RouteNames.changePasswordScreen);
                      }),
                  DrawerItem(
                      icon: KImages.contactUs,
                      title: Utils.translatedText(context, 'Contact Us'),
                      isAuth: false,
                      onTap: () {
                        context.read<ContactCubit>().clearField();
                        Navigator.pushNamed(context, RouteNames.contactUsScreen);
                      }),
                  DrawerItem(
                      icon: KImages.privacy,
                      title: Utils.translatedText(context, 'Privacy Policy'),
                      isAuth: false,
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.privacyPolicyScreen,arguments: 'privacy');
                      }),
                  DrawerItem(
                      icon: KImages.faq,
                      title: Utils.translatedText(context, 'Terms and Conditions'),
                      isAuth: false,
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.privacyPolicyScreen,arguments: 'term-condition');
                      }),
                  DrawerItem(
                      icon: KImages.termCondition,
                      title: Utils.translatedText(context, 'FAQ'),
                      isAuth: false,
                      padding: Utils.only(bottom: 0.0),
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.faqScreen);
                      }),
                  const MultiLanguage(),
                  // const MultiLanguage(isLanguage:false),

                  DrawerItem(
                      icon: KImages.deleteAcc,
                      title: Utils.translatedText(context, Language.accDelete),
                      onTap: () =>deleteAccount(context)),
                  DrawerItem(
                      icon: KImages.logout,
                      title: Utils.translatedText(context, Language.logout),
                      isVisibleBorder: false,
                      onTap: () {
                        logout(context);
                        // Navigator.pushNamed(context, RouteNames.authScreen);
                      }),
                  // DrawerItem(
                  //     icon: KImages.logout,
                  //     title: Utils.translatedText(context, "Buyer App"),
                  //     onTap: () {
                  //       Navigator.pushNamed(context, RouteNames.mainScreen);
                  //     }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

deleteAccount(BuildContext context) {
  final deleteCubit = context.read<DeleteCubit>();
  Utils.showCustomDialog(
    padding: Utils.symmetric(),
    context,
    child: BlocConsumer<DeleteCubit,PasswordStateModel>(
      listener: (context,state){
        final s = state.deleteState;
        if(s is DeleteError){
          Navigator.of(context).pop();
          if(s.statusCode == 401){
            Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false);
          }
          Utils.errorSnackBar(context, s.message);
        }else if(s is DeleteLoaded){

          Navigator.of(context).pop();

          Utils.showSnackBar(context, s.message);

          Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false);
        }
      },
      builder: (context,state){
        final s = state.deleteState;
        final isValid = state.password.trim().isNotEmpty;
        return Padding(
          padding: Utils.symmetric(v: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Utils.vSize(100.0),
                width: Utils.hSize(100.0),
                padding: Utils.all(value: 20.0),
                margin: Utils.only(bottom: 16.0),
                decoration: const BoxDecoration(
                  color: redColor,
                  shape: BoxShape.circle,
                ),
                child: const CustomImage(path: KImages.deleteIcon, color: whiteColor),
              ),
              CustomText(
                text: Utils.translatedText(
                  context,
                  'Notice: Remember you will not be able to login to this account after deleting your account.',
                ),
                textAlign: TextAlign.center,
                height: 1.5,
              ),
              CustomFormWidget(
                label: Utils.translatedText(context, 'Current Password'),
                bottomSpace: 20.0,
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
                          onPressed: () => deleteCubit.showPassword(),
                          icon: Icon(
                              state.showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: grayColor),
                        ),
                      ),
                      initialValue: state.password,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (val) => deleteCubit.changeCurrentPassword(val),
                      obscureText: state.showPassword,
                    ),
                    if (s is DeleteFormError) ...[
                      if (s.errors.currentPassword.isNotEmpty)
                        ErrorText(text: s.errors.currentPassword.first)
                    ]
                  ],
                ),
              ),
              // Utils.verticalSpace(20.0),
              IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(), // Cancel action
                        child: CustomText(
                          text: Utils.translatedText(context, 'Cancel'),
                          color: redColor,
                          decorationColor: redColor,
                          fontSize: 18.0,
                          decoration: TextDecoration.underline,
                          maxLine: 1,
                        ),
                      ),
                    ),

                    Utils.horizontalSpace(20.0),

                    if(s is DeleteLoading)...[
                      const LoadingWidget(),
                    ]else...[
                      Expanded(
                        flex: 3,
                        child: PrimaryButton(
                          bgColor: isValid? primaryColor:grayColor,
                          text: Utils.translatedText(context, 'Yes Delete'),
                          onPressed: (){
                            Utils.closeKeyBoard(context);
                            if(isValid){
                              // Navigator.of(context).pop();
                              deleteCubit.deleteAccount();
                            }
                          },
                        ),
                      ),
                    ],

                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
logout(BuildContext context) {
  Utils.showCustomDialog(
    padding: Utils.symmetric(),
    context,
    child: Padding(
      padding: Utils.symmetric(v: 40.0),
      child: Utils.logout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Utils.vSize(100.0),
              width: Utils.hSize(100.0),
              padding: Utils.all(value: 10.0),
              margin: Utils.only(bottom: 16.0),
              decoration: const BoxDecoration(
                // color: redColor,
                shape: BoxShape.circle,
              ),
              child: const CustomImage(path: KImages.logout, color: redColor),
            ),
            CustomText(
              text: Utils.translatedText(context, 'Logout'),
              textAlign: TextAlign.center,
              height: 1.4,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: Utils.translatedText(context, 'Are you sure you want to Logout'),
              textAlign: TextAlign.center,
              height: 1.4,
            ),
            Utils.verticalSpace(20.0),
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Cancel action
                      child: CustomText(
                        text: Utils.translatedText(context, 'Cancel'),
                        color: redColor,
                        decorationColor: redColor,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        maxLine: 1,
                      ),
                    ),
                  ),

                  Utils.horizontalSpace(20.0),

                  Expanded(
                    flex: 3,
                    child: PrimaryButton(
                      bgColor: redColor,
                      text: Utils.translatedText(context, 'Yes Logout'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Utils.logoutFunction(context);
                        // Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
