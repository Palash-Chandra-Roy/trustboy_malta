import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/category_model.dart';
import '../../../data/models/service/gallery_model.dart';
import '../../../data/models/service/service_edit_model.dart';
import '../../../data/models/service/service_item.dart';
import '../../../data/models/service/service_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/service_repository.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceItem> {

  final ServiceRepository _repository;
  final LoginBloc _loginBloc;

  ServiceCubit({
    required ServiceRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(ServiceItem.init());

  List<String> tempTags = [];
  
  ServiceModel? serviceModel;

  ServiceEditInfo? addUpdateInfo;

  ServiceEditInfo? editInfo;

  List<CategoryModel>? subCategories = [];


  void serviceId(int index)=>emit(state.copyWith(id: index));
  void havePlan(bool index)=>emit(state.copyWith(havePlan: index));

  void addPackage(PackageItem? package){
    final empty = PackageItem();
    if(state.packageTab == 0){
      emit(state.copyWith(basic: package??empty,serviceState: const ServiceInitial()));
    }else if(state.packageTab == 1){
      emit(state.copyWith(standard:package??empty,serviceState: const ServiceInitial()));
    }else{
      emit(state.copyWith(premium:package??empty,serviceState: const ServiceInitial()));
    }
  }

  void tabChange(int index)=>emit(state.copyWith(sellerId: index));

  void changePacTab(int index)=>emit(state.copyWith(packageTab: index));

  void stepperIndex(int index)=>emit(state.copyWith(totalView: index));

  void titleChange(String text)=>emit(state.copyWith(title: text,slug: Utils.convertToSlug(text),serviceState: const ServiceInitial()));

  void descriptionChange(String text)=>emit(state.copyWith(description: text,serviceState: const ServiceInitial()));

  void categoryId(int index)=>emit(state.copyWith(categoryId: index));

  void subCategoryId(int index)=>emit(state.copyWith(subCategoryId: index));

  void filterSubCategories() {
      subCategories = editInfo?.subCategories?.where((e)=>e.categoryId == state.categoryId).toList();
      emit(state.copyWith(subCategories: subCategories));
      final names = state.subCategories?.map((e)=>e.name).toList();
      //debugPrint('names $names');
  }

  void clearSubCat(){
    emit(state.copyWith(subCategories: <CategoryModel>[]));
  }

  void imagePick(String image){
    // final imagePath = image.split('/').last;
    emit(state.copyWith(thumbImage: image,serviceState: const ServiceInitial()));
  }

  /*void addGalleries(GalleryModel image) {
    final imagePath = image.image.split('/').last;
    if (!state.galleries.any((img) => img.image.split('/').last == imagePath)) {
      final updatedImg = List.of(state.galleries)..take(3)..add(image);
      emit(state.copyWith(galleries: updatedImg));
    }
  }*/

  void addGalleries(GalleryModel image) {
    final imagePath = image.image.split('/').last;
    if (!state.galleries.any((img) => img.image.split('/').last == imagePath)) {
      final updatedImg = List.of(state.galleries)..add(image);
      final firstThreeImg = updatedImg.take(3).toList();
      emit(state.copyWith(galleries: firstThreeImg));
    }
  }

  void updateGalleries(GalleryModel image, int index) {
    final imagePath = image.image.split('/').last;
    final updatedImg = List.of(state.galleries);
    if (index >= 0 && index < updatedImg.length) {
      if (updatedImg[index].image != imagePath) {
        updatedImg[index] = image;
        emit(state.copyWith(galleries: updatedImg));
      }
    }
  }

  void deleteGalleries(int index) {
    final updatedImg = List.of(state.galleries)..removeAt(index);
    emit(state.copyWith(galleries: updatedImg));
  }

  /*void deleteRemoteImage(GalleryModel image) {
    if (image.id > 0 && state.galleries.contains(image)) {
      debugPrint('TRUE ${image.id}');
      final updatedImg = List.of(state.galleries)..remove(image);
      emit(state.copyWith(galleries: updatedImg));
    } else {
      debugPrint('FALSE ${image.id}');
    }
  }*/


  void seoTitleChange(String text)=>emit(state.copyWith(seoTitle: text,serviceState: const ServiceInitial()));
  void seoDesChange(String text)=>emit(state.copyWith(seoDescription: text,serviceState: const ServiceInitial()));
  
  ///tags start
  void addTags(String passenger) {
    //debugPrint('added-new skill');
    final updateFeature = List.of(state.tagList)..add(passenger);
    emit(state.copyWith(tagList: updateFeature,serviceState: const ServiceInitial()));
  }

  void updateTags(int index, String passenger) {

    final updateFeature = List.of(state.tagList)..[index] = passenger;
    emit(state.copyWith(tagList: updateFeature,serviceState: const ServiceInitial()));
  }

  void removeTags(int index) {
    //debugPrint('removed-skill from $index');
    final updateFeature = List.of(state.tagList)..removeAt(index);
    emit(state.copyWith(tagList: updateFeature,serviceState: const ServiceInitial()));
  }
  ///tags start


  Future<void> createEditInfo() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.services(state.id != 0? ServiceType.edit:ServiceType.info, state.id),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      debugPrint('create-info $uri');
      emit(state.copyWith(serviceState: ServiceInfoLoading()));
      final result = await _repository.createEditInfo(uri);
      result.fold(
            (failure) {
          final errors = ServiceInfoError(failure.message, failure.statusCode);
          if(failure.statusCode == 403){
            emit(state.copyWith(havePlan: true));
          }
          emit(state.copyWith(serviceState: errors));
        }, (success) {

        editInfo = success;

        List<GalleryModel> tempGalleries = [];
        List<CategoryModel>? tempSubCategory = [];

        if(tempGalleries.isNotEmpty){
          tempGalleries.clear();
          emit(state.copyWith(galleries: tempGalleries));
        }

        if(tempSubCategory.isNotEmpty){
          tempSubCategory.clear();
          emit(state.copyWith(subCategories: tempSubCategory));
        }

        if(success.galleries?.isNotEmpty??false){
          for (int i = 0; i<(success.galleries?.length??0); i++) {
            final img = success.galleries?[i];
            final gallery = GalleryModel(id: img?.id??0,listingId: img?.listingId??0,image: img?.image??'');
            tempGalleries.add(gallery);
          }
        }

        if((success.subCategories?.isNotEmpty??false) && success.listing?.categoryId != 0){
          tempSubCategory = success.subCategories?.where((e)=>e.categoryId == success.listing?.categoryId).toList();
        }

        if (tempTags.isNotEmpty) {
          tempTags.clear();
          emit(state.copyWith(tagList: tempTags));
        }

        if ((success.listing?.tags.isNotEmpty??false) && success.listing?.tags != 'null') {
          List ? exTags = Utils.parseJsonToString(success.listing?.tags);
          for (int i = 0; i < exTags.length; i++) {
            final t = exTags[i];
            tempTags.add(t);
          }
        }

        ///clear previous data start
        final nullPackage = PackageItem();
        if(state.basic != null){
          debugPrint('basic-not-null');
          emit(state.copyWith(basic: nullPackage));
        }
        if(state.standard != null){
          debugPrint('standard-not-null');
          emit(state.copyWith(standard: nullPackage));
        }
        if(state.premium != null){
          debugPrint('premium-not-null');
            emit(state.copyWith(premium: nullPackage));
        }
        ///clear previous data end

        PackageItem ? exBasic;
        PackageItem ? exStandard;
        PackageItem ? exPremium;

        if(success.listingPackage != null){
          exBasic = PackageItem(
              description: success.listingPackage?.basicDescription??'',
              price: success.listingPackage?.basicPrice.toString()??'',
              delivery: success.listingPackage?.basicDeliveryDate.toString()?? '',
              revision: success.listingPackage?.basicRevision.toString()?? '',
              page: success.listingPackage?.basicPage.toString()?? '',
              website: success.listingPackage?.basicFnWebsite.toLowerCase()?? '',
              responsive: success.listingPackage?.basicResponsive.toLowerCase()?? '',
              code: success.listingPackage?.basicSourceCode.toLowerCase()?? '',
              content: success.listingPackage?.basicContentUpload.toLowerCase()?? '',
              optimize: success.listingPackage?.basicSpeedOptimized.toLowerCase()?? '',
          );
          exStandard = PackageItem(
            description: success.listingPackage?.standardDescription??'',
            price: success.listingPackage?.standardPrice.toString()??'',
            delivery: success.listingPackage?.standardDeliveryDate.toString()?? '',
            revision: success.listingPackage?.standardRevision.toString()?? '',
            page: success.listingPackage?.standardPage.toString()?? '',
            website: success.listingPackage?.standardFnWebsite.toLowerCase()?? '',
            responsive: success.listingPackage?.standardResponsive.toLowerCase()?? '',
            code: success.listingPackage?.standardSourceCode.toLowerCase()?? '',
            content: success.listingPackage?.standardContentUpload.toLowerCase()?? '',
            optimize: success.listingPackage?.standardSpeedOptimized.toLowerCase()?? '',
          );
          exPremium = PackageItem(
            description: success.listingPackage?.premiumDescription??'',
            price: success.listingPackage?.premiumPrice.toString()??'',
            delivery: success.listingPackage?.premiumDeliveryDate.toString()?? '',
            revision: success.listingPackage?.premiumRevision.toString()?? '',
            page: success.listingPackage?.premiumPage.toString()?? '',
            website: success.listingPackage?.premiumFnWebsite.toLowerCase()?? '',
            responsive: success.listingPackage?.premiumResponsive.toLowerCase()?? '',
            code: success.listingPackage?.premiumSourceCode.toLowerCase()?? '',
            content: success.listingPackage?.premiumContentUpload.toLowerCase()?? '',
            optimize: success.listingPackage?.premiumSpeedOptimized.toLowerCase()?? '',
          );
        }



        /*final gId = tempTags.map((e)=>e).toList();
        debugPrint('temp-tempTags $gId');*/


          if(state.id != 0){
          emit(state.copyWith(
            title: success.translate?.title??success.listing?.title??'',
            slug: Utils.convertToSlug(success.translate?.title??success.listing?.title??''),
            description: Utils.decodeHtmlEntities(success.translate?.description ?? success.listing?.description ??''),
            categoryId: success.listing?.categoryId,
            subCategoryId: success.listing?.subCategoryId,
            totalRating: success.translate?.id??0,
            thumbImage: '',
            isDraft: success.listing?.isDraft??'',
            createdAt: success.listing?.thumbImage??'',
            galleries: tempGalleries,
            seoTitle: success.listing?.seoTitle??'',
            seoDescription: success.listing?.seoDescription??'',
            tagList: tempTags,
            subCategories: tempSubCategory,
            basic: exBasic,
            standard: exStandard,
            premium: exPremium,
          ));
        }
       /* final gSId = state.tagList.map((e)=>e).toList();
        debugPrint('state-tags $gSId');*/
        // debugPrint('draft-service ${state.isDraft}');
        debugPrint('sub-category ${state.subCategoryId}');

          final loaded = ServiceInfoLoaded(success);
        emit(state.copyWith(serviceState: loaded));
        },
      );
    }
  }

  Future<void> sellerAllServices() async {
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.all, state.id), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);
     emit(state.copyWith(serviceState: ServiceListLoading()));
     final result = await _repository.serviceDetail(uri);
     result.fold((failure) {
       final errorState = ServiceListError(failure.message, failure.statusCode);
       emit(state.copyWith(serviceState: errorState));
     }, (success) {
       serviceModel = success;
       final successState = ServiceListLoaded(success);
       emit(state.copyWith(serviceState: successState));
     });
   }
  }

  Future<void> addUpdatePackage() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      log('add-body ${state.toMap()}');

      Uri uri;

      if(state.totalView == 0){
        if(state.id == 0){
          uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.create, state.id),
              _loginBloc.userInformation?.accessToken ?? '',
              _loginBloc.state.langCode);
        }else{
          uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.update, state.id),
              _loginBloc.userInformation?.accessToken ?? '',
              _loginBloc.state.langCode,extraParams: {'_method': 'PUT'});
        }

      } else if(state.totalView == 1){
        uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.package, state.id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }else{
        uri =  Uri.parse('');
      }
      debugPrint('addUpdate $uri');

      emit(state.copyWith(serviceState: ServiceAddLoading()));
      final result = await _repository.addUpdate(uri,state);
      result.fold(
            (failure) {
          if(failure is InvalidAuthData){
            final errors = ServiceAddFormError(failure.errors);
            emit(state.copyWith(serviceState: errors));
          }else{
            final errors = ServiceAddError(failure.message, failure.statusCode);
            emit(state.copyWith(serviceState: errors));
          }
        }, (success) {
        addUpdateInfo = success;
        final loaded = ServiceAddLoaded(success);
        emit(state.copyWith(serviceState: loaded));

          if(state.totalView == 0 && state.id == 0){
            emit(state.copyWith(id: success.listing?.id??0,totalRating: success.translate?.id??0,isDraft: success.listing?.isDraft??''));
            debugPrint('state.id assigned ${state.id}');
          }
        },
      );
    }
  }

  Future<void> submitOther() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      log('add-body ${state.toMap()}');
      Uri uri;

      if(state.totalView == 2){
        uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.imgAdd, state.id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);

      } else if(state.totalView == 3){
        uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.seo, state.id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode,extraParams: {'_method': 'POST'});
      }else{
        uri =  Uri.parse('');
      }
      debugPrint('submitOther $uri');

      emit(state.copyWith(serviceState: ServiceAddLoading()));
      final result = await _repository.addImages(uri,state);
      result.fold(
            (failure) {
          if(failure is InvalidAuthData){
            final errors = ServiceAddFormError(failure.errors);
            emit(state.copyWith(serviceState: errors));
          }else{
            final errors = ServiceAddError(failure.message, failure.statusCode);
            emit(state.copyWith(serviceState: errors));
          }
        }, (success) {
        final loaded = ServiceSubmitted(success);
        emit(state.copyWith(serviceState: loaded));
        },
      );
    }
  }

  Future<void> addSeo([bool isPublish = false]) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      log('seo-body ${state.toMap()}');

      Uri uri;

      if(isPublish == true){
        uri = Utils.tokenWithCode(RemoteUrls.services( ServiceType.publish, state.id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }else{
        uri = Utils.tokenWithCode(RemoteUrls.services( ServiceType.seo, state.id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }

      debugPrint('seo-uri $uri');

      emit(state.copyWith(serviceState: ServiceAddLoading()));
      final result = await _repository.addSeoInfo(uri,state);
      result.fold((failure) {
          if(failure is InvalidAuthData){
            final errors = ServiceAddFormError(failure.errors);
            emit(state.copyWith(serviceState: errors));
          }else{
            final errors = ServiceAddError(failure.message, failure.statusCode);
            emit(state.copyWith(serviceState: errors));
          }
        }, (success) {
        final loaded = ServiceSubmitted(success);
        emit(state.copyWith(serviceState: loaded));
      },
      );
    }
  }

  Future<void> serviceStatus(int id) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

        final uri = Utils.tokenWithCode(RemoteUrls.services( ServiceType.status, id),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);

      debugPrint('status-uri $uri');

      emit(state.copyWith(serviceState: ServiceAddLoading()));
      final result = await _repository.addSeoInfo(uri,state);
      result.fold((failure) {
        if(failure is InvalidAuthData){
          final errors = ServiceAddFormError(failure.errors);
          emit(state.copyWith(serviceState: errors));
        }else{
          final errors = ServiceAddError(failure.message, failure.statusCode);
          emit(state.copyWith(serviceState: errors));
        }
      }, (success) {
        final loaded = ServiceSubmitted(success);
        emit(state.copyWith(serviceState: loaded));
      },
      );
    }
  }

  Future<void> deleteGalleryImg(int id,[bool isImg = true]) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
        Uri uri;
        if(isImg){
          uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.imgDelete, id),
              _loginBloc.userInformation?.accessToken ?? '',
              _loginBloc.state.langCode);
        }else{
          uri = Utils.tokenWithCode(RemoteUrls.services(ServiceType.serviceDelete, id),
              _loginBloc.userInformation?.accessToken ?? '',
              _loginBloc.state.langCode);
        }

        debugPrint('delete-uri $uri');
      // emit(state.copyWith(serviceState: ServiceAddLoading()));
      final result = await _repository.deleteImage(uri);
      result.fold(
            (failure) {
          if(failure is InvalidAuthData){
            final errors = ServiceAddFormError(failure.errors);
            emit(state.copyWith(serviceState: errors));
          }else{
            final errors = ServiceAddError(failure.message, failure.statusCode);
            emit(state.copyWith(serviceState: errors));
          }
        }, (success) {
         /*     if(!isImg){
                serviceModel?.buyerJobPosts?.removeWhere((job)=>job.id == state.id);
                final loaded = JobPostDeleteLoaded(success);
                emit(state.copyWith(postState: loaded));
                final existJobs = JobPostLoaded(jobPost!);
                emit(state.copyWith(postState: existJobs));
              }else{
                final loaded = ServiceSubmitted(success);
                emit(state.copyWith(serviceState: loaded));
              }*/
          final loaded = ServiceSubmitted(success);
          emit(state.copyWith(serviceState: loaded));
        },
      );
    }
  }

  void initState()=>emit(state.copyWith(serviceState: const ServiceInitial()));

  void clear(){
    emit(state.copyWith(
      id: 0,
      title: '',
      description: '',
      categoryId: 0,
      subCategoryId: 0,
      subCategories: <CategoryModel>[],
      galleries: <GalleryModel>[],
      basic: null,
      standard: null,
      premium: null,
      packageTab: 0,
      createdAt: '',
      isDraft: '',
      totalRating: 0,
      seoTitle: '',
      seoDescription: '',
      thumbImage: '',
      tagList: <String>[],
      serviceState: const ServiceInitial(),
    ));
  }

}
