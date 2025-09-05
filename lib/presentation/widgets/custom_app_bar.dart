import 'package:flutter/material.dart';
import 'package:work_zone/presentation/utils/k_images.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';

import '../utils/constraints.dart';
import '../utils/utils.dart';
import 'custom_text.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.horSpace = 24.0,
    this.bgColor = scaffoldBgColor,
    this.textColor = blackColor,
    this.iconColor = blackColor,
    this.visibleLeading = true,
    this.iconBgColor = primaryColor,
    this.action = const [],
  });
  final String title;
  final double horSpace;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final bool visibleLeading;
  final Color iconBgColor;
  final Function()? onTap;
  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (visibleLeading)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_sharp,
                size: 26.0,
                color: Color(0xFF040415),
              ),
            ),
          // Utils.horizontalSpace(horSpace),
          const Spacer(),
          CustomText(
            text: title,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          const Spacer(),
        ],
      ),
      actions: action,
      toolbarHeight: Utils.vSize(70.0),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(70.0));
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        margin: Utils.only(left: 10.0),
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     color: whiteColor,
        //     shape: BoxShape.circle,
        //     border: Border.all(color: stockColor)
        // ),
        child: Padding(
          padding: Utils.only(left: 6.0),
          child: const CustomImage(path: KImages.backArrow,color: blackColor),
          // child: const Icon(Icons.arrow_back,color: blackColor),
        ),
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.isShowBackButton = true,
    this.textSize = 18.0,
    this.fontWeight = FontWeight.w400,
    this.textColor = blackColor,
    this.height = 60.0,
  });

  final String title;
  final bool isShowBackButton;
  final double textSize;
  final FontWeight fontWeight;
  final Color textColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: scaffoldBgColor,
      leadingWidth: 60.0,
      // toolbarHeight: 50.0,
      leading: isShowBackButton? const BackButtonWidget():  const SizedBox.shrink(),
      title:  CustomText(
        text: title,
        fontSize: textSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }

  // Row buildRow() {
  //   return Row(
  //   children: [
  //     isShowBackButton ? const BackButtonWidget() : const SizedBox(),
  //     CustomText(
  //       text: title,
  //       fontSize: textSize,
  //       fontWeight: fontWeight,
  //       color: textColor,
  //     )
  //   ],
  // );
  // }

  @override
  Size get preferredSize => Size(double.infinity, height);
}


/*
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.horSpace = 24.0,
    this.bgColor = scaffoldBgColor,
    this.textColor = blackColor,
    this.iconColor = blackColor,
    this.visibleLeading = true,
    this.iconBgColor = primaryColor,
    this.action = const [],
  });
  final String title;
  final double horSpace;
  final Color bgColor;
  final Color textColor;
  final Color iconColor;
  final bool visibleLeading;
  final Color iconBgColor;
  final Function()? onTap;
  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      centerTitle: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (visibleLeading)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_sharp,
                size: 26.0,
                color: Color(0xFF040415),
              ),
            ),
          // Utils.horizontalSpace(horSpace),
          const Spacer(),
          CustomText(
            text: title,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          const Spacer(),
        ],
      ),
      actions: action,
      toolbarHeight: Utils.vSize(70.0),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(70.0));
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.iconColor});
  final Color ? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        margin: Utils.only(left: 10.0),
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     color: whiteColor,
        //     shape: BoxShape.circle,
        //     border: Border.all(color: stockColor)
        // ),
        child: Padding(
          padding: Utils.only(left: 6.0),
          child:  CustomImage(path: KImages.backArrow,color: iconColor??blackColor),
          // child: const Icon(Icons.arrow_back,color: blackColor),
        ),
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.isShowBackButton = true,
    this.textSize = 18.0,
    this.fontWeight = FontWeight.w400,
    this.textColor = blackColor,
    this.bgColor = scaffoldBgColor,
    this.iconBgColor,
    this.height = 60.0,
  });

  final String title;
  final bool isShowBackButton;
  final double textSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color bgColor;
  final double height;
  final Color? iconBgColor;

  @override
  Widget build(BuildContext context) {
    // final iColor = iconBgColor ?? blackColor;

    final Brightness iconBrightness = bgColor.computeLuminance() > 0.5
        ? Brightness.dark
        : Brightness.light;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: bgColor,
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: iconBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));


    return AppBar(
      backgroundColor: bgColor,
      leadingWidth: 60.0,
      leading: isShowBackButton?  BackButtonWidget(iconColor: iconBgColor):  const SizedBox.shrink(),
      title:  CustomText(
        text: title,
        fontSize: textSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }

  // Row buildRow() {
  //   return Row(
  //   children: [
  //     isShowBackButton ? const BackButtonWidget() : const SizedBox(),
  //     CustomText(
  //       text: title,
  //       fontSize: textSize,
  //       fontWeight: fontWeight,
  //       color: textColor,
  //     )
  //   ],
  // );
  // }

  @override
  Size get preferredSize => Size(double.infinity, height);
}*/
