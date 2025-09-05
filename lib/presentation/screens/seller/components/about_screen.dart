import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceCubit = context.read<ServiceDetailCubit>();
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
        text: Utils.translatedText(context, 'About Me'), fontSize: 18, fontWeight: FontWeight.w600,),
        if(serviceCubit.sellerService?.seller?.aboutMe.isNotEmpty??false)...[
          HtmlWidget(serviceCubit.sellerService?.seller?.aboutMe ?? ''),
        ]else...[
          Utils.verticalSpace(20.0),
          CustomText(text: Utils.translatedText(context, '  No information found'), fontSize: 14, fontWeight: FontWeight.w500)
        ],

    ],);
  }
}
