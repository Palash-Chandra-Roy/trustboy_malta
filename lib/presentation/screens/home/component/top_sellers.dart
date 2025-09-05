import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/home/seller_model.dart';
import '../../../../logic/cubit/service_list/service_list_cubit.dart';
import '../../../routes/route_names.dart';
import '../../../utils/utils.dart';
import 'heading.dart';
import 'single_seller.dart';

class TopSellers extends StatelessWidget {
  const TopSellers({super.key, required this.sellers});

  final List<SellerModel> sellers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Heading(
          title1: Utils.translatedText(context, 'Top Seller'),
          padding: Utils.symmetric(v: 20.0),
          onTap: () {
            context.read<ServiceListCubit>()..initPage()..clearFilterData();
            Navigator.pushNamed(context, RouteNames.allSellerScreen);
          },
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: List.generate(
              sellers.length > 4 ? 4 : sellers.length,
              (index) => Padding(
                padding: Utils.only(
                    left: index == 0 ? 20.0 : 0.0,
                    right: index == 5 - 1 ? 20.0 : 10.0),
                child: SingleSeller(seller: sellers[index]),
              ),
            ),
          ),
        )
      ],
    );
  }
}
