import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/cubit/service_list/service_list_cubit.dart';
import '/data/data_provider/remote_url.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/utils/utils.dart';
import '/presentation/widgets/custom_image.dart';
import '/presentation/widgets/custom_text.dart';

import '../../../../data/models/home/category_model.dart';
import '../../../routes/route_names.dart';
import 'heading.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Heading(
          title1: Utils.translatedText(context, 'Our Popular Categories'),
          padding: Utils.symmetric().copyWith(bottom: 20.0),
          onTap: () {
            Navigator.pushNamed(context, RouteNames.categoryScreen);
          },
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: List.generate(
              categories.length > 4 ? 4 : categories.length,
              (index) => Padding(
                padding: Utils.only(
                    left: index == 0 ? 20.0 : 0.0,
                    right: index == 5 - 1 ? 10.0 : 10.0),
                child: CategoryCart(category: categories[index]),
              ),
            ),
          ),
        ),
        // Utils.verticalSpace(20.0),
      ],
    );
  }
}

class CategoryCart extends StatelessWidget {
  const CategoryCart({super.key, required this.category, this.width});

  final CategoryModel? category;
  final double? width;

  @override
  Widget build(BuildContext context) {
    print(
      RemoteUrls.imageUrl(category?.icon ?? ''),
    );
    return GestureDetector(
      onTap: () {
        if (category?.slug.isNotEmpty ?? false) {
          context.read<ServiceListCubit>()
            ..initPage()
            ..clearFilterData()
            ..nameText(category?.id.toString() ?? '');
          debugPrint(
              'id-name-slug ${category?.id} - ${category?.name} - ${category?.slug}');
          Navigator.pushNamed(context, RouteNames.allServiceScreen);
        }
      },
      child: Container(
        width: width ?? Utils.mediaQuery(context).width * 0.25,
        padding: Utils.symmetric(h: 0.0, v: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: whiteColor,
        ),
        child: Padding(
          padding: Utils.symmetric(h: 5.0, v: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: RemoteUrls.imageUrl(category?.icon ?? ''),
                height: 36.0,
              ),
              Utils.verticalSpace(15.0),
              CustomText(
                text: category?.name ?? '',
                fontSize: 12.0,
                textAlign: TextAlign.center,
                maxLine: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
