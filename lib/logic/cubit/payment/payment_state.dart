part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {const PaymentInitial();}

class PaymentStatePageInfoLoading extends PaymentState {}

class PaymentStatePageInfoError extends PaymentState {
  final String message;
  final int statusCode;

  const PaymentStatePageInfoError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class PaymentStatePageInfoLoaded extends PaymentState {
  final PaymentModel payment;

  const PaymentStatePageInfoLoaded(this.payment);

  @override
  List<Object> get props => [payment];
}
///free enrollment
class PaymentStateEnrollLoading extends PaymentState {}

class PaymentStateEnrollError extends PaymentState {
  final String message;
  final int statusCode;

  const PaymentStateEnrollError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class PaymentStateEnrollLoaded extends PaymentState {
  final String message;

  const PaymentStateEnrollLoaded(this.message);

  @override
  List<Object> get props => [message];
}


/// stripe payment
class StripePaymentLoading extends PaymentState {
  const StripePaymentLoading();
}

class StripePaymentLoaded extends PaymentState {
  final String message;

  const StripePaymentLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class StripePaymentError extends PaymentState {
  final String message;
  final int statusCode;

  const StripePaymentError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class StripePaymentFormError extends PaymentState {
  final Errors errors;

  const StripePaymentFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

///bank payment

class BankLoading extends PaymentState {
  const BankLoading();
}

class BankError extends PaymentState {
  const BankError(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class BankLoadedState extends PaymentState {
  const BankLoadedState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

///wallet payment

class WalletLoading extends PaymentState {
  const WalletLoading();
}

class WalletError extends PaymentState {
  const WalletError(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class WalletLoadedState extends PaymentState {
  const WalletLoadedState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}