import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/setting/splash_model.dart';
import '../../../data/models/setting/website_setup_model.dart';
import '../../repository/setting_repository.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final SettingRepository _repository;
  WebsiteSetupModel? settingModel;

  SettingCubit({required SettingRepository repository})
      : _repository = repository,
        super(const SettingInitial()) ;

  List<SplashModel> ? splashes = [];

  bool get showOnBoarding =>
      _repository.checkOnBoarding().fold((l) => false, (r) => true);

  Future<void> cacheOnBoarding() async {
    final result = await _repository.cachedOnBoarding();
    result.fold((l) => false, (r) => r);
  }

  Future<void> getSetting(String langCode) async {
    final uri = Uri.parse(RemoteUrls.websiteSetup).replace(queryParameters: {'lang_code':langCode});
    //debugPrint('setting-url $uri');
    emit(const SettingStateLoading());
    final result = await _repository.getSetting(uri);
    result.fold((failure) {
      emit(SettingStateError(failure.message, failure.statusCode));
    }, (success) {
      settingModel = success;
      emit(SettingStateLoaded(success));
    });
    addSplashContent();
  }

  void addSplashContent(){
    if(settingModel?.splash != null){

      //debugPrint('splash not-null ${settingModel?.splash}');

      SplashModel? item = settingModel?.splash;

      splashes?.clear();

     final splashOne = SplashModel(splashScreen1: item?.splashScreen1,splashScreen1Title: item?.splashScreen1Title);
     final splashTwo = SplashModel(splashScreen1: item?.splashScreen2,splashScreen1Title: item?.splashScreen2Title);
     final splashThree = SplashModel(splashScreen1: item?.splashScreen3,splashScreen1Title: item?.splashScreen3Title);

     splashes?.addAll([splashOne,splashTwo,splashThree]);
    }
  }
}
