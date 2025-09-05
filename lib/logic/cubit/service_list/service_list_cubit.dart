

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/utils/utils.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/filter/filter_model.dart';
import '../../../data/models/home/category_model.dart';
import '../../../data/models/home/job_post.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../data/models/service/service_item.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/service_repository.dart';

part 'service_list_state.dart';

class ServiceListCubit extends Cubit<CategoryModel> {

  final LoginBloc _loginBloc;
  final ServiceRepository _repository;

  ServiceListCubit({
    required LoginBloc loginBloc,
    required ServiceRepository repository,
  })  : _loginBloc = loginBloc,
        _repository = repository,
        super(CategoryModel.init());

  List<ServiceItem> serviceItems = [];

  List<ServiceItem> filterServices = [];

  List<SellerModel> sellerItems = [];

  List<SellerModel> filterSeller = [];

  List<JobPostItem> jobItems = [];

  List<JobPostItem> filterJob = [];

  FilterModel? filter;


  void addCategories(CategoryModel brands) {
    final updatedItem = List.of(state.categories);
    if (state.categories.contains(brands)) {
      updatedItem.remove(brands);
    } else {
      updatedItem.add(brands);
    }
    emit(state.copyWith(categories: updatedItem));
  }

  void addCities(CategoryModel brands) {
    final updatedItem = List.of(state.cities);
    if (state.cities.contains(brands)) {
      updatedItem.remove(brands);
    } else {
      updatedItem.add(brands);
    }
    emit(state.copyWith(cities: updatedItem));
  }

  void searchText(String value) => emit(state.copyWith(name: value));
  void sortText(String value) => emit(state.copyWith(slug: value));
  void serviceByCatText(String value) => emit(state.copyWith(icon: value));
  void priceFilter(String value) => emit(state.copyWith(price: value));
  void nameText(String value){
    emit(state.copyWith(image: value));
    debugPrint('state-category ${Utils.convertToSlug(state.image)}');
  }
  void cityText(String value){
    emit(state.copyWith(city: value));
  }

  void clearFilterData(){
    emit(state.copyWith(
      image: '',
      name: '',
      city: '',
      slug: '',
      icon: '',
      price: '',
      totalService: 1,
      isListEmpty: false,
      categories: <CategoryModel>[],
      cities: <CategoryModel>[],

    ));
  }



  Future<void> getAllServices([bool isFilter = false]) async {
    emit(state.copyWith(serviceState: ServiceLoadingState()));
    final Uri uri;
    if(isFilter == true){
      uri = Uri.parse(RemoteUrls.serviceList)
          .replace(queryParameters: {'lang_code':_loginBloc.state.langCode,...state.toMap()});
      // debugPrint('service-filter-url $uri');
    }else{
      if(state.image.isNotEmpty){
        uri = Uri.parse(RemoteUrls.serviceList)
            .replace(queryParameters: {'category': state.image, 'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString()});
      }else{
        uri = Uri.parse(RemoteUrls.serviceList)
            .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString()});
      }

      // debugPrint('service-url $uri');
    }
    //debugPrint('service-url $uri');
    final result = await _repository.getAllServices(uri);
    result.fold(
          (failure) {
        final error = ServiceErrorState(failure.message, failure.statusCode);
        emit(state.copyWith(serviceState: error));
      },
          (success) {
        if (state.totalService == 1) {
          serviceItems = success;
          final loaded = ServiceList(serviceItems);
          emit(state.copyWith(serviceState: loaded));
        } else {
          serviceItems.addAll(success);
          final loaded = ServiceListMore(serviceItems);
          emit(state.copyWith(serviceState: loaded));
        }
        state.totalService++;
        if (success.isEmpty && state.totalService != 1) {
          emit(state.copyWith(isListEmpty: true));
        }
      },
    );
  }

/*  Future<void> filterService() async {
    final ids = state.categories.map((e)=>e.id).toList();
    debugPrint('filter-service-data $ids');
    debugPrint('${state.toMap()} filter-service-data ');
    debugPrint('langcode ${_loginBloc.state.langCode}');
    final uri = Uri.parse(RemoteUrls.serviceList)
        .replace(queryParameters: {'lang_code':_loginBloc.state.langCode,...state.toMap()});
    debugPrint('filter-uri $uri');
   emit(state.copyWith(serviceState: ServiceLoadingState()));
    final uri = Uri.parse(RemoteUrls.serviceList)
        .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString()});
    debugPrint('service-url $uri');
    final result = await _repository.getAllServices(uri);
    result.fold(
          (failure) {
        final error = ServiceErrorState(failure.message, failure.statusCode);
        emit(state.copyWith(serviceState: error));
      },
          (success) {
        if (state.totalService == 1) {
          serviceItems = success;
          final loaded = ServiceList(serviceItems);
          emit(state.copyWith(serviceState: loaded));
        } else {
          serviceItems.addAll(success);
          final loaded = ServiceListMore(serviceItems);
          emit(state.copyWith(serviceState: loaded));
        }
        state.totalService++;
        if (success.isEmpty && state.totalService != 1) {
          emit(state.copyWith(isListEmpty: true));
        }
      },
    );

  }*/

