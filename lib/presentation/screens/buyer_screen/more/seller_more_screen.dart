import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/cubit/service_list/service_list_cubit.dart';
import '../../../../logic/cubit/setting/setting_cubit.dart';
import '/logic/cubit/profile/profile_cubit.dart';
import '/presentation/screens/user_screen/user_more/buyer_more_screen.dart';
import '../../../../data/models/home/seller_model.dart';
import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../../logic/cubit/profile/profile_state.dart';
import '../../../../logic/cubit/service/service_cubit.dart';
import '../../../widgets/multi_lang_currencies.dart';
import '/presentation/utils/k_images.dart';
import '/presentation/utils/language_string.dart';
import '/presentation/widgets/custom_app_bar.dart';

import '../../../../logic/cubit/change_password/change_password_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class BuyerMoreScreen extends StatelessWidget {
  const BuyerMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar:  CustomAppBar(title: Utils.translatedText(context, 'Seller Menu'), visibleLeading: false),
     body: Padding(
       padding: Utils.symmetric(v: 20.0),
       child: SingleChildScrollView(
         scrollDirection: Axis.vertical,
         child: BlocBuilder<SettingCubit, SettingState>(
           builder: (context, state) {
             return Column(children: [
               // DrawerItem(icon: KImages.dashboardIcon, title: Utils.translatedText(context, Language.dashboard), onTap: (){}),
               //  DrawerItem(icon: KImages.jobPost, title: Utils.translatedText(context, Language.postAJob), onTap: (){
               //    // Navigator.pushNamed(context, RouteNames.jobApplicationScreen);
               //  }),
               DrawerItem(icon: KImages.myJob, title: Utils.translatedText(context, 'Recent Job Post'), onTap: (){
                 context.read<ServiceListCubit>()..initPage()..clearFilterData();
                 Navigator.pushNamed(context, RouteNames.allJobScreen);
               }),
               DrawerItem(icon: KImages.seller02,title: Utils.translatedText(context, 'Create Service'), onTap: (){
                 context.read<ServiceCubit>().clear();
                 Navigator.pushNamed(context, RouteNames.addUpdateServiceScreen);
               }),
               DrawerItem(icon: KImages.seller03, title: Utils.translatedText(context, 'Manage Service'), onTap: (){
                 Navigator.pushNamed(context, RouteNames.sellerServiceScreen);
               }),
               DrawerItem(icon: KImages.seller04, title: Utils.translatedText(context, 'My Job Applications'), onTap: (){
                 Navigator.pushNamed(context, RouteNames.sellerJobApplicationScreen);

               }),

               DrawerItem(icon: KImages.seller05, title: Utils.translatedText(context, 'Manage KYC'), onTap: (){
                 Navigator.pushNamed(context, RouteNames.kycScreen);

               }),


               if(Utils.isAddon(context)?.subscription == true)...[
                 DrawerItem(icon: KImages.seller06, title: Utils.translatedText(context, 'Subscription Plan'), onTap: (){
                   Navigator.pushNamed(context, RouteNames.subsScreen);
                 }),
                 DrawerItem(icon: KImages.seller07, title: Utils.translatedText(context, 'Purchase History'), onTap: (){
                   Navigator.pushNamed(context, RouteNames.subsHistoryScreen);
                 }),
               ],

               DrawerItem(icon: KImages.seller08, title: Utils.translatedText(context, 'Wallet Transaction'), onTap: (){
                 Navigator.pushNamed(context, RouteNames.withdrawScreen);
               }),
               DrawerItem(icon: KImages.profile, title: Utils.translatedText(context, Language.editProfile), onTap: (){
                 Navigator.pushNamed(context, RouteNames.updateProfileScreen);
               }),
               DrawerItem(icon: KImages.lock,padding: Utils.all(),
                   title: Utils.translatedText(context, 'Change Password'), onTap: () {
                     context.read<ChangePasswordCubit>().clearFormData();
                     Navigator.pushNamed(context, RouteNames.changePasswordScreen);
                   }),

               //DrawerItem(icon: KImages.live, title: Utils.translatedText(context, Language.liveChat), onTap: (){},padding: Utils.all(),),
               const MultiLanguage(),
               // const MultiLanguage(isLanguage:false),


               // DrawerItem(icon: KImages.love, title: Utils.translatedText(context, Language.wishlist), onTap: (){
               //   Navigator.pushNamed(context, RouteNames.wishlistScreen);
               // }),
               // DrawerItem(icon: KImages.privacy, title: Utils.translatedText(context, Language.privacyAndPolicy), onTap: (){}),
               // DrawerItem(icon: KImages.termsCo, title: Utils.translatedText(context, Language.termsAndCondition), onTap: (){}),

               // DrawerItem(icon: KImages.lock, title: Utils.translatedText(context, Language.changePassword), onTap: (){}),
               DrawerItem(icon: KImages.deleteAcc,padding: Utils.only(bottom: 10.0), title: Utils.translatedText(context, Language.accDelete), onTap: (){
                 deleteAccount(context);
               }),
               DrawerItem(icon: KImages.logout,title: Utils.translatedText(context, Language.logout), onTap: (){
                 // Navigator.pushNamedAndRemoveUntil(context,RouteNames.authScreen,(route)=>false)
                 logout(context);
               }),
               onlineStatusChange(context),

             ]);
           },
         ),
       ),
     ),
    );
  }
}

