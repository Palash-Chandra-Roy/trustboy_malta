// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils/k_images.dart';
import '../utils/utils.dart';
import 'common_container.dart';
import 'custom_image.dart';
import 'custom_text.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({
    super.key,
    required this.image,
    this.text,
    this.space = 10.0,
    this.height = 0.0,
    this.isSliver = true,
    this.child = const SizedBox(),
  });

  final String image;
  final String? text;
  final double space;
  double height;
  final bool isSliver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    height = size.height * 0.6;
    if (isSliver) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: height,
          width: size.width,
          child: Padding(
            padding: Utils.all(value: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(path: image),
                Utils.verticalSpace(space),
                CustomText(text: text??Utils.translatedText(context, 'Sorry!! Service Not Found'), fontSize: 22.0, fontWeight: FontWeight.w700),
                child,
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: height,
        width: size.width,
        child: Padding(
          padding: Utils.all(value: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImage(path: image),
              Utils.verticalSpace(space),
              CustomText(text: text??Utils.translatedText(context, 'Sorry!! Service Not Found'), fontSize: 22.0, fontWeight: FontWeight.w700),
              child,
            ],
          ),
        ),
      );
    }
  }
}



class EmptyWidget2 extends StatelessWidget {
  const EmptyWidget2({
    super.key,
    this.image,
    this.text,
    this.subText,
    this.isSliver = true,
    this.child = const SizedBox(),
  });

  final String? image;
  final String? text;
  final String? subText;
  final bool isSliver;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return SliverToBoxAdapter(
        child: CommonContainer(
          padding: Utils.symmetric(v: 40.0),
          margin: Utils.symmetric(v: Utils.mediaQuery(context).height / 5.5).copyWith(bottom: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               CustomImage(path: image??KImages.emptyOrder),
              Utils.verticalSpace(20.0),
              CustomText(
                text: Utils.translatedText(context, text?? 'Order Empty'),
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              if(subText?.isNotEmpty??false)...[
                Utils.verticalSpace(10.0),
                CustomText(
                    text: Utils.translatedText(context, subText??''),
                    textAlign: TextAlign.center),
              ]
            ],
          ),
        )
      );
    } else {
      return CommonContainer(
        padding: Utils.symmetric(v: 40.0),
        margin: Utils.symmetric(v: Utils.mediaQuery(context).height / 5.5).copyWith(bottom: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             CustomImage(path: image??KImages.emptyOrder),
            Utils.verticalSpace(10.0),
            CustomText(
              text: Utils.translatedText(context, text?? 'Order Empty'),
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            if(subText?.isNotEmpty??false)...[
              Utils.verticalSpace(10.0),
              CustomText(
                  text: Utils.translatedText(context, subText??''),
                  textAlign: TextAlign.center),
            ]
          ],
        ),
      );
    }
  }
}
