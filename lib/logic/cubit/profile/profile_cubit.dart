import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/bloc/login/login_bloc.dart';
import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../repository/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<SellerModel> {
  final ProfileRepository _repository;
  final LoginBloc _loginBloc;

  ProfileCubit({
    required ProfileRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(SellerModel.init());

  SellerModel? profile;
  List<String> tempTags = [];
  List<String> tempLang = [];

  void isSellerPade(bool text) {
    // debugPrint('name $text');
    emit(state.copyWith(isSellerPage: text));
  }

  void nameChange(String text) {
    // debugPrint('name $text');
    emit(state.copyWith(name: text, profileState: const ProfileInitial()));
  }

  void emailChange(String text) {
    // debugPrint('email $text');
    emit(state.copyWith(email: text, profileState: const ProfileInitial()));
  }

  void phoneChange(String text) {
    // debugPrint('phone $text');
    emit(state.copyWith(phone: text, profileState: const ProfileInitial()));
  }

  void addressChange(String text) {
    // debugPrint('address $text');
    emit(state.copyWith(address: text, profileState: const ProfileInitial()));
  }

  void imageChange(String text) {
    emit(state.copyWith(image: text, profileState: const ProfileInitial()));
  }

  void genderChange(String text) {
    emit(state.copyWith(gender: text, profileState: const ProfileInitial()));
  }

  void languageChange(String text) {
    emit(state.copyWith(language: text, profileState: const ProfileInitial()));
  }

  void aboutMeChange(String text) {
    emit(state.copyWith(aboutMe: text, profileState: const ProfileInitial()));
  }

  void designationChange(String text) {
    emit(state.copyWith(designation: text, profileState: const ProfileInitial()));
  }

  ///for seller function

  void hourlyRateChange(String text) {
    emit(state.copyWith(verificationOtp: text, profileState: const ProfileInitial()));
  }
  void varsityName(String text) {
    emit(state.copyWith(universityName: text, profileState: const ProfileInitial()));
  }
  void varsityLocation(String text) {
    emit(state.copyWith(universityLocation: text, profileState: const ProfileInitial()));
  }
  void varsityTimePeriod(String text) {
    emit(state.copyWith(universityTimePeriod: text, profileState: const ProfileInitial()));
  }

  void schoolName(String text) {
    emit(state.copyWith(schoolName: text, profileState: const ProfileInitial()));
  }
  void schoolLocation(String text) {
    emit(state.copyWith(schoolLocation: text, profileState: const ProfileInitial()));
  }
  void schoolTimePeriod(String text) {
    emit(state.copyWith(schoolTimePeriod: text, profileState: const ProfileInitial()));
  }

  ///skill start
  void addSkill(String passenger) {
    //debugPrint('added-new skill');
    final updateFeature = List.of(state.skillList)..add(passenger);
    emit(state.copyWith(skillList: updateFeature, profileState: const ProfileInitial()));
  }

  void updateSkill(int index, String passenger) {

    final updateFeature = List.of(state.skillList)..[index] = passenger;
    emit(state.copyWith(skillList: updateFeature, profileState: const ProfileInitial()));
  }

  void removeSkill(int index) {
    //debugPrint('removed-skill from $index');
    final updateFeature = List.of(state.skillList)..removeAt(index);
    emit(state.copyWith(skillList: updateFeature, profileState: const ProfileInitial()));
  }
  ///skill start


///languages start
  void addLanguage(String passenger) {
    final updateFeature = List.of(state.languageList)..add(passenger);
    emit(state.copyWith(languageList: updateFeature, profileState: const ProfileInitial()));
  }

  void updateLanguage(int index, String passenger) {
    final updateFeature = List.of(state.languageList)..[index] = passenger;
    emit(state.copyWith(languageList: updateFeature, profileState: const ProfileInitial()));
  }

  void removeLanguage(int index) {
    //debugPrint('removed-language from $index');
    final updateFeature = List.of(state.languageList)..removeAt(index);
    emit(state.copyWith(languageList: updateFeature, profileState: const ProfileInitial()));
  }

  ///languages end

  Future<void> getProfileData() async {
    //debugPrint('user-info-calling');
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit(state.copyWith(profileState: GetProfileLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.profileInfo(_loginBloc.userInformation?.user?.isSeller == 1),
          _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);

      final result = await _repository.getProfileData(uri);
      result.fold((failure) {
        final errorState =
        GetProfileStateError(failure.message, failure.statusCode);
        emit(state.copyWith(profileState: errorState));
      }, (success) {
        profile = success;
        if (profile != null) {
          emit(state.copyWith(
            name: profile?.name,
            email: profile?.email,
            phone: profile?.phone,
            address: profile?.address,
            designation: profile?.designation,
            gender: profile?.gender.toLowerCase(),
            language: Utils.decodeHtmlEntities(profile?.language??''),
            aboutMe: Utils.decodeHtmlEntities(profile?.aboutMe??''),

            universityName: profile?.universityName,
            universityLocation: profile?.universityLocation,
            universityTimePeriod: profile?.universityTimePeriod,
            schoolName: profile?.schoolName,
            schoolLocation: profile?.schoolLocation,
            schoolTimePeriod: profile?.schoolTimePeriod,
            verificationOtp: profile?.hourlyPayment.toStringAsFixed(2),

            createdAt: profile?.image,

          ));
        }

        if (tempTags.isNotEmpty) {
          tempTags.clear();
        }

        if ((profile?.skills.isNotEmpty??false) && profile?.skills != 'null') {
          final exTags = Utils.parseJsonToString(profile?.skills);
          for (int i = 0; i < exTags.length; i++) {
            final t = exTags[i];
            tempTags.add(t);
          }
          emit(state.copyWith(skillList: tempTags));
        }

        if (tempLang.isNotEmpty) {
          tempLang.clear();
        }

        if ((profile?.language.isNotEmpty??false) && profile?.language != 'null') {
          final exTags = Utils.parseJsonToString(profile?.language);
          for (int i = 0; i < exTags.length; i++) {
            final t = exTags[i];
            tempLang.add(t);
          }
          emit(state.copyWith(languageList: tempLang));
        }
        final skill = state.skillList.map((e)=>e).toList();
        final language = state.languageList.map((e)=>e).toList();
        // debugPrint('state-skills $skill');
        // debugPrint('state-language $language');

        final successState = GetProfileLoaded(success);
        emit(state.copyWith(profileState: successState));
      });
    }else{
      profile = null;
    }
  }

  Future<void> updateUserInfo() async {
    //log('profile-data ${state.toMap()}');
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
        //debugPrint('update-state ${state.toMap()}');

        final uri = Utils.tokenWithCode(RemoteUrls.updateProfile(_loginBloc.userInformation?.user?.isSeller == 1),
            _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'PUT'});
        emit(state.copyWith(profileState: const ProfileStateUpdating()));
        final result = await _repository.updateUserInfo(uri,state);

        result.fold((failure) {
          if (failure is InvalidAuthData) {
            final errors = ProfileStateFormValidate(failure.errors);
            emit(state.copyWith(profileState: errors));
          } else {
            final errors = ProfileStateUpdateError(failure.message, failure.statusCode);
            emit(state.copyWith(profileState: errors));
          }
        }, (success) {
          final loaded = ProfileStateUpdated(success);
          emit(state.copyWith(profileState: loaded));
        });
    }
  }

  Future<void> updateProfileAvatar([bool isOnline = false]) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      emit(state.copyWith(profileState: const ProfileProfileImageStateUpdating()));

     Uri uri;

     if(isOnline == true){
       uri = Utils.tokenWithCode(RemoteUrls.onlineStatus,
           _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);
     }else{
       uri = Utils.tokenWithCode(RemoteUrls.updateProfileAvatar(_loginBloc.userInformation?.user?.isSeller == 1),
           _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'PUT'});
     }

      // debugPrint('profile-avatar $uri');
      final result = await _repository.updateProfileAvatar(uri, state);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = ProfileStateFormValidate(failure.errors);
          emit(state.copyWith(profileState: errors));
        } else {
          final errors =
          ProfileStateUpdateError(failure.message, failure.statusCode);
          emit(state.copyWith(profileState: errors));
        }
      }, (success) {
        ProfileState status;
        if(isOnline == true){
          status =  ProfileOnlineStatusUpdated(success);
        }else{
          status =  ProfileStateUpdated(success);
        }
        emit(state.copyWith(profileState: status));
      });
    }
  }


  void resetState(){
    // debugPrint('current-state ${state.profileState}');
    emit(state.copyWith(profileState: const ProfileInitial()));
  }
}
