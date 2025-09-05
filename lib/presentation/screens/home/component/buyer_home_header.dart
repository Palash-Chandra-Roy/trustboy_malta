import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/multi_lang_currencies.dart';
import '/data/models/home/seller_model.dart';
import '/presentation/widgets/circle_image.dart';
import '/state_injection_packages.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../routes/route_names.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';

class BuyerHomeHeader extends StatefulWidget {
  const BuyerHomeHeader({super.key});

  @override
  State<BuyerHomeHeader> createState() => _BuyerHomeHeaderState();
}

class _BuyerHomeHeaderState extends State<BuyerHomeHeader> {

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
    if (profileData.profile?.image.isNotEmpty??false) {
      image = RemoteUrls.imageUrl(profileData.profile?.image??Utils.defaultImg(context));
      name = profileData.profile?.name??context.read<LoginBloc>().userInformation?.user?.name??Utils.translatedText(context, 'Your name');
    } else {
      image = RemoteUrls.imageUrl(Utils.defaultImg(context));
      name = context.read<LoginBloc>().userInformation?.user?.name??Utils.translatedText(context, 'Your name');
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: Utils.vSize(size.height * 0.22),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Utils.vSize(size.height * 0.2),
            // padding: Utils.symmetric().copyWith(right: 26.0),
            color: secondaryColor,
            margin: Utils.only(bottom: 10.0),
            child: BlocBuilder<ProfileCubit, SellerModel>(
                builder: (context, state) {
                  _initState();

                  return Container(
                    height: Utils.mediaQuery(context).height * 0.16,
                    width: Utils.mediaQuery(context).width,
                    padding: Utils.symmetric().copyWith(right: 12.0,top: 12.0),
                    // margin: Utils.only(bottom: 20.0),
                    color: secondaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Utils.mediaQuery(context).height * 0.16,
                          width: Utils.mediaQuery(context).width * 0.6,
                          color: secondaryColor,
                          child: GestureDetector(
                            onTap: () {
                              if(Utils.isLoggedIn(context)){
                                Navigator.pushNamed(context, RouteNames.updateProfileScreen);
                              }else{
                                Utils.showSnackBarWithLogin(context);
                              }
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



                  /*return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(Utils.isLoggedIn(context)){
                                  Navigator.pushNamed(context, RouteNames.updateProfileScreen);
                                }else{
                                  Utils.showSnackBarWithLogin(context);
                                }
                              },
                              child: CircleImage(size: 52.0,image: image),
                            ),
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
                                    maxLine: 1,
                                  ),
                                ],
                              ),
                            ),
                            const MultiLanguage(isLanguage: false),
                          ],
                     );*/
                },
              ),
          ),
          Positioned(
            bottom: -10.0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RouteNames.allServiceScreen);
                },
                child: Container(
                    width: double.infinity,
                    height: Utils.vSize(48.0),
                    margin: Utils.symmetric(),
                    padding: Utils.symmetric(),
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: Utils.borderRadius(r: 500.0),
                      border: Border.all(
                        color: borderColor,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 40,
                          offset: Offset(0, 2),
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Row(
                      children: [CustomText(
                        text:Utils.translatedText(context, 'Search..'),
                        color: gray5B,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      )],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
