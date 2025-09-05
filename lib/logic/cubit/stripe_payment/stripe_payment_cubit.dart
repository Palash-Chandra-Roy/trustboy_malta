import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/errors/errors_model.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/payment_repository.dart';
import 'stripe_payment_state_model.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentStateModel> {
  final LoginBloc _loginBloc;
  final PaymentRepository _paymentRepository;

  StripePaymentCubit(
      {required LoginBloc loginBloc,
      required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        _loginBloc = loginBloc,
        super(const StripePaymentStateModel());

  void cardNumberChange(String text) {
    emit(state.copyWith(
        cardNumber: text, paymentState: const StripePaymentInitial()));
  }

  void yearChange(String text) {
    emit(
        state.copyWith(year: text, paymentState: const StripePaymentInitial()));
  }

  void monthChange(String text) {
    emit(state.copyWith(
        month: text, paymentState: const StripePaymentInitial()));
  }

  void cvcChange(String text) {
    emit(state.copyWith(cvc: text, paymentState: const StripePaymentInitial()));
  }

  Future<void> stripePayment(String planSlug) async {
    /*if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.paymentInfo('1',''),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);

      emit(state.copyWith(paymentState: const StripePaymentLoading()));
      final result = await _paymentRepository.stripePayment(uri,state);
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
        emit(state.clear());
      });
    }*/
  }
}
