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

class BasicPackageTab extends StatefulWidget {
  const BasicPackageTab({super.key});

  @override
  State<BasicPackageTab> createState() => _BasicPackageTabState();
}

class _BasicPackageTabState extends State<BasicPackageTab> {
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
    item = PackageItem.errors('basic');
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
          packageHeading(context,'Basic Package'),
          HorizontalLine(color: gray5B,margin: Utils.all()),

          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.basic?.description??'',
                    onChanged: (String text){
                      final package = state.basic?.copyWith(description: text) ;
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
                      if (post.errors.package[PackageItem.errors('basic').description]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').description]?.first??''),
                  ],

                ],
              );
            },
          ),
           HorizontalLine(color: gray5B,margin: Utils.all()),
          
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.delivery.isNotEmpty??false) {
                _deliveryTime = deliveryTime.where((type) => type.title == state.basic?.delivery)
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
                    decoration: const InputDecoration(
                        isDense: true,
                        border:  InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                    ),
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,
                    onChanged: (value) {
                      if (value == null) return;
                      
                      final package = state.basic?.copyWith(delivery: value.title) ;
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
                    if(state.basic?.description.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').delivery]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').delivery]?.first??''),
                  ],
                  
                ],
              );
            },
          ),

          HorizontalLine(color: gray5B,margin: Utils.all()),

          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.revision.isNotEmpty??false) {
                _revisions = revisions.where((type) => type.title == state.basic?.revision)
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
                      
                      final package = state.basic?.copyWith(revision: value.title) ;
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
                    if(state.basic?.delivery.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').revision]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').revision]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.website.isNotEmpty??false) {
                _functional = functionalWeb(context).where((type) => type.value == state.basic?.website)
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
                      
                      final package = state.basic?.copyWith(website: value.value) ;
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
                    if(state.basic?.revision.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').website]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').website]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.page.isNotEmpty??false) {
                _numberOfPages = numberOfPages.where((type) => type.title == state.basic?.page)
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
                      final package = state.basic?.copyWith(page: value.title) ;
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
                    if(state.basic?.website.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').page]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').page]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.responsive.isNotEmpty??false) {
                _responsive = responsive(context).where((type) => type.value == state.basic?.responsive)
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
                    borderRadius: Utils.borderRadius(r: 5.0),
                    dropdownColor: whiteColor,
                    onChanged: (value) {
                      if (value == null) return;
                      
                      final package = state.basic?.copyWith(responsive: value.value) ;
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
                    if(state.basic?.page.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').responsive]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').responsive]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.code.isNotEmpty??false) {
                _sourceCode = sourceCode(context).where((type) => type.value == state.basic?.code)
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
                      
                      final package = state.basic?.copyWith(code: value.value) ;
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
                    if(state.basic?.responsive.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').code]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').code]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.content.isNotEmpty??false) {
                _contents = contents(context).where((type) => type.value == state.basic?.content)
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
                      
                      final package = state.basic?.copyWith(content: value.value) ;
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
                    if(state.basic?.code.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').content]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').content]?.first??''),
                  ],
                  
                ],
              );
            },
          ),
          HorizontalLine(color: gray5B,margin: Utils.all()),
          BlocBuilder<ServiceCubit, ServiceItem>(
            builder: (context, state) {
              final post = state.serviceState;
              if (state.basic?.optimize.isNotEmpty??false) {
                _optimize = optimize(context).where((type) => type.value == state.basic?.optimize)
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
                    onChanged: (value) {
                      if (value == null) return;
                      
                      final package = state.basic?.copyWith(optimize: value.value) ;
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
                    if(state.basic?.content.isNotEmpty??false)
                      if (post.errors.package[PackageItem.errors('basic').optimize]?.isNotEmpty??false)
                        ErrorText(text: post.errors.package[PackageItem.errors('basic').optimize]?.first??''),
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
                    initialValue: state.basic?.price??'',
                    onChanged: (String text){
                      final package = state.basic?.copyWith(price: text) ;
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
                    if(state.basic?.optimize.isNotEmpty??false)
                    if (post.errors.package[PackageItem.errors('basic').price]?.isNotEmpty??false)
                      ErrorText(text: post.errors.package[PackageItem.errors('basic').price]?.first??''),
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
Widget packageHeading(BuildContext context,String title) {
  return Container(
    width: Utils.mediaQuery(context).width,
    decoration: BoxDecoration(
      color: scaffoldBgColor,
      borderRadius: Utils.borderRadius(r: 4.0),
    ),
    padding: Utils.symmetric(v: 14.0),
    margin: Utils.all(value: 10.0),
    child: CustomText(
      text: Utils.translatedText(context, title),
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: blackColor,
    ),
  );
}
