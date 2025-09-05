import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/payment/payment_model.dart';
import '../../../data/models/subscription/sub_detail_model.dart';
import '../../../data/models/subscription/subscription_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/withdraw_repository.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubDetailModel> {

  final WithdrawRepository _repository;
  final LoginBloc _loginBloc;

  SubscriptionCubit(
      {required WithdrawRepository repository,
        required LoginBloc loginBloc})
      : _repository = repository,
        _loginBloc = loginBloc,
        super(SubDetailModel.init());

  bool isNavigating = false;

  List<SubscriptionModel> ? plans = [];


  List<SubDetailModel?> ? histories = [];

  PaymentModel ? paymentInfo;

  void addPlanId(int id)=>emit(state.copyWith(id: id));
  void changeSubIndex(int id)=>emit(state.copyWith(userId: id));
  void addSelectedSub(SubscriptionModel? sub)=>emit(state.copyWith(subModel: sub));


  void cardNumber(String text)=> emit(state.copyWith(paymentMethod: text,subState: SubscriptionInitial()));
  void month(String text)=> emit(state.copyWith(transaction: text,subState: SubscriptionInitial()));
  void cvc(String text)=> emit(state.copyWith(updatedAt: text,subState: SubscriptionInitial()));
  void tnxInfo(String text)=> emit(state.copyWith(paymentStatus: text,subState: SubscriptionInitial()));
  void addYear(String text)=> emit(state.copyWith(status: text,subState: SubscriptionInitial()));


  void addPlanName(String text)=> emit(state.copyWith(planName: text));


  Future<void> getSubscriptionList() async {
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
       emit(state.copyWith(subState: SubscriptionListStateLoading()));
       final uri = Utils.tokenWithCode(RemoteUrls.subsRoute(SubsType.show,0), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,);
       final result = await _repository.subscriptionPlanList(uri);
       result.fold((failure) {
         final errorState = SubscriptionStateError(failure.message, failure.statusCode);
         emit(state.copyWith(subState: errorState));
       }, (success) {
         plans = success;
         final successState = SubscriptionStateLoaded(success);
         emit(state.copyWith(subState: successState));
       });
   }
  }

  Uri paymentUrl(SubsType type){
    return Utils.tokenWithCode(RemoteUrls.subsRoute(type, state.subModel?.id??0), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);
  }

  Future<void> getPaymentInfo() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      emit(state.copyWith(subState: PaymentInfoStateLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.subsRoute(SubsType.payInfo,state.subModel?.id??0), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,);
      debugPrint('payment0info $uri');
      final result = await _repository.paymentInfo(uri);
      result.fold((failure) {
        final errorState =
        PaymentInfoStateError(failure.message, failure.statusCode);
        emit(state.copyWith(subState: errorState));
      }, (success) {
        paymentInfo = success;
        final successState = PaymentInfoStateLoaded(success);
        emit(state.copyWith(subState: successState));
      });
    }
  }


  Future<void> getPurchaseHistories() async {
    emit(state.copyWith(subState: PurchaseLoadingState()));

    final uri = Utils.tokenWithCode(RemoteUrls.subsRoute(SubsType.history, 0), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode,extraParams: {'page': state.currentPage.toString()});

    //debugPrint('history-list-url $uri');
    final result = await _repository.getPurchaseHistories(uri);
    result.fold(
          (failure) {
        final error = PurchaseErrorState(failure.message, failure.statusCode);
        emit(state.copyWith(subState: error));
      },
          (success) {
        if (state.currentPage == 1) {
          histories = success;
          final loaded = SubscriptionList(histories);
          emit(state.copyWith(subState: loaded));
        } else {
          histories?.addAll(success??[]);
          final loaded = SubscriptionListMore(histories);
          emit(state.copyWith(subState: loaded));
        }
        state.currentPage++;
        if ((success?.isEmpty??false) && state.currentPage != 1) {
          emit(state.copyWith(isEmpty: true));
        }
      },
    );
  }

  Future<void> localSubsPayment(SubsType type) async {

    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      Uri uri;

      if(type == SubsType.freePlan){
      uri = Utils.tokenWithCode(RemoteUrls.subsRoute(type,state.subModel?.id??0), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode,extraParams: {'_method':'GET'});
      }else{
      uri = Utils.tokenWithCode(RemoteUrls.subsRoute(type,state.subModel?.id??0), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);
      }
      debugPrint('payment-body ${state.toMap()}');
      emit(state.copyWith(subState: const StripePaymentLoading()));
      final result = await _repository.localWalletPay(uri,state.toMap());
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = StripePaymentFormError(failure.errors);
          emit(state.copyWith(subState: errors));
        } else {
          final errors = StripePaymentError(failure.message, failure.statusCode);
          emit(state.copyWith(subState: errors));
        }
      }, (success) {
        emit(state.copyWith(subState: StripePaymentLoaded(success)));
      });
    }
  }


  void initPage() {
    emit(state.copyWith(currentPage: 1, isEmpty: false));
  }

  void initState() {
    emit(state.copyWith(subState: const SubscriptionInitial()));
  }

  void clearField(){
    emit(SubDetailModel.init());
  }

  void clearPayInfo(){
    emit(state.copyWith(paymentMethod: '', transaction: '', updatedAt: '', paymentStatus: '', status: '',));
  }

}
