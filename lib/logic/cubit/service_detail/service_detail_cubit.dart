
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/models/service/review_model.dart';
import '/data/models/service/service_model.dart';
import '../../../data/models/home/job_post.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/service_repository.dart';

part 'service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ReviewModel> {
  final ServiceRepository _repository;
  final LoginBloc _loginBloc;

  ServiceDetailCubit({
    required ServiceRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(ReviewModel.init());

  ServiceModel? detail;

  ServiceModel? sellerService;

  JobPostModel? jobDetail;

  List<String> ? galleries = [];

  void addSlug(String slug)=>emit(state.copyWith(status: slug));

  void addType(String slug)=>emit(state.copyWith(reviewBy: slug));

  void carouselId(int slug)=>emit(state.copyWith(listingId: slug));
  void readMore()=>emit(state.copyWith(readMore: !state.readMore));

  Future<void> serviceDetail() async {
    final isService = state.reviewBy == 'service';
    final uri = Uri.parse(isService? RemoteUrls.serviceDetail(state.status):RemoteUrls.sellerDetail(state.status)).replace(queryParameters: {'lang_code': _loginBloc.state.langCode});
    debugPrint('detail-service $uri');
    emit(state.copyWith(detailState: ServiceDetailStateLoading()));
    final result = await _repository.serviceDetail(uri);
    result.fold((failure) {
      final errorState = ServiceDetailStateError(failure.message, failure.statusCode);
      emit(state.copyWith(detailState: errorState));
    }, (success) {
      if(success.servicePackage != null){
        detail = success;
      }else{
        sellerService = success;
      }
   /*   detail = success;
      sellerService = success;*/
      final successState = ServiceDetailStateLoaded(success);
      emit(state.copyWith(detailState: successState));
    });

    if(isService){
      _addGalleries();
    }
  }

  Future<void> jobPostDetail() async {
    final uri = Uri.parse( RemoteUrls.jobPostDetail(state.status)).replace(queryParameters: {'lang_code': _loginBloc.state.langCode});
    debugPrint('detail-service $uri');
    emit(state.copyWith(detailState: ServiceDetailStateLoading()));
    final result = await _repository.jobPostDetail(uri);
    result.fold((failure) {
      final errorState = ServiceDetailStateError(failure.message, failure.statusCode);
      emit(state.copyWith(detailState: errorState));
    }, (success) {
      jobDetail = success;
      final successState = JobsDetailStateLoaded(success);
      emit(state.copyWith(detailState: successState));
    });
  }


  void _addGalleries(){

    galleries?.clear();

    if(detail?.service?.thumbImage.isNotEmpty??false){
      galleries?.addAll([detail?.service?.thumbImage??'']);
    }

    if(detail?.galleries?.isNotEmpty??false){
      for (int i = 0; i< (detail?.galleries?.length ?? 0); i++) {
        final item = detail?.galleries?[i];
        galleries?.addAll([item?.image??'']);
      }
    }

    emit(state.copyWith(listingId: 0,readMore: false));

    final images = galleries?.map((e)=>RemoteUrls.imageUrl(e)).toList();
    // log('add-galleries $images');
  }

}
