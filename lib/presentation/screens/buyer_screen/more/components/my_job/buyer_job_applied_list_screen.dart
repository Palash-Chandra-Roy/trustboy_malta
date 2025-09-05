import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/models/home/job_post.dart';
import '../../../../../../data/models/home/my_application_model.dart';
import '../../../../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../../../../utils/k_images.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../../widgets/fetch_error_text.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/page_refresh.dart';
import 'job_applied_card.dart';


class BuyerJobAppliedListScreen extends StatefulWidget {
  const BuyerJobAppliedListScreen({super.key});
  @override
  State<BuyerJobAppliedListScreen> createState() => _BuyerJobAppliedListScreenState();
}

class _BuyerJobAppliedListScreenState extends State<BuyerJobAppliedListScreen> {

  late JobPostCubit serviceCubit;
  //final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<JobPostCubit>();

    Future.microtask(()=>serviceCubit.getAllAppliedList());
  }

  @override
  void dispose() {
    serviceCubit.tabChange(0);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Job Applications')),
      body: PageRefresh(
        onRefresh: () async {
          serviceCubit.getAllAppliedList();
        },
        child: Utils.logout(
          child: BlocConsumer<JobPostCubit, JobPostItem>(
            listener: (context, service) {
              final state = service.postState;
              if (state is JobPostReqError) {
                if (state.statusCode == 503 || serviceCubit.jobPost == null) {
                  serviceCubit.getAllAppliedList();
                }
                if(state.statusCode == 401){
                  Utils.logoutFunction(context);
                }
              }

              // if(serviceCubit.isNavigating){
              //   return;
              // }else{
                if(state is JobPostDeleteLoading){
                  Utils.loadingDialog(context);
                }else{
                  Utils.closeDialog(context);
                  if(state is JobPostDeleteError){
                    serviceCubit.initState();
                    if(state.statusCode == 401){
                      Utils.logoutFunction(context);
                    }
                    Utils.errorSnackBar(context, state.message);
                  }else if(state is JobPostDeleteLoaded){
                    serviceCubit.initState();
                    Utils.showSnackBar(context, state.message);
                    Future.delayed(const Duration(milliseconds: 800),(){
                      serviceCubit.getAllAppliedList();
                    });
                  }
                }
              //}

              // if (state is JobPostAddedLoaded && service.id != 0){
              //   debugPrint('call-list-again ${service.id}');
              //   serviceCubit.getJobPostList();
              // }

            },
            builder: (context, service) {
              final state = service.postState;
              if (state is JobPostReqLoading) {
                return const LoadingWidget();
              } else if (state is JobPostReqError) {
                if (state.statusCode == 503) {
                  return LoadedApplicants(applicants: serviceCubit.applicants);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is JobPostReqLoaded) {
                return LoadedApplicants(applicants: state.jobPost);
              }
              if (serviceCubit.applicants.isNotEmpty) {
                return LoadedApplicants(applicants: serviceCubit.applicants);
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

class LoadedApplicants extends StatelessWidget {
  const LoadedApplicants({super.key, required this.applicants});
  final List<ApplicationModel> applicants;
  @override
  Widget build(BuildContext context) {
    if(applicants.isNotEmpty){
      return ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (context,index){
          return Padding(
            padding: Utils.symmetric(h: 20.0, v: 6.0),
            child:  JobAppliedCard(applicant: applicants[index]),
          );
        },
      );
    }else{
      return EmptyWidget(image: KImages.emptyOrder,isSliver: false);
    }
  }

}
