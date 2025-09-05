import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/setting/splash_model.dart';
import '../../../../logic/cubit/home/home_cubit.dart';
import '../../../../logic/cubit/setting/setting_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';


class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  // final List<SplashModel> sliders;

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  PageController controller =
  PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  final int initialPage = 0;
  int _currentIndex = 0;

  late HomeCubit slider;


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    slider = context.read<HomeCubit>();
  }

  @override
  Widget build(BuildContext context) {
    if(slider.homeModel?.sliders?.isNotEmpty ??false){
    // if(widget.sliders.isNotEmpty){
      return Container(
        height: Utils.mediaQuery(context).height * 0.22,
        width: Utils.mediaQuery(context).width,
        margin: Utils.symmetric(v: 20.0,h: 0.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: Utils.mediaQuery(context).height * 0.25,
                viewportFraction: 1,
                initialPage: initialPage,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
              ),
              items: slider.homeModel?.sliders?.isNotEmpty??false?slider.homeModel?.sliders?.map((e) =>  SliverItem(slider: e))
                  .toList():[],
            ),
            Positioned(
              left: Utils.mediaQuery(context).width * 0.15,
              bottom: Utils.mediaQuery(context).height * 0.015,
              child: _buildDotIndicator(),
            ),
          ],
        ),
      );
    }else{
      return const SizedBox.shrink();
    }
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          slider.homeModel?.sliders?.length??0,
            (index) {
          final i = _currentIndex == index;
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: Utils.vSize(6.0),
            width: Utils.hSize(i ? 24.0 : 6.0),
            margin: const EdgeInsets.only(right: 4.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(i ? 50.0 : 5.0),
              //shape: i ? BoxShape.rectangle : BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

}


class SliverItem extends StatelessWidget {
  const SliverItem({super.key, required this.slider});
  final SplashModel? slider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(
        //     context, RouteNames.serviceListScreen, arguments: {
        //   'title':
        //   Utils.translatedText(context, 'Feature Services'),
        //   'slug': 'feature'
        // });
      },
      child: Container(
      height: Utils.mediaQuery(context).height * 0.22,
        width: Utils.mediaQuery(context).width,
        margin: Utils.symmetric(h: 16.0),
        // decoration: BoxDecoration(
        //   color: secondaryColor,
        // ),
        child:  Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: Utils.borderRadius(r: 6.0),
              child: CustomImage(
                path: RemoteUrls.imageUrl(slider?.image??''),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: Utils.borderRadius(r: 6.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    blackColor.withOpacity(0.6),
                    transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30.0,
              left: 15.0,
              child: SizedBox(
                width: Utils.hSize(180.0),
                height: Utils.vSize(100.0),
                child: HtmlWidget(slider?.title??'',textStyle: const TextStyle(color: whiteColor,fontWeight: FontWeight.w700,fontSize: 22.0,height: 1.2)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

