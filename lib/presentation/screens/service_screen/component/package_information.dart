import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/service/service_item.dart';
import '../../../../logic/cubit/service/service_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/horizontal_line.dart';
import 'package_tab/basic_package_tab.dart';
import 'package_tab/premium_package_tab.dart';
import 'package_tab/standard_package_tab.dart';

class PackageInformation extends StatefulWidget {
  const PackageInformation({super.key});

  @override
  State<PackageInformation> createState() => _BasicInformationState();
}

class _BasicInformationState extends State<PackageInformation> {

  late ServiceCubit sCubit;
  late List<Widget> packageTabs;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    sCubit = context.read<ServiceCubit>();
    packageTabs = const[
      BasicPackageTab(),
      StandardPackageTab(),
      PremiumPackageTab(),
    ];
  }

    @override
  Widget build(BuildContext context) {
    return CommonContainer(
      // padding: Utils.all(),
      child: BlocBuilder<ServiceCubit, ServiceItem>(
        builder: (context,state){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(text: Utils.translatedText(context, 'Pricing Package'),fontSize: 18.0,fontWeight: FontWeight.w600),
              const HorizontalLine(),
              const PackageTab(),

              packageTabs[state.packageTab],

              /* CustomFormWidget(
            label: Utils.translatedText(context, 'Category'),
            bottomSpace: 20.0,
            child:  BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                final post = state.serviceState;

                if (state.categoryId != 0 && (sCubit.editInfo?.categories?.isNotEmpty??false)) {
                  _category = sCubit.editInfo?.categories?.where((type) => type.id == state.categoryId)
                      .first;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     DropdownButtonFormField<CategoryModel>(
                       hint:  CustomText(text:Utils.translatedText(context, 'Select Category')),
                       isDense: true,
                       isExpanded: true,
                       value: _category,
                       icon: const Icon(Icons.keyboard_arrow_down),
                       decoration: InputDecoration(
                           isDense: true,
                           border:  outlineBorder(),
                           enabledBorder: outlineBorder(),
                           focusedBorder: outlineBorder()
                       ),
                       borderRadius: Utils.borderRadius(r: 5.0),
                        dropdownColor: whiteColor,
                       onTap: (){
                         if(state is! ServiceInitial){
                           sCubit.initState();
                         }

                         if(state.subCategoryId != 0 && (state.subCategories?.isNotEmpty??false)){
                           sCubit..subCategoryId(0)..clearSubCat();
                         }
                       },
                       onChanged: (value) {
                         if (value == null) return;
                         sCubit..categoryId(value.id)..filterSubCategories();
                       },
                       items: sCubit.editInfo?.categories?.isNotEmpty??false?sCubit.editInfo?.categories?.map<DropdownMenuItem<CategoryModel>>(
                             (CategoryModel value) => DropdownMenuItem<CategoryModel>(
                           value: value,
                           child: CustomText(text: value.name),
                         ),
                       ).toList():[],
                     ),
                     if (post is ServiceAddFormError) ...[
                       if(state.title.isNotEmpty & state.slug.isNotEmpty)
                         if (post.errors.categoryId.isNotEmpty)
                           ErrorText(text: post.errors.categoryId.first),
                     ],
                   ],
                );
              },
            ),
          ),*/

            ],
          );
        },
      ),
    );
  }
}


class PackageTab extends StatelessWidget {
  const PackageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final jCubit = context.read<ServiceCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: Utils.all(),
      physics: const BouncingScrollPhysics(),
      child: BlocBuilder<ServiceCubit, ServiceItem>(
        builder: (context,state){
          List<String> orderTabItems = [
            Utils.translatedText(context, 'Basic'),
            Utils.translatedText(context, 'Standard'),
            Utils.translatedText(context, 'Premium'),
          ];
          return SizedBox(
            width: Utils.mediaQuery(context).width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                orderTabItems.length,
                    (index) {
                  final active = state.packageTab == index;
                  return GestureDetector(
                    onTap: () => jCubit.changePacTab(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        // border: Border.all(color: primaryColor),
                        color: active ? secondaryColor : secondaryColor.withOpacity(0.1),
                        borderRadius: Utils.borderRadius(r: 4.0),
                      ),
                      padding: Utils.symmetric(v: 10.0, h: 20.0),
                      margin: Utils.only(right: 10.0,bottom: 16.0, top: 10.0),
                      // margin: Utils.only(left: index == 0 ? 0.0 : 12.0, bottom: 10.0, top: 14.0),
                      child: CustomText(
                        text: orderTabItems[index],
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: active?whiteColor: blackColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