  Future<void> getAllSeller([bool isFilter = false]) async {
    emit(state.copyWith(serviceState: ServiceLoadingState()));
    Uri uri;

    if(isFilter == true){
      uri = Uri.parse(RemoteUrls.sellerList)
          .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString(),...state.toMap()});
    }else{
      uri = Uri.parse(RemoteUrls.sellerList)
          .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString()});
    }

    //debugPrint('seller-list-url $uri');
    final result = await _repository.getAllSellers(uri);
    result.fold(
          (failure) {
        final error = ServiceErrorState(failure.message, failure.statusCode);
        emit(state.copyWith(serviceState: error));
      },
          (success) {
        if (state.totalService == 1) {
          sellerItems = success;
          final loaded = SellerList(sellerItems);
          emit(state.copyWith(serviceState: loaded));
        } else {
          sellerItems.addAll(success);
          final loaded = SellerListMore(sellerItems);
          emit(state.copyWith(serviceState: loaded));
        }
        state.totalService++;
        if (success.isEmpty && state.totalService != 1) {
          emit(state.copyWith(isListEmpty: true));
        }
      },
    );
  }

  Future<void> getAllJob([bool isFilter = false]) async {
    emit(state.copyWith(serviceState: ServiceLoadingState()));
    Uri uri;

    if(isFilter == true){
     uri = Uri.parse(RemoteUrls.jobList)
          .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString(),...state.toJobMap()});
    }else{
     uri = Uri.parse(RemoteUrls.jobList)
          .replace(queryParameters: {'lang_code': _loginBloc.state.langCode,'page': state.totalService.toString()});
    }


    //debugPrint('job-list-url $uri');
    final result = await _repository.getAllJobs(uri);
    result.fold(
          (failure) {
        final error = ServiceErrorState(failure.message, failure.statusCode);
        emit(state.copyWith(serviceState: error));
      },
          (success) {
        if (state.totalService == 1) {
          jobItems = success;
          final loaded = JobPostList(jobItems);
          emit(state.copyWith(serviceState: loaded));
        } else {
          jobItems.addAll(success);
          final loaded = JobPostListMore(jobItems);
          emit(state.copyWith(serviceState: loaded));
        }
        state.totalService++;
        if (success.isEmpty && state.totalService != 1) {
          emit(state.copyWith(isListEmpty: true));
        }
      },
    );
  }

  Future<void> getFilterData(String type) async {
    // emit(state.copyWith(serviceState: ServiceLoadingState()));
    final uri = Uri.parse(RemoteUrls.filterData(type)).replace(queryParameters: {'lang_code': _loginBloc.state.langCode});
    debugPrint('called-filter $uri');
    final result = await _repository.getFilterData(uri);
    result.fold((failure) {
        final error = ServiceFilterError(failure.message, failure.statusCode);
        emit(state.copyWith(serviceState: error));
      },
        (success) {
        filter = success;
        final loaded = ServiceFilterLoaded(success);
        emit(state.copyWith(serviceState: loaded));
      },
    );
  }


  void initPage() {
    emit(state.copyWith(totalService: 1, isListEmpty: false));
  }

  void initState() {
    emit(state.copyWith(serviceState: const ServiceListInitial()));
  }

  void searchService(String name) {

    final lowerCaseName = name.toLowerCase();
    filterServices = serviceItems.where((customer) {
      final customerName = customer.title.toLowerCase();
      return customerName.contains(lowerCaseName);
    }).toList();

    //debugPrint('filterCustomers ${filterCustomers.length}');
    if (state.totalService == 1) {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(name: name,serviceState: ServiceList(filterServices)));
    } else {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(name: name,serviceState: ServiceListMore(filterServices)));
    }
  }

  void searchSeller(String name) {
    // debugPrint('search-name');
    final lowerCaseName = name.toLowerCase();
    filterSeller = sellerItems.where((customer) {
      final customerName = customer.name.toLowerCase();
      return customerName.contains(lowerCaseName);
    }).toList();

    //debugPrint('filterCustomers ${filterCustomers.length}');
    if (state.totalService == 1) {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(serviceState: SellerList(filterSeller)));
    } else {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(serviceState: SellerListMore(filterSeller)));
    }
  }

  void searchJob(String name) {
    // debugPrint('search-name');
    final lowerCaseName = name.toLowerCase();
    filterJob = jobItems.where((customer) {
      final customerName = customer.title.toLowerCase();
      return customerName.contains(lowerCaseName);
    }).toList();

    // filterJob = jobItems.where((customer) {
    //   final customerName = customer.jobType.toLowerCase();
    //   return customerName.contains(lowerCaseName);
    // }).toList();

    //debugPrint('filterCustomers ${filterCustomers.length}');
    if (state.totalService == 1) {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(serviceState: JobPostList(filterJob)));
    } else {
      // debugPrint('search-name-from ${state.totalService}');
      emit(state.copyWith(serviceState: JobPostListMore(filterJob)));
    }
  }
}
