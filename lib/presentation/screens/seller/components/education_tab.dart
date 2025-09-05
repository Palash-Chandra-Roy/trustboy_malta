import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_text.dart';

import '../../../../logic/cubit/service_detail/service_detail_cubit.dart';
import '../../../utils/utils.dart';

class EducationTab extends StatelessWidget {
  const EducationTab({super.key});

  @override
  Widget build(BuildContext context) {

    final serviceCubit = context.read<ServiceDetailCubit>();

    final isInfoEmpty = [
      serviceCubit.sellerService?.seller?.universityName??'Hello',
      serviceCubit.sellerService?.seller?.universityLocation??'',
      serviceCubit.sellerService?.seller?.universityTimePeriod??'',
      serviceCubit.sellerService?.seller?.schoolName??'',
      serviceCubit.sellerService?.seller?.schoolLocation??'',
      serviceCubit.sellerService?.seller?.schoolTimePeriod??'',
    ].any((e)=>e.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: Utils.translatedText(context, 'Education'), fontSize: 18,fontWeight: FontWeight.w600,),
        Utils.verticalSpace(10.0),
        if(isInfoEmpty)...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: serviceCubit.sellerService?.seller?.universityName??'', fontSize: 18.0,fontWeight: FontWeight.w600),
              CustomText(text: serviceCubit.sellerService?.seller?.universityLocation??''),
              CustomText(text: serviceCubit.sellerService?.seller?.universityTimePeriod??''),
              Utils.verticalSpace(14.0),
              CustomText(text: serviceCubit.sellerService?.seller?.schoolName??'', fontSize: 18.0,fontWeight: FontWeight.w600),
              CustomText(text: serviceCubit.sellerService?.seller?.schoolLocation??''),
              CustomText(text: serviceCubit.sellerService?.seller?.schoolTimePeriod??''),
            ],),
        ]else...[
          Utils.verticalSpace(20.0),
          CustomText(text: Utils.translatedText(context, '  No information found'), fontSize: 14, fontWeight: FontWeight.w500)
        ],
      ],
    );
  }
}

class LanguageTab extends StatelessWidget {
  const LanguageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceCubit = context.read<ServiceDetailCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: Utils.translatedText(context, 'Languages'), fontSize: 18,fontWeight: FontWeight.w600,),
        if(serviceCubit.sellerService?.seller?.language.isNotEmpty??false)...[
          Utils.verticalSpace(10.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(Utils.parseJsonToString(serviceCubit.sellerService?.seller?.language).length, (index){
              String? skill = Utils.parseJsonToString(serviceCubit.sellerService?.seller?.language)[index];
              if(skill?.isNotEmpty??false){
                return Container(
                  padding: Utils.symmetric(h: 14.0,v: 10.0),
                  decoration: BoxDecoration(color: stockColor,borderRadius: Utils.borderRadius(r: 30.0)),
                  child: CustomText(text: skill??'',color: blackColor),
                );
              }else{
                return const SizedBox.shrink();
              }
            }),
          ),
        ]else...[
          Utils.verticalSpace(20.0),
          CustomText(text: Utils.translatedText(context, '  No information found'), fontSize: 14, fontWeight: FontWeight.w500)
        ],
      ],
    );
  }
}

class SkillTab extends StatelessWidget {
  const SkillTab({super.key});

  @override
  Widget build(BuildContext context) {
    final serviceCubit = context.read<ServiceDetailCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: Utils.translatedText(context, 'Skills'), fontSize: 18,fontWeight: FontWeight.w600,),
        if(serviceCubit.sellerService?.seller?.skills.isNotEmpty??false)...[
          Utils.verticalSpace(10.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(Utils.parseJsonToString(serviceCubit.sellerService?.seller?.skills).length, (index){
              String? skill = Utils.parseJsonToString(serviceCubit.sellerService?.seller?.skills)[index];
              if(skill?.isNotEmpty??false){
                return Container(
                  padding: Utils.symmetric(h: 14.0,v: 10.0),
                  decoration: BoxDecoration(color: stockColor,borderRadius: Utils.borderRadius(r: 30.0)),
                  child: CustomText(text: skill??'',color: blackColor),
                );
              }else{
                return const SizedBox.shrink();
              }
            }),
          ),
        ]else...[
          Utils.verticalSpace(20.0),
          CustomText(text: Utils.translatedText(context, '  No information found'), fontSize: 14, fontWeight: FontWeight.w500)
        ]
      ]
    );
  }
}
