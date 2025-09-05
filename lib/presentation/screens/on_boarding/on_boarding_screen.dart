import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubit/setting/setting_cubit.dart';
import '/data/data_provider/remote_url.dart';
import '../../routes/route_names.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/primary_button.dart';
import 'components.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late int _numPages;
  late PageController _pageController;
  late SettingCubit setting;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    setting = context.read<SettingCubit>();

    if(setting.splashes?.isNotEmpty??false){
      _numPages = setting.splashes?.length ?? 0;
    }else{
      _numPages = onBoardingData.length;
    }

    _pageController = PageController(initialPage: _currentPage);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SizedBox(
        height: Utils.mediaQuery(context).height,
        width: Utils.mediaQuery(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.06),
            _buildSkipButton(),
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.16),
            _buildImagesSlider(),
            Utils.verticalSpace(Utils.mediaQuery(context).height * 0.04),
            _buildContent(),
            Utils.verticalSpace(40.0),
            _buildDotIndicator(),
            Utils.verticalSpace(40.0),
            Padding(
              padding: Utils.symmetric(h: 30),
              child: PrimaryButton(
                text: Utils.translatedText(context, 'Next'),
                textColor: whiteColor,
                onPressed: () {
                  if (_currentPage == onBoardingData.length - 1) {
                    context.read<SettingCubit>().cacheOnBoarding();
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.authScreen, (route) => false);
                    // Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
                  } else {
                    _pageController.nextPage(
                        duration: kDuration, curve: Curves.easeInOut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesSlider() {
    return Container(
      height: Utils.mediaQuery(context).height * 0.3,
      padding: Utils.all(value: 4),
      child: PageView(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          if (setting.splashes?.isNotEmpty ?? false) ...[
            ...?setting.splashes?.map((e) => CustomImage(path: RemoteUrls.imageUrl(e.splashScreen1??''))),
          ] else ...[
            ...onBoardingData.map((e) => CustomImage(path: e.image)),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: Utils.symmetric(h: 20.0),
      child: AnimatedSwitcher(
        duration: kDuration,
        transitionBuilder: (Widget child, Animation<double> anim) {
          return FadeTransition(opacity: anim, child: child);
        },
        child: getContent(),
      ),
    );
  }

  Widget getContent() {
    final item = onBoardingData[_currentPage];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      key: ValueKey('$_currentPage'),
      children: [
        if(setting.splashes?.isNotEmpty??false)...[
          if(setting.splashes?[_currentPage].splashScreen1Title?.isNotEmpty??false)...[
            CustomText(
              text: setting.splashes?[_currentPage].splashScreen1Title ??'',
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              color: blackColor,
              height: 1.2,
            ),
          ]else...[
            CustomText(
              text: item.title,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              color: blackColor,
              height: 1.2,
            ),
          ],

        ]else...[
          CustomText(
            text: item.title,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            color: blackColor,
            height: 1.2,
          ),
        ],
      ],
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onBoardingData.length,
        (index) {
          final i = _currentPage == index;
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: Utils.vSize(6.0),
            width: Utils.hSize(i ? 24.0 : 6.0),
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
              color: i ? primaryColor : primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(i ? 50.0 : 5.0),
              //shape: i ? BoxShape.rectangle : BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: () {
        context.read<SettingCubit>().cacheOnBoarding();
        Navigator.pushNamedAndRemoveUntil(context, RouteNames.authScreen, (route) => false);
        // Navigator.pushNamedAndRemoveUntil(context, RouteNames.mainScreen, (route) => false);
      },
      child: Container(
        alignment: Alignment.centerRight,
        margin: Utils.only(right: 20.0),
        child:  CustomText(
          text: Utils.translatedText(context, 'Skip'),
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          color: blackColor,
        ),
      ),
    );
  }
}
