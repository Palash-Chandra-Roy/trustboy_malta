import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/payment/payment_model.dart';
import '../../../data/models/setting/currencies_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/payment_repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<CurrenciesModel> {
  final PaymentRepository _repository;
  final LoginBloc _loginBloc;

  PaymentCubit(
      {required PaymentRepository repository,
      required LoginBloc loginBloc})
      : _repository = repository,
        _loginBloc = loginBloc,
        super(CurrenciesModel.init());

  PaymentModel? payment;

  String getPackage(){
    switch(state.id){
      case 0:
        return 'Basic';
      case 1:
        return 'Standard';
      case 2:
        return 'Premium';
      default:
        return '';
    }
  }

  bool isNavigating = false;


  void currentIndex(int index)=> emit(state.copyWith(id: index));
  void serviceId(int index)=> emit(state.copyWith(status: index.toString()));

  void cardNumber(String text)=> emit(state.copyWith(isDefault: text));
  void month(String text)=> emit(state.copyWith(currencyPosition: text));
  void year(String text)=> emit(state.copyWith(createdAt: text));
  void cvc(String text)=> emit(state.copyWith(updatedAt: text));

  Uri paymentUrl(WebPayType type){
    return Utils.tokenWithCode(RemoteUrls.webViewPayment(type, state.status, getPackage()), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);
  }


  Future<void> getPaymentInfo() async {
    if (_loginBloc.userInformation?.accessToken.isNotEmpty??false) {
      final uri = Utils.tokenWithCode(
          RemoteUrls.paymentInfo(state.status,getPackage()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);

      //debugPrint('payment-info $uri');

      emit(state.copyWith(paymentState: PaymentStatePageInfoLoading()));
      final result = await _repository.getPaymentInfo(uri);
      result.fold((failure) {
        final errors = PaymentStatePageInfoError(failure.message, failure.statusCode);
        emit(state.copyWith(paymentState: errors));
      }, (success) {
        payment = success;
        final loaded = PaymentStatePageInfoLoaded(success);
        emit(state.copyWith(paymentState: loaded));
      });
    }
  }

  Future<void> stripePayment() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.localPayment(PaymentType.stripe,state.status,getPackage()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);

      emit(state.copyWith(paymentState: const StripePaymentLoading()));
      final result = await _repository.stripePayment(uri,state);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = StripePaymentFormError(failure.errors);
          emit(state.copyWith(paymentState: errors));
        } else {
          final errors = StripePaymentError(failure.message, failure.statusCode);
          emit(state.copyWith(paymentState: errors));
        }
      }, (success) {
        emit(state.copyWith(paymentState: StripePaymentLoaded(success)));
        // emit(state.clear());
      });
    }
  }

  Future<void> bankWalletPayment([bool isBank = true]) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      Uri uri;
      if(isBank){
        uri = Utils.tokenWithCode(
            RemoteUrls.localPayment(PaymentType.bank,state.status,getPackage()),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }else{
        uri = Utils.tokenWithCode(
            RemoteUrls.localPayment(PaymentType.wallet,state.status,getPackage()),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }
      //debugPrint('wallet-payment $uri');

      emit(state.copyWith(paymentState: const BankLoading()));

      final result = await _repository.stripePayment(uri, state);

      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = StripePaymentFormError(failure.errors);
          emit(state.copyWith(paymentState: errors));
        } else {
          final errors = BankError(failure.message, failure.statusCode);
          emit(state.copyWith(paymentState: errors));
        }
      }, (data) {
        final errors = BankLoadedState(data);
        emit(state.copyWith(paymentState: errors));
      });
    }
  }


  void clear(){
    emit(state.copyWith(
      currencyPosition : '',
      isDefault : '',
      createdAt : '',
      updatedAt : '',
      paymentState :  const PaymentInitial(),
    ));
  }

 /* Future<void> freeEnrollment(String planSlug) async {
    if (_loginBloc.userInformation != null &&
        _loginBloc.userInformation!.accessToken.isNotEmpty) {
      emit(PaymentStateEnrollLoading());
      final result = await _repository.freeEnrollment(
          _loginBloc.userInformation!.accessToken, planSlug);
      result.fold((failure) {
        emit(PaymentStateEnrollError(failure.message, failure.statusCode));
      }, (success) {
        emit(PaymentStateEnrollLoaded(success));
      });
    }
  }*/
}
