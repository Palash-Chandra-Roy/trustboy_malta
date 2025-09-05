import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/service/service_item.dart';
import '../../../data/models/service/service_model.dart';
import '../../../logic/cubit/service/service_cubit.dart';
import '../../utils/constraints.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../user_screen/manage_service/components/manage_service_card.dart';

class SellerServiceScreen extends StatefulWidget {
  const SellerServiceScreen({super.key});

  @override
  State<SellerServiceScreen> createState() => _SellerServiceScreenState();
}

class _SellerServiceScreenState extends State<SellerServiceScreen> {


  late ServiceCubit serviceCubit;
  //final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ServiceCubit>();

    Future.microtask(()=>serviceCubit.sellerAllServices());

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
          serviceCubit.sellerAllServices();
        },
        child: Utils.logout(
          child: BlocConsumer<ServiceCubit, ServiceItem>(
            listener: (context, service) {
              final state = service.serviceState;
              if (state is ServiceListError) {
                if (state.statusCode == 503 || serviceCubit.serviceModel == null) {
                  serviceCubit.sellerAllServices();
                }
                if(state.statusCode == 401){
                  Utils.logoutFunction(context);
                }
              }

              if (state is ServiceAddError){
                Utils.errorSnackBar(context, state.message);
              }  else if (state is ServiceSubmitted){
                Utils.showSnackBar(context, state.message);
                Future.delayed(const Duration(milliseconds: 800),(){
                  serviceCubit.sellerAllServices();
                });
              }

            },
            builder: (context, service) {
              final state = service.serviceState;
              if (state is ServiceListLoading) {
                return const LoadingWidget();
              } else if (state is ServiceListError) {
                if (state.statusCode == 503 || serviceCubit.serviceModel != null) {
                  return LoadedServiceView(jobPostList: serviceCubit.serviceModel);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is ServiceListLoaded) {
                return LoadedServiceView(jobPostList: state.detailModel);
              }
              if (serviceCubit.serviceModel != null) {
                return LoadedServiceView(jobPostList: serviceCubit.serviceModel);
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


class LoadedServiceView extends StatefulWidget {
  const LoadedServiceView({super.key, required this.jobPostList});
  final ServiceModel? jobPostList;

  @override
  State<LoadedServiceView> createState() => _LoadedServiceViewState();
}

class _LoadedServiceViewState extends State<LoadedServiceView> {

  late List<List<ServiceItem>?> filteredList;
  late ServiceCubit jCubit ;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init(){
    jCubit = context.read<ServiceCubit>();
    filteredList = [
      widget.jobPostList?.sellerService??[],
      widget.jobPostList?.activeService??[],
      widget.jobPostList?.pendingService??[],
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
              text: Utils.translatedText(context, "Manage Service"),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: blackColor,
            ),
            bottom: const OrderTabContent(),
          ),
            SliverToBoxAdapter(child: Utils.verticalSpace(10.0)),
            if(filteredList[jCubit.state.sellerId]?.isNotEmpty??false)...[

             SliverToBoxAdapter(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     width: Utils.mediaQuery(context).width,
                     padding: Utils.only(bottom: Utils.mediaQuery(context).height * 0.05),
                     child: Wrap(
                       runSpacing: 10.0,
                       spacing: 10.0,
                       alignment: WrapAlignment.center,
                       runAlignment: WrapAlignment.center,
                       children: [
                         ...List.generate((filteredList[jCubit.state.sellerId]?.length??0), (index) {
                           final item = filteredList[jCubit.state.sellerId]?[index];
                           return ManageServiceCard(item: item);
                         }),
                         if((filteredList[jCubit.state.sellerId]?.length??0) % 2 == 1)...[
                           SizedBox(width: Utils.mediaQuery(context).width * 0.46),
                         ],
                       ],
                     ),
                   ),
                 ],
               ),
             ),
          ] else ...[
            EmptyWidget(image: KImages.emptyImage),
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
    final jCubit = context.read<ServiceCubit>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: BlocBuilder<ServiceCubit, ServiceItem>(
        builder: (context,state){
          List<String> orderTabItems = [
            Utils.translatedText(context, 'All(${jCubit.serviceModel?.sellerService?.length??0})'),
            Utils.translatedText(context, 'Active(${jCubit.serviceModel?.activeService?.length??0})'),
            Utils.translatedText(context, 'Pending(${jCubit.serviceModel?.pendingService?.length??0})'),
          ];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Utils.hPadding()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                orderTabItems.length,
                    (index) {
                  final active = jCubit.state.sellerId == index;
                  return GestureDetector(
                    onTap: () => jCubit.tabChange(index),
                    // onTap: () => setState(() => _currentIndex = index),
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