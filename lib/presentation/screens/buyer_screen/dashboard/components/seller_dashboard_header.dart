import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/data_provider/remote_url.dart';
import '../../../../../data/models/home/seller_model.dart';
import '../../../../../logic/bloc/login/login_bloc.dart';
import '../../../../../logic/cubit/profile/profile_cubit.dart';
import '../../../../routes/route_names.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/circle_image.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/multi_lang_currencies.dart';

class SellerDashboardHeader extends StatefulWidget implements PreferredSizeWidget {
  const SellerDashboardHeader({super.key});

  @override
  State<SellerDashboardHeader> createState() => _SellerDashboardHeaderState();

  @override
  Size get preferredSize =>  Size(double.infinity, Utils.vSize(130.0));
}

class _SellerDashboardHeaderState extends State<SellerDashboardHeader> {
  late ProfileCubit profileData;
  late String image;
  late String name;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    profileData = context.read<ProfileCubit>();
    if (profileData.profile?.image.isNotEmpty ?? false) {
      image = RemoteUrls.imageUrl(
          profileData.profile?.image ?? Utils.defaultImg(context));
      name = profileData.profile?.name ?? context.read<LoginBloc>().userInformation?.user?.name ??
          'Demo name';
    } else {
      image = RemoteUrls.imageUrl(Utils.defaultImg(context));
      name = context.read<LoginBloc>().userInformation?.user?.name ?? 'Demo name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, SellerModel>(
      builder: (context, state) {
        _initState();
        return Container(
          height: Utils.mediaQuery(context).height * 0.16,
          width: Utils.mediaQuery(context).width,
          padding: Utils.symmetric().copyWith(right: 12.0,top: 12.0),
          // margin: Utils.only(bottom: 20.0),
          color: secondaryColor,
          child: Row(
            children: [
              Container(
                height: Utils.mediaQuery(context).height * 0.16,
                width: Utils.mediaQuery(context).width * 0.6,
                color: secondaryColor,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.updateProfileScreen);
                    // Navigator.pushNamedAndRemoveUntil(context, RouteNames.authScreen,(route)=>false);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleImage(size: 52.0, image: image),
                      Utils.horizontalSpace(10.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: Utils.translatedText(context, 'Good Morning!'),
                              color: whiteColor,
                              fontSize: 12.0,
                              maxLine: 1,
                            ),
                            CustomText(
                              text: name,
                              color: whiteColor,
                              fontSize: 16.0,
                              maxLine: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const MultiLanguage(isLanguage: false),

            ],
          ),
        );
      },
    );
  }
}