import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/data/models/home/home_model.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/utils/utils.dart';
import '../../../logic/bloc/login/login_bloc.dart';
import '../../../logic/cubit/currency/currency_cubit.dart';
import '../../../logic/cubit/currency/currency_state_model.dart';
import '../../../logic/cubit/home/home_cubit.dart';
import '../../../logic/cubit/home/home_state.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import 'component/buyer_home_header.dart';
import 'component/category_list.dart';
import 'component/join_seller_banner.dart';
import 'component/our_services.dart';
import 'component/recent_job.dart';
import 'component/slider_section.dart';
import 'component/top_sellers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageRefresh(
        onRefresh: () async {
          homeCubit.getHomeData(context.read<LoginBloc>().state.langCode);
        },
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeStateError) {
              if (state.statusCode == 503 || homeCubit.homeModel == null) {
                homeCubit.getHomeData(context.read<LoginBloc>().state.langCode);
              }
            }
          },
          builder: (context, state) {
            // final state = states.bState;
            if (state is HomeStateLoading) {
              return const LoadingWidget();
            } else if (state is HomeStateError) {
              if (state.statusCode == 503 || homeCubit.homeModel != null) {
                return HomeViewLoaded(model: homeCubit.homeModel!);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is HomeStateLoaded) {
              return HomeViewLoaded(model: state.homeModel);
            }

            if (homeCubit.homeModel != null) {
              return HomeViewLoaded(model: homeCubit.homeModel!);
            }  else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class HomeViewLoaded extends StatefulWidget {
  const HomeViewLoaded({super.key, required this.model});
  final HomeModel model;

  @override
  State<HomeViewLoaded> createState() => _HomeViewLoadedState();
}

class _HomeViewLoadedState extends State<HomeViewLoaded> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BuyerHomeHeader(),
        Utils.verticalSpace(20.0),
        Expanded(
          child: SingleChildScrollView(
            child: BlocBuilder<CurrencyCubit, CurrencyStateModel>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SliderSection(),
                    CategoryList(categories: widget.model.categories??[]),
                    OurServices(service: widget.model.featureService ??[]),
                    const JoinSellerBanner(),
                    RecentJob(jobPosts: widget.model.jobPost ??[]),
                    TopSellers(sellers: widget.model.topSellers ??[]),
                    Utils.verticalSpace(20.0),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
