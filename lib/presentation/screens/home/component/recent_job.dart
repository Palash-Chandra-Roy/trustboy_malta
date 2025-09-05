import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/cubit/service_list/service_list_cubit.dart';
import '/data/models/home/job_post.dart';

import '../../../routes/route_names.dart';
import '../../../utils/utils.dart';
import '../../buyer_screen/more/components/my_job/job_card.dart';
import 'heading.dart';

class RecentJob extends StatelessWidget {
  const RecentJob({super.key, required this.jobPosts});

  final List<JobPostItem> jobPosts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.symmetric(),
      child: Column(
        children: [
          Heading(
            title1: Utils.translatedText(context, 'Recent Job Post'),
            padding: Utils.only(bottom: 20.0),
            onTap: () {
              context.read<ServiceListCubit>()..initPage()..clearFilterData();
              Navigator.pushNamed(context, RouteNames.allJobScreen);
            },
          ),
          ...List.generate(jobPosts.length > 4 ? 4 : jobPosts.length, (index) {
            return Padding(
              padding: Utils.only(bottom: 14.0),
              child:  JobCard(item: jobPosts[index]),
            );
          })
        ],
      ),
    );
  }
}
