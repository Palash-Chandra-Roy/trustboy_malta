import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/presentation/errors/failure.dart';


import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/job_post.dart';
import '../../../data/models/home/my_application_model.dart';
import '../../../data/models/job/job_create_info.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/job_post_repository.dart';

part 'job_post_state.dart';

class JobPostCubit extends Cubit<JobPostItem> {
  final LoginBloc _loginBloc;
  final JobPostRepository _repository;

  JobPostCubit({
    required LoginBloc loginBloc,
    required JobPostRepository repository,
  })  : _loginBloc = loginBloc,
        _repository = repository,
        super(JobPostItem.init());


  bool isNavigating = false;

  JobPostModel? jobPost;

  JobCreateInfo ?createInfo;

  JobCreateInfo ? addedJobPost;

  JobCreateInfo ? editedJobPost;
  //
  // List<JobPostItem> awaitingList = [];
  //
  // List<JobPostItem> hiredList = [];
  //
  // List<JobPostItem> pendingList = [];

  // List<JobCategory> jobCategories = [];
  List<ApplicationModel> applicants = [];

  ApplicationModel? myJobReqDetail;

  void tabChange(int index)=>emit(state.copyWith(totalView: index));
  void applicantId(int index)=>emit(state.copyWith(cityId: index));

  Future<void> getJobPostList() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
        RemoteUrls.getJobPostList,
        _loginBloc.userInformation?.accessToken ?? '',
        _loginBloc.state.langCode);
     // debugPrint('url $uri');
      emit(state.copyWith(postState: JobPostLoading()));
      final result = await _repository.getJobPostList(uri);
      result.fold(
        (failure) {
      final errors = JobPostError(failure.message, failure.statusCode);
      emit(state.copyWith(postState: errors));
    }, (success) {
       jobPost = success;
      final loaded = JobPostLoaded(success);
      emit(state.copyWith(postState: loaded));
    },
      );
    }
  }

  Future<void> getJobReqList() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.getJobReqList,
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      //debugPrint('url $uri');
      emit(state.copyWith(postState: JobPostLoading()));
      final result = await _repository.getJobReqList(uri);
      result.fold(
            (failure) {
          final errors = JobPostError(failure.message, failure.statusCode);
          emit(state.copyWith(postState: errors));
        }, (success) {
        jobPost = success;
        final loaded = JobPostLoaded(success);
        emit(state.copyWith(postState: loaded));
        },
      );
    }
  }

  Future<void> jobPostCreateInfo() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
        RemoteUrls.getCreateJobInfo,
        _loginBloc.userInformation?.accessToken ?? '',
        _loginBloc.state.langCode);
      //debugPrint('create-info $uri');
      final result = await _repository.jobPostCreateInfo(uri);
      result.fold(
            (failure) {
          final errors = JobPostError(failure.message, failure.statusCode);
          emit(state.copyWith(postState: errors));
        }, (success) {
          createInfo = success;
          final loaded = JobPostInfoLoaded(success);
          emit(state.copyWith(postState: loaded));
        },
      );
    }
  }

  Future<void> addJobPost() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      //debugPrint('job-body ${state.toMap()}');
        final uri = Utils.tokenWithCode(
          RemoteUrls.getJobPostList,
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      emit(state.copyWith(postState: JobPostAddingLoading()));
      final result = await _repository.addJobPost(uri,state);
      result.fold(
        (failure) {
          if(failure is InvalidAuthData){
            final errors = JobPostApplyFormError(failure.errors);
                emit(state.copyWith(postState: errors));
          }else{
            final errors = JobPostAddError(failure.message, failure.statusCode);
            emit(state.copyWith(postState: errors));
          }
    }, (success) {
        addedJobPost = success;
        final loaded = JobPostAddedLoaded('Success',success);
        emit(state.copyWith(postState: loaded));
        },
      );
    }
  }

  Future<void> applyJobPost(String id) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      //debugPrint('job-apply-body ${state.toApplyMap()}');
      final uri = Utils.tokenWithCode(
          RemoteUrls.applyJobPost(id),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      emit(state.copyWith(postState: JobPostAddingLoading()));
      final result = await _repository.applyJob(uri,state);
      result.fold(
            (failure) {
          if(failure is InvalidAuthData){
            final errors = JobPostApplyFormError(failure.errors);
            emit(state.copyWith(postState: errors));
          }else{
            final errors = JobPostApplyError(failure.message, failure.statusCode);
            emit(state.copyWith(postState: errors));
          }
        }, (success) {
        final loaded = JobPostApplyLoaded(success);
        emit(state.copyWith(postState: loaded));
      },
      );
    }
  }

  Future<void> updateJobPost() async {
    // log('${state.toMap()}',name: 'addJobDate');

    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.updateJobPost(state.id.toString()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode,extraParams: {'_method':'PUT'});
      //debugPrint('create-info $uri');
      //log('${state.toMap()}',name: 'addJobDate');
      emit(state.copyWith(postState: JobPostAddingLoading()));
      final result = await _repository.updateJobPost(uri,state);
      result.fold(
            (failure) {
              if(failure is InvalidAuthData){
                final errors = JobPostApplyFormError(failure.errors);
                    emit(state.copyWith(postState: errors));
              }else{
              final errors = JobPostAddError(failure.message, failure.statusCode);
              emit(state.copyWith(postState: errors));
              }
        }, (success) {
        // addedJobPost = success;
        final loaded = JobPostAddedLoaded(success,null);
        emit(state.copyWith(postState: loaded));
          },
      );
    }
  }

  Future<void> editJobPost() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.editJobPost(state.id.toString()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
     // debugPrint('create-info $uri');
      //log('${state.toMap()}',name: 'addJobDate');
      emit(state.copyWith(postState: JobPostEditLoading()));
      final result = await _repository.editJobPost(uri);
      result.fold(
        (failure) {
          final errors = JobPostEditError(failure.message, failure.statusCode);
          emit(state.copyWith(postState: errors));
    }, (success) {
    editedJobPost = success;
    if(success.jobPostTranslate != null){
        emit(state.copyWith(
        title: success.jobPostTranslate?.title,
        slug: Utils.convertToSlug(success.jobPostTranslate?.title??''),
        description: Utils.decodeHtmlEntities(success.jobPostTranslate?.description??''),
        userId: success.jobPostTranslate?.id,
        status: success.jobPostTranslate?.langCode,
      ));
    }
    if(success.jobPost != null){
      emit(state.copyWith(
        categoryId: success.jobPost?.categoryId,
        cityId: success.jobPost?.cityId,
        jobType: success.jobPost?.jobType,
        isUrgent: success.jobPost?.regularPrice.toString(),
        slug: success.jobPost?.slug,
        createdAt: success.jobPost?.thumbImage,
      ));
      //debugPrint('thumbImage ${success.jobPost?.thumbImage}');
    }
   // debugPrint('createAtImage ${state.createdAt}');
   // debugPrint('description-text-state ${state.description}');
      final loaded = JobPostEditLoaded(success);
    emit(state.copyWith(postState: loaded));
  },
      );
    }
  }

  Future<void> deleteJobPost() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.updateJobPost(state.id.toString()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      //debugPrint('delete-info $uri');
      emit(state.copyWith(postState: JobPostDeleteLoading()));
      final result = await _repository.deleteJobPost(uri);
      result.fold(
            (failure) {
          final errors = JobPostDeleteError(failure.message, failure.statusCode);
          emit(state.copyWith(postState: errors));
        }, (success) {
            jobPost?.buyerJobPosts?.removeWhere((job)=>job.id == state.id);
            final loaded = JobPostDeleteLoaded(success);
            emit(state.copyWith(postState: loaded));
            // final existJobs = JobPostLoaded(jobPost!);
            // emit(state.copyWith(postState: existJobs));
       },
      );
    }
  }

   Future<void> getAllAppliedList() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
       final uri = Utils.tokenWithCode(
           RemoteUrls.buyerJobApplicants(state.cityId.toString()),
           _loginBloc.userInformation?.accessToken ?? '',
           _loginBloc.state.langCode);
       emit(state.copyWith(postState: JobPostReqLoading()));
       final result = await _repository.getMyJobPostList(uri);
       result.fold(
             (failure) {
           final errors = JobPostReqError(failure.message, failure.statusCode);
           emit(state.copyWith(postState: errors));
         },
             (success) {
           applicants = success;
           final loaded = JobPostReqLoaded(success);
           emit(state.copyWith(postState: loaded));
         },
       );
 }
  }

  Future<void> hiredApplicant(String id) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
       final uri = Utils.tokenWithCode(
           RemoteUrls.hiredApplicant(id),
           _loginBloc.userInformation?.accessToken ?? '',
           _loginBloc.state.langCode);
       emit(state.copyWith(postState: JobPostDeleteLoading()));
       final result = await _repository.hiredApplicant(uri);
       result.fold(
             (failure) {
           final errors = JobPostDeleteError(failure.message, failure.statusCode);
           emit(state.copyWith(postState: errors));
         },
             (success) {
           final loaded = JobPostDeleteLoaded(success);
           emit(state.copyWith(postState: loaded));
         },
       );
 }
  }

  // Future<void> getMyJobPostDetail(String id) async {
  //   final uri = Utils.tokenWithCodeAndPage(
  //       RemoteUrls.getMyJobPostDetail(id),
  //       _loginBloc.userInformation!.accessToken,
  //       _loginBloc.state.languageCode,
  //       '1');
  //   emit(state.copyWith(postState: JobPostReqDetailsLoading()));
  //   final result = await _repository.getMyJobPostDetail(uri);
  //   result.fold(
  //     (failure) {
  //       final errors =
  //           JobPostReqDetailsError(failure.message, failure.statusCode);
  //       emit(state.copyWith(postState: errors));
  //     },
  //     (success) {
  //       myJobReqDetail = success;
  //       final loaded = JobPostReqDetailsLoaded(success);
  //       emit(state.copyWith(postState: loaded));
  //     },
  //   );
  // }
  //
  // Future<void> getJobDetails(String id) async {
  //   final uri = Utils.tokenWithCode(RemoteUrls.getJobDetails(id),
  //       _loginBloc.userInformation!.accessToken, _loginBloc.state.languageCode);
  //   emit(state.copyWith(postState: JobPostLoading()));
  //   final result = await _repository.getJobDetails(uri);
  //   result.fold(
  //     (failure) {
  //       final errors = JobPostDetailsError(failure.message, failure.statusCode);
  //       emit(state.copyWith(postState: errors));
  //     },
  //     (success) {
  //       jobDetails = success;
  //       final loaded = JobPostDetailsLoaded(success);
  //       emit(state.copyWith(id: jobDetails!.id, userId: jobDetails!.userId));
  //       emit(state.copyWith(postState: loaded));
  //     },
  //   );
  // }
  //
  // Future<void> applyJob() async {
  //   final uri = Utils.tokenWithCode(RemoteUrls.applyJob(state.lotSize),
  //       _loginBloc.userInformation!.accessToken, _loginBloc.state.languageCode);
  //   log('job-apply-body', name: '${state.toApplyMap()}');
  //   emit(state.copyWith(postState: JobPostApplyLoading()));
  //   final result = await _repository.applyJob(uri, state);
  //   result.fold(
  //     (failure) {
  //       if (failure is InvalidAuthData) {
  //         final errors = JobPostApplyFormError(failure.errors);
  //         emit(state.copyWith(postState: errors));
  //       } else {
  //         final errors = JobPostApplyError(failure.message, failure.statusCode);
  //         emit(state.copyWith(postState: errors));
  //       }
  //     },
  //     (success) {
  //       final loaded = JobPostApplyLoaded(success);
  //       emit(state.copyWith(postState: loaded));
  //     },
  //   );
  // }
  //
  // Future<Either<Failure, bool>> chatFileDownload(String endPoint) async {
  //   final rootUrl = RemoteUrls.chatFileDownload(endPoint);
  //   final dir = await Utils.getDir();
  //
  //   if (dir.isEmpty) {
  //     return const Right(false);
  //   }
  //
  //   final fileExtension = path.extension(rootUrl);
  //   final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
  //   final filePath = path.join(dir, fileName);
  //   final file = File(filePath);
  //   debugPrint("File-name $fileName");
  //
  //   HttpClient httpClient = HttpClient();
  //
  //   try {
  //     var request = await httpClient.getUrl(Uri.parse(rootUrl));
  //     var response = await request.close();
  //
  //     if (response.statusCode == 200) {
  //       var bytes = <int>[];
  //       int total = 0;
  //       final contentLength = response.contentLength;
  //
  //       response.listen(
  //         (List<int> chunk) {
  //           bytes.addAll(chunk);
  //           total += chunk.length;
  //           emit(state.copyWith(downloadProgress: total / contentLength));
  //         },
  //         onDone: () async {
  //           await file.writeAsBytes(bytes);
  //           debugPrint("File downloaded to $filePath");
  //           //open_file.OpenFile.open(filePath); // Open the file after downloading
  //           emit(state.copyWith(downloadProgress: 1.0));
  //         },
  //         onError: (e) {
  //           debugPrint("Download failed: $e");
  //           emit(state.copyWith(downloadProgress: 0.0));
  //         },
  //         cancelOnError: true,
  //       );
  //
  //       return const Right(true);
  //     } else {
  //       debugPrint('Error code: ${response.statusCode}');
  //       return const Right(false);
  //     }
  //   } catch (e) {
  //     debugPrint("Download failed: $e");
  //     return const Right(false);
  //   }
  // }

  //Future<void> searchJobs() async {}
  //
  // void searchJob(String name) {
  //   if (jobPost != null && jobPost!.jobPosts!.isNotEmpty) {
  //     final lowerCaseName = name.toLowerCase();
  //     final List<JobPost> searchedPost = jobPostList.where((customer) {
  //       final customerName = customer.title.toLowerCase();
  //       return customerName.contains(lowerCaseName);
  //     }).toList();
  //     emit(state.copyWith(postState: JobPostLoaded(searchedPost)));
  //   } else {
  //     emit(state.copyWith(postState: const JobPostLoaded(<JobPost>[])));
  //   }
  // }
  //
  // void filterJobPost(int id, String type) {
  //   if (jobPost != null && jobPost!.jobPosts!.isNotEmpty) {
  //     if (type == 'by-city') {
  //       final List<JobPost> filteredPosts =
  //           jobPost!.jobPosts!.where((post) => post.cityId == id).toList();
  //       // log('match-id ${filteredPosts.map((post) => post.cityId).join(', ')}');
  //       // log('total-jobs ${filteredPosts.length}');
  //       emit(state.copyWith(postState: JobPostLoaded(filteredPosts)));
  //     } else {
  //       final List<JobPost> filteredPosts =
  //           jobPost!.jobPosts!.where((post) => post.categoryId == id).toList();
  //
  //       emit(state.copyWith(postState: JobPostLoaded(filteredPosts)));
  //     }
  //   } else {
  //     emit(state.copyWith(postState: const JobPostLoaded(<JobPost>[])));
  //   }
  // }
  //
  // void storeJobCat() {
  //   jobCategories.clear();
  //   if (jobPost != null && jobPost!.jobCategories!.isNotEmpty) {
  //     final cat = jobPost!.jobCategories;
  //     for (int i = 0; i < cat!.length; i++) {
  //       jobCategories.add(cat[i]);
  //     }
  //   }
  // }
  //
  // void jobApplyId(String text) {
  //   emit(state.copyWith(lotSize: text));
  // }

  void updateId(int text) => emit(state.copyWith(id: text));

  void thumbImageChange(String text) {
    emit(state.copyWith(thumbImage: text, postState: const JobPostInitial()));
  }

  void categoryIdChange(int text) {
    emit(state.copyWith(categoryId: text, postState: const JobPostInitial()));
  }

  void cityIdChange(int text) {
    emit(state.copyWith(cityId: text, postState: const JobPostInitial()));
  }

  void titleChange(String text) {
    emit(
      state.copyWith(
        title: text,
        slug: Utils.convertToSlug(text),
        postState: const JobPostInitial(),
      ),
    );
  }

  void priceChange(String text) {
    emit(state.copyWith(isUrgent: text, postState: const JobPostInitial()));
  }

  void jobTypeChange(String text) {
    emit(state.copyWith(jobType: text, postState: const JobPostInitial()));
  }

  void descriptionChange(String text) {
    emit(state.copyWith(description: text, postState: const JobPostInitial()));
  }

  void allJobs(int id){
    // final names = jobPost?.buyerJobPosts?.map((i)=>i.id).toList();
    final match = jobPost?.buyerJobPosts?.where((i)=>i.id == id);
    //debugPrint('all-name ${match?.first.title}');
  }

  // void addressChange(String text) {
  //   emit(state.copyWith(address: text, postState: const JobPostInitial()));
  //}

  // void statusChange(String text) {
  //   emit(state.copyWith(status: text, postState: const JobPostInitial()));
  // }

  // void addResume(String text) {
  //   emit(state.copyWith(resume: text, postState: const JobPostInitial()));
  // }
  //
  // void changeFilterValue(String text) {
  //   log(text, name: 'filter-value');
  //   emit(state.copyWith(filterValue: text, postState: const JobPostInitial()));
  // }
  //

  void clear() {
    emit(state.copyWith(
        id: 0,
        title: '',
        description: '',
        categoryId: 0,
        cityId: 0,
        isUrgent: '',
        jobType: '',
        thumbImage: '',
        createdAt: '',
        postState: const JobPostInitial(),
      ),
    );
  }

  void initState(){
    emit(state.copyWith(postState: const JobPostInitial()));
  }

  /*void filterJobPost(){
      if(jobPostList.isNotEmpty){
        for(final p in jobPostList){
          awaitingList.clear();
          hiredList.clear();
          pendingList.clear();

          if(p.approvedByAdmin == 'approved'){
            if( p.checkJobStatus == 'approved'){
              hiredList.add(p);
            }else if( p.checkJobStatus == 'pending'){
              pendingList.add(p);
            }else{
              awaitingList.add(p);
            }
          }
        }
      }
      debugPrint('t-a-p-h ${jobPostList.length}-${awaitingList.length}-${pendingList.length}-${hiredList.length}');
  }*/
}