Widget onlineStatusChange(BuildContext context) {
  final loginBloc = context.read<LoginBloc>();
  final profile = context.read<ProfileCubit>();
  return BlocConsumer<ProfileCubit, SellerModel>(
    listener: (context,states){
      final state = states.profileState;
      if(state is ProfileStateUpdateError){
        Utils.errorSnackBar(context, state.message);
      }else if(state is ProfileOnlineStatusUpdated){
        Utils.showSnackBar(context, state.message);
        Future.delayed(const Duration(milliseconds: 800),(){
          profile.getProfileData();
        });
      }
    },
    builder: (context, state) {
      final online = state.profileState;
      // debugPrint('online_status ${profile.profile?.onlineStatus}');
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            text: Utils.translatedText(context, "Online Status"),
            color: blackColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
          Container(
            height: Utils.vSize(30.0),
            width: Utils.vSize(30.0),
            margin: Utils.only(left: 20.0, bottom: 6.0),
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: profile.profile?.onlineStatus == 1,
                // value: state.onlineStatus == 1,
                //checkColor: Colors.white,
                activeColor: primaryColor,
                onChanged: (bool? val){
                  if(online is! GetProfileLoading){
                    profile.updateProfileAvatar(true);
                  }
                },
                // onChanged: (val) {
                //   final homeController = MainController();
                //   if (loginBloc.userInfo != null &&
                //       loginBloc.userInfo!.isVendor == 0) {
                //     Utils.showSnackBarWithAction(
                //         context,
                //         Utils.translatedText(context, "You are not a vendor"),
                //             () => Navigator.pushNamed(
                //             context, RouteNames.becomeSellerScreen));
                //   } else {
                //     if (val) {
                //       homeController.naveListener.add(3);
                //     } else {
                //       //homeController.naveListener.add(2);
                //     }
                //     loginBloc.add(RememberIsSellerEvent(state.isSeller));
                //   }
                // },
              ),
            ),
          ),
        ],
      );
    },
  );
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isVisibleBorder = true,
    this.version = false,
    this.isAuth = true,
    this.padding
  });

  final String icon;
  final String title;
  final bool isVisibleBorder;
  final bool version;
  final VoidCallback onTap;
  final bool  isAuth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? Utils.symmetric(v: 20.0, h: 0.0).copyWith(top: 0.0, bottom: 20.0),
      child: Column(
        children: [
          if(isAuth)...[
            GestureDetector(
              onTap: Utils.isLoggedIn(context)?onTap:  (){

                Utils.showSnackBarWithLogin(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomImage(
                        path: icon,
                        fit: BoxFit.cover,
                        height: 22.0,
                      ),
                      Utils.horizontalSpace(12.0),
                      CustomText(
                        text: title,
                        color: blackColor,
                        fontSize: 16.0,
                      ),
                    ],
                  ),
                  version
                      ? const CustomText(
                    text: '1.0.0',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ]else...[
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomImage(
                        path: icon,
                        fit: BoxFit.cover,
                        height: 22.0,
                      ),
                      Utils.horizontalSpace(12.0),
                      CustomText(
                        text: title,
                        color: blackColor,
                        fontSize: 16.0,
                      ),
                    ],
                  ),
                  version
                      ? const CustomText(
                    text: '1.0.0',
                    color: blackColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
          isVisibleBorder
              ? Container(
            height: 1.0,
            width: double.infinity,
            margin: Utils.only(right: 20.0, top: 20.0),
            color: stockColor,
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}

