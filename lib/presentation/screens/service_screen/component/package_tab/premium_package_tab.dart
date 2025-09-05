import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/dummy_data/dummy_data.dart';
import '../../../../../data/models/service/service_item.dart';
import '../../../../../logic/cubit/service/service_cubit.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/error_text.dart';
import '../../../../widgets/horizontal_line.dart';
import 'basic_package_tab.dart';

class PremiumPackageTab extends StatefulWidget {
  const PremiumPackageTab({super.key});

  @override
  State<PremiumPackageTab> createState() => _PremiumPackageTabState();
}

class _PremiumPackageTabState extends State<PremiumPackageTab> {
  late ServiceCubit sCubit;
  DummyPackage ? _deliveryTime;
  DummyPackage ? _revisions;
  DummyPackage ? _functional;
  DummyPackage ? _numberOfPages;
  DummyPackage ? _responsive;
  DummyPackage ? _sourceCode;
  DummyPackage ? _contents;
  DummyPackage ? _optimize;

  late PackageItem item;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    sCubit = context.read<ServiceCubit>();
    item = PackageItem.errors('premium');
  }

  InputDecoration _decoration(){
    return const InputDecoration(
      isDense: true,
      border:  InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Utils.symmetric(h: 0.0,v: 0.0),//value: 6.0
      decoration: BoxDecoration(
        border: Border.all(color: stockColor,width: 1.5),
        borderRadius: Utils.borderRadius(r: 4.0),
      ),
      child: Column(
        children: [
          packageHeading(context,'Premium Package'),
          HorizontalLine(color: gray5B,margin: Utils.all()),

          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.premium?.description??'',
                    onChanged: (String text){
                      final package = state.premium?.copyWith(description: text) ;
                      // final package = PackageItem(description: text);
                      sCubit.addPackage(package);
                    },
                    decoration:  InputDecoration(
                      hintText: Utils.translatedText(context, 'Description',true),
                      border:  InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,

                  ),
                  if (post is ServiceAddFormError) ...[
                    if (post.errors.package[PackageItem.errors('premium').description]?.isNotEmpty??false)
                      ErrorText(text: post.errors.package[PackageItem.errors('premium').description]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),

          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.delivery.isNotEmpty??false) {
                _deliveryTime = deliveryTime.where((type) => type.title == state.premium?.delivery)
                    .first;
              }else{
                _deliveryTime = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Select Delivery Time')),
                    isDense: true,
                    isExpanded: true,
                    value: _deliveryTime,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,
                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(delivery: value.title) ;
                      sCubit.addPackage(package);
                    },
                    items: deliveryTime.map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.description.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').delivery]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').delivery]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),

          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.revision.isNotEmpty??false) {
                _revisions = revisions.where((type) => type.title == state.premium?.revision)
                    .first;
              }else{
                _revisions = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Revision')),
                    isDense: true,
                    isExpanded: true,
                    value: _revisions,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,

                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(revision: value.title) ;
                      sCubit.addPackage(package);
                    },
                    items: revisions.map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.delivery.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').revision]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').revision]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.website.isNotEmpty??false) {
                _functional = functionalWeb(context).where((type) => type.value == state.premium?.website)
                    .first;
              }else{
                _functional = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Functional Website')),
                    isDense: true,
                    isExpanded: true,
                    value: _functional,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,

                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(website: value.value) ;
                      sCubit.addPackage(package);
                    },
                    items: functionalWeb(context).map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.revision.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').website]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').website]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.page.isNotEmpty??false) {
                _numberOfPages = numberOfPages.where((type) => type.title == state.premium?.page)
                    .first;
              }else{
                _numberOfPages = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Number of Page')),
                    isDense: true,
                    isExpanded: true,
                    value: _numberOfPages,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,
                    onChanged: (value) {
                      if (value == null) return;
                      final package = state.premium?.copyWith(page: value.title) ;
                      sCubit.addPackage(package);
                    },
                    items: numberOfPages.map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.website.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').page]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').page]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.responsive.isNotEmpty??false) {
                _responsive = responsive(context).where((type) => type.value == state.premium?.responsive)
                    .first;
              }else{
                _responsive = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Responsive design')),
                    isDense: true,
                    isExpanded: true,
                    value: _responsive,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(responsive: value.value) ;
                      sCubit.addPackage(package);
                    },
                    items: responsive(context).map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.page.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').responsive]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').responsive]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.code.isNotEmpty??false) {
                _sourceCode = sourceCode(context).where((type) => type.value == state.premium?.code)
                    .first;
              }else{
                _sourceCode = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Source file')),
                    isDense: true,
                    isExpanded: true,
                    value: _sourceCode,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,

                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(code: value.value) ;
                      sCubit.addPackage(package);
                    },
                    items: sourceCode(context).map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.responsive.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').code]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').code]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.content.isNotEmpty??false) {
                _contents = contents(context).where((type) => type.value == state.premium?.content)
                    .first;
              }else{
                _contents = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Content upload')),
                    isDense: true,
                    isExpanded: true,
                    value: _contents,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,
                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(content: value.value) ;
                      sCubit.addPackage(package);
                    },
                    items: contents(context).map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.code.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').content]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').content]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.premium?.optimize.isNotEmpty??false) {
                _optimize = optimize(context).where((type) => type.value == state.premium?.optimize)
                    .first;
              }else{
                _optimize = null;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<DummyPackage>(
                    hint:  CustomText(text:Utils.translatedText(context, 'Speed optimization')),
                    isDense: true,
                    isExpanded: true,
                    value: _optimize,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _decoration(),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,

                    onChanged: (value) {
                      if (value == null) return;

                      final package = state.premium?.copyWith(optimize: value.value) ;
                      sCubit.addPackage(package);
                    },
                    items: optimize(context).map<DropdownMenuItem<DummyPackage>>(
                          (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                        value: value,
                        child: CustomText(text: value.title,fontWeight: FontWeight.w500),
                      ),
                    ).toList(),
                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.content.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').optimize]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').optimize]?.first??''),
                  ],

                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.premium?.price??'',
                    onChanged: (String text){
                      final package = state.premium?.copyWith(price: text) ;
                      sCubit.addPackage(package);
                    },
                    decoration:  InputDecoration(
                      hintText: Utils.translatedText(context, 'Price Here',true),
                      border:  InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: Utils.inputFormatter,

                  ),
                  if (post is ServiceAddFormError) ...[
                    if(state.premium?.optimize.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('premium').price]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('premium').price]?.first??''),
                  ],

                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
