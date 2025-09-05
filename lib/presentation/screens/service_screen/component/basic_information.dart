import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/data/models/service/service_item.dart';
import 'package:work_zone/logic/cubit/service/service_cubit.dart';
import 'package:work_zone/presentation/widgets/common_container.dart';
import 'package:work_zone/presentation/widgets/custom_text.dart';
import 'package:work_zone/presentation/widgets/horizontal_line.dart';

import '../../../../data/models/home/category_model.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/error_text.dart';

class BasicInformation extends StatefulWidget {
  const BasicInformation({super.key});

  @override
  State<BasicInformation> createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {

  late ServiceCubit sCubit;
  CategoryModel ? _category;
  CategoryModel ? _subCategory;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    sCubit = context.read<ServiceCubit>();
  }

  // @override
  // void dispose() {
  //   if(sCubit.editInfo != null){
  //     sCubit.editInfo = null;
  //   }
  //   super.dispose();
  // }

    @override
  Widget build(BuildContext context) {
    return CommonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: Utils.translatedText(context, 'Basic Information'),fontSize: 18.0,fontWeight: FontWeight.w600),
          const HorizontalLine(),

          CustomFormWidget(
            label: Utils.translatedText(context, 'Title'),
            bottomSpace: 20.0,
            child: BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                final post = state.serviceState;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: state.title,
                      onChanged: sCubit.titleChange,
                      decoration:  InputDecoration(
                          hintText: Utils.translatedText(context, 'Title',true),
                          border:  outlineBorder(),
                          enabledBorder: outlineBorder(),
                          focusedBorder: outlineBorder()
                      ),
                      keyboardType: TextInputType.text,

                    ),
                    if (post is ServiceAddFormError) ...[
                      if (post.errors.title.isNotEmpty)
                        ErrorText(text: post.errors.title.first),
                    ],
                    if (post is ServiceAddFormError) ...[
                      if(state.title.isNotEmpty)
                        if (post.errors.slug.isNotEmpty)
                          ErrorText(text: post.errors.slug.first),
                    ],

                  ],
                );
              },
            ),
          ),

          CustomFormWidget(
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
          ),

          CustomFormWidget(
            label: Utils.translatedText(context, 'Sub Category'),
            bottomSpace: 20.0,
            child:   BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                final post = state.serviceState;
                if (state.subCategoryId != 0 && (state.subCategories?.isNotEmpty??false)) {
                  _subCategory = state.subCategories?.where((type) => type.id == state.subCategoryId)
                      .first;
                }else{
                  _subCategory = null;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<CategoryModel>(
                      hint:  CustomText(text:Utils.translatedText(context, 'Select Sub Category')),
                      isDense: true,
                      isExpanded: true,
                      value: _subCategory,
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
                      },
                      onChanged: (value) {
                        if (value == null) return;
                        sCubit.subCategoryId(value.id);
                      },
                      items: state.subCategories?.isNotEmpty??false?state.subCategories?.map<DropdownMenuItem<CategoryModel>>(
                            (CategoryModel value) => DropdownMenuItem<CategoryModel>(
                          value: value,
                          child: CustomText(text: value.name),
                        ),
                      ).toList():[],
                    ),
                    if (post is ServiceAddFormError) ...[
                      if(state.categoryId != 0)
                        if (post.errors.subCategoryId.isNotEmpty)
                          ErrorText(text: post.errors.subCategoryId.first),
                    ],
                  ],
                );

              },
            ),
          ),

          CustomFormWidget(
            label: Utils.translatedText(context, 'Description'),
            bottomSpace: 20.0,
            child: BlocBuilder<ServiceCubit, ServiceItem>(
              builder: (context, state) {
                final post = state.serviceState;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: state.description,
                      onChanged: sCubit.descriptionChange,
                      decoration:  InputDecoration(
                          hintText: Utils.translatedText(context, 'Description',true),
                          border:  outlineBorder(10.0),
                          enabledBorder: outlineBorder(10.0),
                          focusedBorder: outlineBorder(10.0),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,

                    ),
                    if (post is ServiceAddFormError) ...[
                      if(state.categoryId != 0 || state.subCategoryId != 0)
                      if (post.errors.description.isNotEmpty)
                        ErrorText(text: post.errors.description.first),
                    ],

                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
