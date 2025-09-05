import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/dummy_data/dummy_data.dart';
import '../../../data/models/wallet/wallet_model.dart';
import '../../../data/models/wallet/wallet_transaction_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/withdraw_repository.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletTransaction> {

  final WithdrawRepository _repository;
  final LoginBloc _loginBloc;

  WalletCubit(
      {required WithdrawRepository repository,
        required LoginBloc loginBloc})
      : _repository = repository,
        _loginBloc = loginBloc,
        super(WalletTransaction.init());


  // List<MethodModel> methods = [];
  WalletModel ? wallet;
  List<DummyPackage> ? methods = [];

  bool isValidInfo()=> [state.createdAt,state.paymentGateway].every((e)=>e.trim().isNotEmpty);

  void cardNumber(String text)=> emit(state.copyWith(paymentType: text,walletState: WalletInitial()));
  void month(String text)=> emit(state.copyWith(description: text,walletState: WalletInitial()));
  void cvc(String text)=> emit(state.copyWith(updatedAt: text,walletState: WalletInitial()));
  void tnxInfo(String text)=> emit(state.copyWith(paymentStatus: text,walletState: WalletInitial()));
  void addYear(String text)=> emit(state.copyWith(status: text,walletState: WalletInitial()));


  void addAmount(String price)=>emit(state.copyWith(createdAt: price));
  void addGateway(String price)=>emit(state.copyWith(paymentGateway: price));

  Future<void> getBuyerWallet() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      emit(state.copyWith(walletState: WalletLoading()));
      final uri = Utils.tokenWithCode(RemoteUrls.walletRoute(WalletType.show,0), _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);
      //debugPrint('wallet-uri $uri');
      final result = await _repository.getBuyerWallet(uri);
      result.fold(
            (failure) {
          final errors = WalletError(message: failure.message, status: failure.statusCode);
          emit(state.copyWith(walletState: errors));
        },
          (data) {
            wallet = data;
          final loaded = WalletLoaded(wallets: data);
          emit(state.copyWith(walletState: loaded));
        },
      );
      addPaymentMethod();
    }
  }

  Future<void> localWalletPayment(WalletPaymentType type) async {

    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      final uri = Utils.tokenWithCode(RemoteUrls.walletPayment(type), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);

      emit(state.copyWith(walletState: const StripePaymentLoading()));
      final result = await _repository.localWalletPay(uri,state.toMap());
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = StripePaymentFormError(failure.errors);
          emit(state.copyWith(walletState: errors));
        } else {
          final errors = StripePaymentError(failure.message, failure.statusCode);
          emit(state.copyWith(walletState: errors));
        }
      }, (success) {
        emit(state.copyWith(walletState: StripePaymentLoaded(success)));
      });
    }
  }

  Uri getWebUri(WalletPaymentType type){
    return Utils.tokenWithCode(RemoteUrls.walletPayment(type), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode,extraParams: {'amount':state.createdAt});
  }


  void clearField(){
    emit(WalletTransaction.init());
  }

  void clearPayInfo(){
    emit(state.copyWith(paymentType: '', description: '', updatedAt: '', paymentStatus: '', status: '',));
  }


  void addPaymentMethod() {
    methods?.clear();

    final payMethod = wallet?.setting;
    if (payMethod == null) return;

    final availableMethods = [
      {'status': payMethod.stripeStatus, 'id': 1, 'value': 'stripe', 'title': 'Stripe'},
      {'status': payMethod.bankStatus, 'id': 2, 'value': 'bank', 'title': 'Bank'},
      {'status': payMethod.paypalStatus, 'id': 3, 'value': 'paypal', 'title': 'Paypal'},
      {'status': payMethod.razorpayStatus, 'id': 4, 'value': 'razorpay', 'title': 'Razorpay'},
      {'status': payMethod.mollieStatus, 'id': 5, 'value': 'mollie', 'title': 'Mollie'},
      {'status': payMethod.flutterwaveStatus, 'id': 6, 'value': 'flutterwave', 'title': 'Flutterwave'},
      {'status': payMethod.instamojoStatus, 'id': 7, 'value': 'instamojo', 'title': 'Instamojo'},
      {'status': payMethod.paystackStatus, 'id': 8, 'value': 'paystack', 'title': 'Paystack'},
    ];

    for (var method in availableMethods) {
      if (method['status'] == 1) {
        methods?.add(DummyPackage(
          id: method['id'] as int,
          value: method['value'] as String,
          title: method['title'] as String,
        ));
      }
    }
    // final name = methods?.map((e)=>e.title).toList();
    // debugPrint('methods $name');
  }

}
