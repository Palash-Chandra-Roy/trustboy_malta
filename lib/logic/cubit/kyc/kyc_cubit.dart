import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/kyc/kyc_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/auth_repository.dart';

part 'kyc_state.dart';

class KycCubit extends Cubit<KycItem> {
  final LoginBloc _loginBloc;
  final AuthRepository _repository;

  KycCubit({
    required LoginBloc loginBloc,
    required AuthRepository repository,
  })  : _loginBloc = loginBloc,
        _repository = repository,
        super(KycItem.init());

  KycModel? kycModel;

  void kycType(int id) {
    //debugPrint('kycId $id');
    emit(state.copyWith(kycId: id, kycState: const KycInitial()));
  }

  void kycMessage(String text) {
    emit(state.copyWith(message: text, kycState: const KycInitial()));
  }

  void kycFile(String text) {
    emit(state.copyWith(file: text, kycState: const KycInitial()));
  }

  void kycFileClear() {
    emit(state.copyWith(file: '', kycState: const KycInitial()));
  }

  void clear() {
    emit(KycItem.init());
  }

  Future<void> getKycInfo() async {
    if (_loginBloc.userInformation?.accessToken.isNotEmpty??false) {
       final uri = Utils.tokenWithCode(RemoteUrls.getKycInfo, _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);

      emit(state.copyWith(kycState: KycInfoLoading()));
      final result =
          await _repository.getKycInfo(uri);
      result.fold((failure) {
        final errors = KycInfoError(failure.message, failure.statusCode);
        emit(state.copyWith(kycState: errors));
      }, (success) {
        kycModel = success;
        emit(state.copyWith(kycState: KycInfoLoaded(success)));
      });
    }
  }

  Future<void> submitKyc() async {
    //debugPrint('kyc-body ${state.toMap()}');
    if (_loginBloc.userInformation?.accessToken.isNotEmpty??false) {
       final uri = Utils.tokenWithCode(RemoteUrls.submitKyc, _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);

      emit(state.copyWith(kycState: KycSubmitLoading()));
      final result = await _repository.submitKyc(uri, state);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = KycSubmitFormError(failure.errors);
          emit(state.copyWith(kycState: errors));
        } else {
          final errors = KycSubmitError(failure.message, failure.statusCode);
          emit(state.copyWith(kycState: errors));
        }
      }, (success) {
        emit(state.copyWith(kycState: KycSubmitLoaded(success)));
      });
    }
  }
}
