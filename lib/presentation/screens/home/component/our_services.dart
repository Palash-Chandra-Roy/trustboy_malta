import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/logic/cubit/service_list/service_list_cubit.dart';
import 'package:work_zone/presentation/utils/utils.dart';

import '../../../../data/models/service/service_item.dart';
import '../../../routes/route_names.dart';
import 'heading.dart';
import 'single_service.dart';

class OurServices extends StatelessWidget {
  const OurServices({super.key, required this.service});

  final List<ServiceItem> service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Heading(
          title1: Utils.translatedText(context, 'Featured Services'),
          padding: Utils.symmetric(h: 18.0,v: 20.0),
          onTap: () {
            context.read<ServiceListCubit>()..initPage()..clearFilterData();
            Navigator.pushNamed(context, RouteNames.allServiceScreen);
          },
        ),
       /* GridView.builder(
          padding: Utils.only(top: 10.0),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: Utils.hSize(10.0),
            mainAxisSpacing: Utils.vSize(10.0),
          ),
          itemCount: service.length > 4? 4:service.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, int index) {
            return SingleService(item: service[index]);
          },
        ),*/
        /*LayoutBuilder(
          builder: (context, constraints) {
            double aspectRatio = constraints.maxWidth > 600 ? 0.8 : 0.65;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: Utils.hSize(10.0),
                mainAxisSpacing: Utils.vSize(10.0),
              ),
              itemCount: service.length > 4 ? 4 : service.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                return SingleService(item: service[index]);
              },
            );
          },
        ),*/

        if (service.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Utils.mediaQuery(context).width,
                child: Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  alignment: service.length % 2 == 1
                      ? WrapAlignment.start
                      : WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    ...List.generate(service.length > 6?6: service.length, (index) {
                    final item = service[index];
                   return SingleService(item: item);
                  }),
                    if(service.length % 2 == 1)...[
                      SizedBox(width: Utils.mediaQuery(context).width * 0.46),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
