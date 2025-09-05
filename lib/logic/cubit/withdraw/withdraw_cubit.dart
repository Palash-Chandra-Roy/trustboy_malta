import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/withdraw/account_info_model.dart';
import '../../../../data/models/withdraw/method_model.dart';
import '../../../../presentation/errors/errors_model.dart';
import '../../../../presentation/errors/failure.dart';
import '../../../../presentation/utils/utils.dart';
import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/dashboard/dashboard_model.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/withdraw_repository.dart';
import 'withdraw_state_model.dart';

part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawStateModel> {
  final WithdrawRepository _repository;
  final LoginBloc _loginBloc;

  WithdrawCubit(
      {required WithdrawRepository repository,
      required LoginBloc loginBloc})
      : _repository = repository,
        _loginBloc = loginBloc,
        super(const WithdrawStateModel());


  List<MethodModel> methods = [];
  DashboardModel ? withdraws;

  void addMethod(MethodModel? method){
    if(state.methods != null){
      emit(state.copyWith(methods: null));
    }
    // List<MethodModel>? update = List.of(state.methods??[]);
    // if(!(state.methods?.contains(method)??false)){
    //   update.add(method??MethodModel.init());
    // }
    emit(state.copyWith(methods: method));
  }

  void changeMethodId(String id) {
    emit(state.copyWith(
      methodId: id,
      withdrawState: const WithdrawInitial(),
    ));
  }

  void changeAmount(String amount) {
    emit(state.copyWith(
      withdrawAmount: amount,
      withdrawState: const WithdrawInitial(),
    ));
  }

  void changeBankInfo(String accountInfo) {
    emit(state.copyWith(
      accountInfo: accountInfo,
      withdrawState: const WithdrawInitial(),
    ));
  }

  Future<void> getAllMethodList() async {
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
     emit(state.copyWith(withdrawState: MethodLoading()));
     final uri = Utils.tokenWithCode(RemoteUrls.sellerMethod, _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);
  
     final account = await _repository.getAllMethodList(uri);
  
     account.fold((failure) {
       final errors = MethodError(failure.message, failure.statusCode);
       emit(state.copyWith(withdrawState: errors));
     }, (methodList) {
       methods = methodList;
       final loaded = MethodLoaded(methodList);
       emit(state.copyWith(withdrawState: loaded));
     });
   }
  }

  Future<void> getAccountInformation(String id) async {
    // emit(state.copyWith(withdrawState: SingleAccountInfoLoading()));
    // final uri = Utils.tokenWithCode(RemoteUrls.getAccountInformation(id),
    //     _loginBloc.userInformation!.accessToken, _loginBloc.state.languageCode);
    // print('account-uri $uri');
    // final account = await _withdrawRepository.getAccountInformation(uri);
    // account.fold((failure) {
    //   final errors = SingleAccountInfoError(failure.message, failure.statusCode);
    //   emit(state.copyWith(withdrawState: errors));
    //
    // }, (accountInfo) {
    //   final loaded = SingleAccountInfoLoaded(accountInfo);
    //   emit(state.copyWith(withdrawState: loaded));
    // });
  }

  Future<void> getAllWithdrawList() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit(state.copyWith(withdrawState: AccountInfoLoading()));

      final uri = Utils.tokenWithCode(RemoteUrls.sellerWithdraw, _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);

      final account = await _repository.getAllWithdrawList(uri);

      account.fold((failure) {
        final errors = AccountInfoError(failure.message, failure.statusCode);
        emit(state.copyWith(withdrawState: errors));

      }, (methodList) {
        withdraws = methodList;
        final loaded = AllWithdrawListLoaded(methodList);
        emit(state.copyWith(withdrawState: loaded));
      });
    }
  }

  Future<void> createWithdrawMethod() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit(state.copyWith(withdrawState: const CreateWithdrawLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.sellerWithdraw,
          _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);
    
      final result =
      await _repository.createNewWithdrawRequest(state, uri);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = CreateWithdrawFormError(failure.errors);
          emit(state.copyWith(withdrawState: errors));
        } else {
          final errors = CreateWithdrawError(failure.message, failure.statusCode);
          emit(state.copyWith(withdrawState: errors));
    
        }
      }, (success) {
        final loaded = CreateWithdrawLoaded(success);
        emit(state.copyWith(withdrawState: loaded));
      });
    }
  }

  FutureOr<void> removeData() {
    emit(state.clear());
  }
}
