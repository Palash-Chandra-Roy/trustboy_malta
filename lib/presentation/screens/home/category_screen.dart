import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/logic/cubit/home/home_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import 'component/category_list.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'All Categories')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: Utils.symmetric(h: 0.0).copyWith(bottom: Utils.mediaQuery(context).height * 0.05),
        child: Column(
          children: [
            if (homeCubit.homeModel?.categories?.isNotEmpty??false) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: Utils.mediaQuery(context).width,
                    child: Wrap(
                      runSpacing: 12.0,
                      spacing: 12.0,
                      // alignment: (homeCubit.homeModel?.categories?.length ?? 0) % 3 == 1
                      //     ? WrapAlignment.center
                      //     : WrapAlignment.center,
                      alignment:  WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: List.generate((homeCubit.homeModel?.categories?.length ?? 0), (index) {
                        final item = homeCubit.homeModel?.categories?[index];
                        return CategoryCart(category: item,width: Utils.mediaQuery(context).width * 0.28);
                      }),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // EmptyWidget(
              //     icon: KImages.serviceNotFound,
              //     title: Utils.translatedText(context, 'Service Not Found'),
              //     subtitle: '')
            ],
          ],
        ),
      ),
    );
  }
}
