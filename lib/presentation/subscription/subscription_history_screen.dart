import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subscription/sub_detail_model.dart';
import '../../logic/cubit/subscription/subscription_cubit.dart';
import '../utils/k_images.dart';
import '../utils/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_widget.dart';
import '../widgets/fetch_error_text.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_refresh.dart';
import 'component/purchase_component.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  State<SubscriptionHistoryScreen> createState() => _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {


  late SubscriptionCubit serviceCubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<SubscriptionCubit>();

    Future.microtask(()=>serviceCubit.getPurchaseHistories());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (serviceCubit.state.currentPage > 1) {
      serviceCubit.initPage();
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (serviceCubit.state.isEmpty == false) {
          serviceCubit.getPurchaseHistories();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: Utils.translatedText(context, 'Purchase History')),
      body: PageRefresh(
        onRefresh: () async {
          if (serviceCubit.state.currentPage > 1) {
            serviceCubit.initPage();
          }

          serviceCubit.getPurchaseHistories();
        },
        child: BlocConsumer<SubscriptionCubit, SubDetailModel>(
          listener: (context, service) {
            final state = service.subState;
            if (state is PurchaseErrorState) {
              if (state.statusCode == 503) {
                serviceCubit.getPurchaseHistories();
              }
            }
            // if (state is JobPostList) {
            //   serviceCubit.getFilterData('jobs');
            // }

            if (state is PurchaseLoadingState &&
                serviceCubit.state.currentPage != 1) {
              Utils.loadingDialog(context);
            } else if (state is SubscriptionListMore) {
              Utils.closeDialog(context);
            }
          },
          builder: (context, service) {
            final state = service.subState;
            if (state is PurchaseLoadingState && serviceCubit.state.currentPage == 1) {
              return const LoadingWidget();
            } else if (state is PurchaseErrorState) {
              if (state.statusCode == 503) {
                return LoadedHistory(items: serviceCubit.histories, controller: _scrollController);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is SubscriptionList) {
              return LoadedHistory(items: state.booking, controller: _scrollController);
            } else if (state is SubscriptionListMore) {
              return LoadedHistory(items: state.booking, controller: _scrollController);
            }
            // if (serviceCubit.serviceItems.isNotEmpty) {
            return LoadedHistory(items: serviceCubit.histories, controller: _scrollController);
            // } else {
            //   return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            // }
          },
        ),
      ),
    );
  }
}

class LoadedHistory extends StatelessWidget {
  const LoadedHistory({super.key, this.items, required this.controller});
final List<SubDetailModel?>? items;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    if (items?.isNotEmpty ?? false) {
      return ListView.builder(
        controller: controller,
        itemCount: items?.length,
        itemBuilder: (context, index) {
          final sub = items?[index];
          if (sub != null) {
            return PurchaseComponent(singleOrder: sub);
          } else {
            return SizedBox.shrink();
          }
        },
      );
    } else {
      return EmptyWidget2(
          image: KImages.emptySubs,
          text: 'Sorry!! There no Subscription',
          subText: 'Opps...this information is not available for a moment',
          isSliver: false);
    }
  }
}

