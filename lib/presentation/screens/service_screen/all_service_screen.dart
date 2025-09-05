import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/home/category_model.dart';
import '../../../data/models/service/service_item.dart';
import '../../../logic/cubit/service_list/service_list_cubit.dart';
import '../../utils/constraints.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/primary_button.dart';
import '../home/component/single_service.dart';

class AllServiceScreen extends StatefulWidget {
  const AllServiceScreen({super.key});

  @override
  State<AllServiceScreen> createState() => _AllServiceScreenState();
}

class _AllServiceScreenState extends State<AllServiceScreen> {

  late ServiceListCubit serviceCubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ServiceListCubit>();

    Future.microtask(()=>serviceCubit..getAllServices()..getFilterData('service'));

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (serviceCubit.state.totalService > 1) {
      serviceCubit.initPage();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (serviceCubit.state.isListEmpty == false) {
          serviceCubit.getAllServices();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'Services')),
      body: PageRefresh(
        onRefresh: () async {
          if (serviceCubit.state.totalService > 1) {
            serviceCubit.initPage();
          }

          serviceCubit.getAllServices();
        },
        child: BlocConsumer<ServiceListCubit, CategoryModel>(
          listener: (context, service) {
            final state = service.serviceState;
            if (state is ServiceErrorState) {
              if (state.statusCode == 503) {
                serviceCubit.getAllServices();
              }
            }

            if (state is ServiceLoadingState &&
                serviceCubit.state.totalService != 1) {
              Utils.loadingDialog(context);
            } else if (state is ServiceListMore) {
              Utils.closeDialog(context);
            }
          },
          builder: (context, service) {
            final state = service.serviceState;
            if (state is ServiceLoadingState && serviceCubit.state.totalService == 1) {
              return const LoadingWidget();
            } else if (state is ServiceErrorState) {
              if (state.statusCode == 503) {
                return LoadedServiceList(items: serviceCubit.serviceItems, controller: _scrollController);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ServiceList) {
              return LoadedServiceList(
                  items: state.booking, controller: _scrollController);
            } else if (state is ServiceListMore) {
              return LoadedServiceList(items: state.booking, controller: _scrollController);
            }
            if (serviceCubit.serviceItems.isNotEmpty) {
              return LoadedServiceList(items: serviceCubit.serviceItems, controller: _scrollController);
            } else {
              return EmptyWidget(image: KImages.emptyImage,isSliver: false,height: Utils.mediaQuery(context).height * 0.8);
              // return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedServiceList extends StatelessWidget {
  const LoadedServiceList({super.key, required this.items, required this.controller});
  final List<ServiceItem> items;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: Utils.symmetric(h: 0.0).copyWith(bottom: Utils.mediaQuery(context).height * 0.05),
      child:  Column(
        children: [
          Padding(
            padding: Utils.symmetric(h: 14.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Utils.vSize(48.0),
                    child: TextFormField(
                      onChanged: (String text){
                        context.read<ServiceListCubit>().searchService(text);
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: Utils.translatedText(context, 'Search for any service...'),
                        contentPadding:  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Utils.horizontalSpace(12.0),
                GestureDetector(
                  onTap: (){
                    context.read<ServiceListCubit>().initState();
                    filterDialog(context);
                  },
                  child: Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: const BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.filter_alt_outlined,size: 30,),
                  ),
                )
              ],
            ),
          ),
          if (items.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Utils.mediaQuery(context).width,
                  margin: Utils.only(top: 14.0),
                  child: Wrap(
                    runSpacing: 10.0,
                    spacing: 10.0,
                    alignment:  WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      ...List.generate(items.length, (index) {
                        final item = items[index];
                        return SingleService(item: item,width: Utils.mediaQuery(context).width * 0.46);
                      }),
                      if(items.length % 2 == 1)...[
                           SizedBox(width: Utils.mediaQuery(context).width * 0.46),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ]else...[
            EmptyWidget(image: KImages.emptyImage,isSliver: false,height: Utils.mediaQuery(context).height * 0.8),
          ],
        ],
      ),
    );
  }
}

void filterDialog(BuildContext context) {
  final subsCubit = context.read<ServiceListCubit>();
  // final homeCubit = context.read<HomeCubit>();
  final defaultList = [
    '${Utils.translatedText(context, 'A to Z')}(${Utils.translatedText(context, 'ASC')})',
    '${Utils.translatedText(context, 'Z to A')}(${Utils.translatedText(context, 'DSC')})',
  ];

  Utils.showCustomDialog(
    bgColor: whiteColor,
    context,
    padding: Utils.symmetric(),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: BlocBuilder<ServiceListCubit, CategoryModel>(
        builder: (context,state){
         return Padding(
            padding: Utils.symmetric(v: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const Spacer(),
                    CustomText(
                      text: Utils.translatedText(context, 'Filter'),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: blackColor,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.clear, color: redColor)),
                  ],
                ),
                const Divider(color: stockColor),
                Container(
                  height: 55.0,
                  width: double.infinity,
                  margin: Utils.only(bottom: 14.0,top: 6.0),
                  child: TextFormField(
                    initialValue: subsCubit.state.name,
                    onChanged:(String text)=> subsCubit.searchText(text),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: Utils.translatedText(context, 'Search for any service...'),
                      contentPadding:  Utils.symmetric(v: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: Utils.borderRadius(r:50.0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F5F0)
                    ),
                  ),
                ),

                CustomText(text: Utils.translatedText(context, 'All Categories'),color: blackColor,fontWeight: FontWeight.w500),
                const Divider(color: stockColor,),
                if(subsCubit.filter?.categories?.isNotEmpty??false)...[
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: List.generate(subsCubit.filter?.categories?.length??0, (index){
                      final cat = subsCubit.filter?.categories?[index];
                      return GestureDetector(
                        onTap: () => subsCubit.nameText(cat?.id.toString()??''),
                        // onTap: () => subsCubit.addCategories(cat!),
                        child: Container(
                          padding: Utils.symmetric(h: 6.0,v: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: Utils.borderRadius(r: 50.0),
                            border: Border.all(color: stockColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Transform.scale(
                                scale: 1.0,
                                child: Container(
                                  height: 24.0,
                                  width: 24.0,
                                  margin: Utils.only(bottom: 4.0),
                                  child: Checkbox(
                                    value: state.image == cat?.id.toString(),
                                    // value: state.categories.contains(cat),
                                    tristate: true,
                                    side: const BorderSide(color: stockColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: Utils.borderRadius()),
                                    activeColor: primaryColor,
                                    onChanged: (val) => subsCubit.nameText(cat?.id.toString()??''),
                                    // onChanged: (val) =>subsCubit.addCategories(cat!),
                                    visualDensity: const VisualDensity(horizontal: -4.0, vertical: -3.0),
                                  ),
                                ),
                              ),
                              CustomText(text: cat?.name??'',color: gray5B,fontWeight: FontWeight.w500),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],

              /*                Utils.verticalSpace(14.0),

                              CustomText(text: Utils.translatedText(context, 'Sub Categories'),color: blackColor,fontWeight: FontWeight.w500),
                              const Divider(color: stockColor,),
                              if(subsCubit.filter?.subCategories?.isNotEmpty??false)...[
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 10.0,
                                  children: List.generate(subsCubit.filter?.subCategories?.length??0, (index){
                                    final cat = subsCubit.filter?.subCategories?[index];
                                    return GestureDetector(
                                      onTap: () => subsCubit.addCategories(cat!),
                                      child: Container(
                                        padding: Utils.symmetric(h: 6.0,v: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius: Utils.borderRadius(r: 50.0),
                                          border: Border.all(color: stockColor),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Transform.scale(
                                              scale: 1.0,
                                              child: Container(
                                                height: 24.0,
                                                width: 24.0,
                                                margin: Utils.only(bottom: 4.0),
                                                child: Checkbox(
                                                  value: state.categories.contains(cat),
                                                  tristate: true,
                                                  side: const BorderSide(color: stockColor),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: Utils.borderRadius()),
                                                  activeColor: primaryColor,
                                                  onChanged: (val) =>subsCubit.addCategories(cat!),
                                                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -3.0),
                                                ),
                                              ),
                                            ),
                                            Flexible(child: CustomText(text: cat?.name??'',color: gray5B,fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],*/

                Utils.verticalSpace(14.0),
                CustomText(text: Utils.translatedText(context, 'Default'),color: blackColor,fontWeight: FontWeight.w500),
                const Divider(color: stockColor,),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 10.0,
                  children: List.generate(defaultList.length, (index){
                    final cat = defaultList[index];
                    return GestureDetector(
                      onTap: () => subsCubit.sortText(cat),
                      child: Container(
                        padding: Utils.symmetric(h: 6.0,v: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: Utils.borderRadius(r: 50.0),
                          border: Border.all(color: stockColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.scale(
                              scale: 1.0,
                              child: Container(
                                height: 24.0,
                                width: 24.0,
                                margin: Utils.only(bottom: 4.0),
                                child: Checkbox(
                                  value: state.slug == cat,
                                  tristate: true,
                                  side: const BorderSide(color: stockColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: Utils.borderRadius()),
                                  activeColor: primaryColor,
                                  onChanged: (val) =>subsCubit.sortText(cat),
                                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -3.0),
                                ),
                              ),
                            ),
                            CustomText(text: cat,color: gray5B,fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                Utils.verticalSpace(14.0),
                PrimaryButton(
                    text:  Utils.translatedText(context, 'Apply Now'),
                    onPressed: () {
                      Utils.closeKeyBoard(context);
                      Navigator.of(context).pop();
                      subsCubit..initPage()..getAllServices(true);
                    }),
              ],
            ),
          );
        },
      ),
    ),
  );
}
