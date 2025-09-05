import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service_screen/component/service_seller_info.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_app_bar.dart';
import '../../../data/models/service/review_model.dart';
import '../../../data/models/service/service_model.dart';
import '../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import 'components/seller_profile_tab.dart';

class SellerDetailsScreen extends StatefulWidget {
  const SellerDetailsScreen({super.key});

  @override
  State<SellerDetailsScreen> createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen> {
  late ServiceDetailCubit detailCubit;

  @override
  void initState() {
    detailCubit = context.read<ServiceDetailCubit>();
    Future.microtask(() => detailCubit.serviceDetail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Freelancer')),
      body: PageRefresh(
        onRefresh: () async {
          detailCubit.serviceDetail();
        },
        child: BlocConsumer<ServiceDetailCubit, ReviewModel>(
          listener: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.detail == null) {
                detailCubit.serviceDetail();
              }
            }
          },
          builder: (context, states) {
            final state = states.detailState;
            if (state is ServiceDetailStateLoading) {
              return const LoadingWidget();
            } else if (state is ServiceDetailStateError) {
              if (state.statusCode == 503 || detailCubit.detail != null) {
                return SellerDetailLoaded(model: detailCubit.detail);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ServiceDetailStateLoaded) {
              return SellerDetailLoaded(model: state.detailModel);
            }

            if (detailCubit.detail != null) {
              return SellerDetailLoaded(model: detailCubit.detail);
            } else {
              return const FetchErrorText(text: 'Something went wrong');
            }
          },
        ),
      ),
    );
  }
}

class SellerDetailLoaded extends StatelessWidget {
  const SellerDetailLoaded({super.key, required this.model});
  final ServiceModel? model;

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ServiceSellerInfo(detail: model,margin:Utils.symmetric(h: 16.0,v: 25.0).copyWith(top: 0.0),isExpand: true),
          const SupplierTabContents(),
        ],
      ),
    );
  }

}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(h:0.0,v: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 14.0,
          ),
          Utils.horizontalSpace(10.0),
          Flexible(
            child: CustomText(
              text: value,
              fontSize: 14.0,
              maxLine: 2,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
