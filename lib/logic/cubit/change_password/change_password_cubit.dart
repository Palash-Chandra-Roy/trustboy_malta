import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../data/data_provider/remote_url.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/profile_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStateModel> {
  ChangePasswordCubit({
    required ProfileRepository profileRepository,
    required LoginBloc loginBloc,
  })  : _profileRepository = profileRepository,
        _loginBloc = loginBloc,
        super(const ChangePasswordStateModel());

  final ProfileRepository _profileRepository;
  final LoginBloc _loginBloc;

  void changeNewPassword(String value) {
    emit(state.copyWith(
      newPassword: value,
      status: const ChangePasswordStateInitial(),
    ));
  }

  void changeConfirmChange(String value) {
    emit(state.copyWith(
      confirmationPassword: value,
      status: const ChangePasswordStateInitial(),
    ));
  }

  void changeCurrentPassword(String value) {
    emit(state.copyWith(
      currentPassword: value,
      status: const ChangePasswordStateInitial(),
    ));
  }

  void showNewPassword() {
    emit(state.copyWith(isShowNewPassword: !state.isShowNewPassword, status: const ChangePasswordStateInitial(),));
  }

  void showConfirmPassword() {
    emit(state.copyWith(isShowConfirmPassword: !state.isShowConfirmPassword, status: const ChangePasswordStateInitial(),));
  }

  void showCurrentPassword() {
    emit(state.copyWith(isShowCurrentPassword: !state.isShowCurrentPassword, status: const ChangePasswordStateInitial(),));
  }

  Future<void> changePasswordForm() async {
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
     final uri = Utils.tokenWithCode(RemoteUrls.updatePassword(_loginBloc.userInformation?.user?.isSeller == 1),
         _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'_method':'PUT'});
     debugPrint('update-pass $uri');

      emit(state.copyWith(status: const ChangePasswordStateLoading()));

     final result = await _profileRepository.passwordChange(uri,state);

     result.fold(
           (failure) {
         if (failure is InvalidAuthData) {
           final errors = ChangePasswordStateFormError(failure.errors);
           emit(state.copyWith(status: errors));
         } else {
           final currentState = ChangePasswordStateError(failure.message, failure.statusCode);
           emit(state.copyWith(status: currentState));
         }
       },
           (success) {
         final currentState = ChangePasswordStateLoaded(success);
         emit(state.copyWith(status: currentState));
       },
     );
   }
  }

  Future<void> clearFormData() async {
    emit(state.clear());
  }
}
