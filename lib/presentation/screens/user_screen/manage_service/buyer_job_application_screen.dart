import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../order/components/empty_order.dart';
import '/state_injection_packages.dart';
import '/presentation/widgets/custom_app_bar.dart';

import '../../../../data/models/home/job_post.dart';
import '../../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/fetch_error_text.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/page_refresh.dart';
import '../../job/component/buyer_job_application_card.dart';

class BuyerJobApplicationScreen extends StatefulWidget {
  const BuyerJobApplicationScreen({super.key});

  @override
  State<BuyerJobApplicationScreen> createState() => _BuyerJobApplicationScreenState();
}

class _BuyerJobApplicationScreenState extends State<BuyerJobApplicationScreen> {

  late JobPostCubit serviceCubit;
  //final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<JobPostCubit>();

    Future.microtask(()=>serviceCubit.getJobPostList());

    //_scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {

    serviceCubit.tabChange(0);

    super.dispose();
  }
/*
  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (serviceCubit.state.isListEmpty == false) {
          serviceCubit.getAllServices();
        }
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DefaultAppBar(title: Utils.translatedText(context, 'All Job Post')),
      body: PageRefresh(
        onRefresh: () async {
          serviceCubit.getJobPostList();
        },
        child: Utils.logout(
          child: BlocConsumer<JobPostCubit, JobPostItem>(
            listener: (context, service) {
              final state = service.postState;
              if (state is JobPostError) {
                if (state.statusCode == 503 || serviceCubit.jobPost == null) {
                  serviceCubit.getJobPostList();
                }
                if(state.statusCode == 401){
                  Utils.logoutFunction(context);
                }
              }

              if (state is JobPostDeleteError){
                Utils.errorSnackBar(context, state.message);
              }  else if (state is JobPostDeleteLoaded){
                Utils.showSnackBar(context, state.message);
                Future.delayed(const Duration(milliseconds: 800),(){
                  serviceCubit.getJobPostList();
                });
              }


            },
            builder: (context, service) {
              final state = service.postState;
              if (state is JobPostLoading) {
                return const LoadingWidget();
              } else if (state is JobPostError) {
                if (state.statusCode == 503 || serviceCubit.jobPost != null) {
                  return LoadedJobPostView(jobPostList: serviceCubit.jobPost);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is JobPostLoaded) {
                return LoadedJobPostView(jobPostList: state.jobPost);
              }
              if (serviceCubit.jobPost != null) {
                return LoadedJobPostView(jobPostList: serviceCubit.jobPost);
              } else {
                return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadedJobPostView extends StatefulWidget {
  const LoadedJobPostView({super.key, required this.jobPostList});
  final JobPostModel? jobPostList;

  @override
  State<LoadedJobPostView> createState() => _LoadedJobPostViewState();
}

class _LoadedJobPostViewState extends State<LoadedJobPostView> {

  late List<List<JobPostItem>?> filteredList;
  late JobPostCubit jCubit ;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init(){
    jCubit = context.read<JobPostCubit>();
    filteredList = [
      widget.jobPostList?.buyerJobPosts??[],
      widget.jobPostList?.buyerAwaitJobPosts??[],
      widget.jobPostList?.buyerActiveJobPosts??[],
      widget.jobPostList?.buyerHiredJobPosts??[],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 40,
            offset: Offset(0, 2),
            spreadRadius: 10,
          )
        ],
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            // automaticallyImplyLeading: true,
            pinned: true,
            leading: const BackButtonWidget(),
            surfaceTintColor: scaffoldBgColor,
            backgroundColor: scaffoldBgColor,
            toolbarHeight: Utils.vSize(80.0),
            centerTitle: true,
            title: CustomText(
              text: Utils.translatedText(context, "My Jobs"),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: blackColor,
            ),
            bottom: const OrderTabContent(),
          ),
          if (filteredList[jCubit.state.totalView]?.isNotEmpty??false) ...[
            SliverList.list(
              children: List.generate(
                    filteredList[jCubit.state.totalView]?.length??0,
                    (index) {
                      final item = filteredList[jCubit.state.totalView]?[index];
                      // return JobCard(item: item!);
                      return  BuyerJobApplicationCard(item: item);
                },
              ),
            ),
          ] else ...[
            // EmptyWidget(image: KImages.emptyImage),
            const EmptyOrder(empty: 'Sorry!! Jobpost Not Found',isShowSub: false),
          ],
        ],
      ),
    );
  }
}

class OrderTabContent extends StatefulWidget implements PreferredSizeWidget {
  const OrderTabContent({super.key});

  @override
  State<OrderTabContent> createState() => _OrderTabContentState();

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(40.0));
}

class _OrderTabContentState extends State<OrderTabContent> {

  @override
  Widget build(BuildContext context) {
    final jCubit = context.read<JobPostCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: BlocBuilder<JobPostCubit, JobPostItem>(
        builder: (context,state){
          List<String> orderTabItems = [
            Utils.translatedText(context, 'All(${jCubit.jobPost?.buyerJobPosts?.length??0})'),
            Utils.translatedText(context, 'Awaiting(${jCubit.jobPost?.buyerAwaitJobPosts?.length??0})'),
            Utils.translatedText(context, 'Active(${jCubit.jobPost?.buyerActiveJobPosts?.length??0})'),
            Utils.translatedText(context, 'Hired(${jCubit.jobPost?.buyerHiredJobPosts?.length??0})'),
          ];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Utils.hPadding()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                orderTabItems.length,
                    (index) {
                  final active = jCubit.state.totalView == index;
                  return GestureDetector(
                    onTap: () => jCubit.tabChange(index),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor),
                        color: active ? primaryColor : Colors.transparent,
                        borderRadius: Utils.borderRadius(r: 25.0),
                      ),
                      padding: Utils.symmetric(v: 8.0, h: 20.0),
                      margin: Utils.only(
                          left: index == 0 ? 0.0 : 12.0, bottom: 10.0, top: 14.0),
                      child: CustomText(
                        text: orderTabItems[index],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
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