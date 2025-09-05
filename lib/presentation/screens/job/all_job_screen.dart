import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../data/models/home/category_model.dart';
import '../../../data/models/home/job_post.dart';
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
import '../buyer_screen/more/components/my_job/job_card.dart';

class AllJobScreen extends StatefulWidget {
  const AllJobScreen({super.key});

  @override
  State<AllJobScreen> createState() => _AllJobScreenState();
}

class _AllJobScreenState extends State<AllJobScreen> {

  late ServiceListCubit serviceCubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ServiceListCubit>();

    Future.microtask(()=>serviceCubit..getAllJob()..getFilterData('jobs'));

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
          serviceCubit.getAllJob();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'All Job Post')),
      body: PageRefresh(
        onRefresh: () async {
          if (serviceCubit.state.totalService > 1) {
            serviceCubit.initPage();
          }

          serviceCubit.getAllJob();
        },
        child: BlocConsumer<ServiceListCubit, CategoryModel>(
          listener: (context, service) {
            final state = service.serviceState;
            if (state is ServiceErrorState) {
              if (state.statusCode == 503) {
                serviceCubit.getAllJob();
              }
            }
            // if (state is JobPostList) {
            //   serviceCubit.getFilterData('jobs');
            // }

            if (state is ServiceLoadingState &&
                serviceCubit.state.totalService != 1) {
              Utils.loadingDialog(context);
            } else if (state is JobPostListMore) {
              Utils.closeDialog(context);
            }
          },
          builder: (context, service) {
            final state = service.serviceState;
            if (state is ServiceLoadingState && serviceCubit.state.totalService == 1) {
              return const LoadingWidget();
            } else if (state is ServiceErrorState) {
              if (state.statusCode == 503) {
                return LoadedJobPost(items: serviceCubit.jobItems, controller: _scrollController);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is JobPostList) {
              // serviceCubit.getFilterData('jobs');
              return LoadedJobPost(items: state.booking, controller: _scrollController);
            } else if (state is JobPostListMore) {
              return LoadedJobPost(items: state.booking, controller: _scrollController);
            }
           // if (serviceCubit.serviceItems.isNotEmpty) {
              return LoadedJobPost(items: serviceCubit.jobItems, controller: _scrollController);
            // } else {
            //   return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            // }
          },
        ),
      ),
    );
  }

}

class LoadedJobPost extends StatelessWidget {
  const LoadedJobPost({super.key, required this.items, required this.controller});
  final List<JobPostItem> items;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Utils.symmetric(),
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: Utils.vSize(55.0),
                child: TextFormField(
                  onChanged: (String text){
                    context.read<ServiceListCubit>().searchJob(text);
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: Utils.translatedText(context, 'Search..'),
                    contentPadding:  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
            ),
           ///filter commended because job filter api not found or didn't find in collection
            Utils.horizontalSpace(12.0),
            GestureDetector(
              onTap: (){
                  context.read<ServiceListCubit>().initState();
                  jobFilterDialog(context);
                },
              child: Container(
                height: 55.0,
                width: 55.0,
                decoration: const BoxDecoration(
                    color: whiteColor,
                    shape: BoxShape.circle
                ),
                child: const Icon(Icons.filter_alt_outlined,size: 30,),
              ),
            )
          ],
        ),
        Utils.verticalSpace(20.0),
        if(items.isNotEmpty)...[
          ...List.generate(items.length, (index) {
            return Padding(
              padding: Utils.only(bottom: 10.0),
              child: JobCard(item: items[index]),
            );
          }),
        ]else...[
          EmptyWidget(image: KImages.emptyImage,isSliver: false)
        ],
        Utils.verticalSpace(20.0),
      ],
    );
  }
}

void jobFilterDialog(BuildContext context) {
  final subsCubit = context.read<ServiceListCubit>();

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
                CustomText(text: Utils.translatedText(context, 'All Cities'),color: blackColor,fontWeight: FontWeight.w500),
                const Divider(color: stockColor,),
                if(subsCubit.filter?.cities?.isNotEmpty??false)...[
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: List.generate(subsCubit.filter?.cities?.length??0, (index){
                      final cat = subsCubit.filter?.cities?[index];
                      return GestureDetector(
                        onTap: () => subsCubit.cityText(cat?.id.toString()??''),
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
                                    value: state.city == cat?.id.toString(),
                                    // value: state.categories.contains(cat),
                                    tristate: true,
                                    side: const BorderSide(color: stockColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: Utils.borderRadius()),
                                    activeColor: primaryColor,
                                    onChanged: (val) => subsCubit.cityText(cat?.id.toString()??''),
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
                Utils.verticalSpace(14.0),
                PrimaryButton(
                    text:  Utils.translatedText(context, 'Apply Now'),
                    onPressed: () {
                      Utils.closeKeyBoard(context);
                      Navigator.of(context).pop();
                      subsCubit..initPage()..getAllJob(true);
                    }),
              ],
            ),
          );
        },
      ),
    ),
  );
}

