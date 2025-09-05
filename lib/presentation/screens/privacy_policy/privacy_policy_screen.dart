import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../data/models/terms_conditions/terms_conditions.dart';
import '../../../logic/cubit/terms_and_policy/terms_and_policy_cubit.dart';
import '../../../logic/cubit/terms_and_policy/terms_and_policy_state.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key, required this.type});
  final String type;

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {


  late TermsAndPolicyCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<TermsAndPolicyCubit>();

    Future.microtask((){
      if(widget.type == 'privacy'){
      termCubit.privacyPolicy();
      }else{
        termCubit.termsAndConditions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  DefaultAppBar(title: widget.type=='privacy'? Utils.translatedText(context, 'Privacy Policy'):Utils.translatedText(context, 'Terms and Conditions')),
      body: PageRefresh(
        onRefresh: () async {
          if(widget.type == 'privacy'){
            termCubit.privacyPolicy();
          }else{
            termCubit.termsAndConditions();
          }
        },
        child: BlocConsumer<TermsAndPolicyCubit, TermsConditionsModel>(
          listener: (context, service) {
            final state = service.termState;
            if (state is TermsAndPolicyStateError) {
              if (state.statusCode == 503 || termCubit.termsConditionsModel == null) {
                if(widget.type == 'privacy'){
                  termCubit.privacyPolicy();
                }else{
                  termCubit.termsAndConditions();
                }
              }
            }

          },
          builder: (context, service) {
            final state = service.termState;
            if (state is TermsAndPolicyStateLoading) {
              return const LoadingWidget();
            } else if (state is TermsAndPolicyStateError) {
              if (state.statusCode == 503 || termCubit.termsConditionsModel != null) {
                return LoadedTermCondition(termsCon: termCubit.termsConditionsModel);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is TermsAndPolicyStateLoaded) {
              return LoadedTermCondition(termsCon: state.termsConditionsModel);
            }
            if (termCubit.termsConditionsModel != null) {
              return LoadedTermCondition(termsCon: termCubit.termsConditionsModel);
            } else {
              return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class LoadedTermCondition extends StatelessWidget {
  const LoadedTermCondition({super.key, required this.termsCon});
  final TermsConditionsModel? termsCon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: Utils.symmetric(v: 12.0),
          margin: Utils.symmetric(),
        decoration: BoxDecoration(
        borderRadius: Utils.borderRadius(r: 10.0),
          color: whiteColor,
        ),
        child: HtmlWidget(termsCon?.description??''),
      ),
    );
  }
}

