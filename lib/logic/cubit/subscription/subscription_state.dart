part of 'subscription_cubit.dart';

sealed class SubscriptionState extends Equatable {
  const SubscriptionState();
  @override
  List<Object?> get props => [];
}

final class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}


class SubscriptionListStateLoading extends SubscriptionState {}

class SubscriptionStateLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptionListModel;

  const SubscriptionStateLoaded(this.subscriptionListModel);

  @override
  List<Object> get props => [subscriptionListModel];
}

class SubscriptionStateError extends SubscriptionState {
  final String message;
  final int statusCode;

  const SubscriptionStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

/// payment Info

class PaymentInfoStateLoading extends SubscriptionState {}

class PaymentInfoStateLoaded extends SubscriptionState {
  final PaymentModel paymentInfoModel;

  const PaymentInfoStateLoaded(this.paymentInfoModel);

  @override
  List<Object> get props => [paymentInfoModel];
}

class PaymentInfoStateError extends SubscriptionState {
  final String message;
  final int statusCode;

  const PaymentInfoStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

/// subscription histories
class PurchaseLoadingState extends SubscriptionState {}

class PurchaseErrorState extends SubscriptionState {
  final String message;
  final int statusCode;

  const PurchaseErrorState(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class SubscriptionList extends SubscriptionState {
  final List<SubDetailModel?>? booking;

  const SubscriptionList(this.booking);

  @override
  List<Object?> get props => [booking];
}

class SubscriptionListMore extends SubscriptionState {
  final List<SubDetailModel?>? booking;

  const SubscriptionListMore(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// stripe payment
class StripePaymentLoading extends SubscriptionState {
  const StripePaymentLoading();
}

class StripePaymentLoaded extends SubscriptionState {
  final String? message;

  const StripePaymentLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class StripePaymentError extends SubscriptionState {
  final String message;
  final int statusCode;

  const StripePaymentError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class StripePaymentFormError extends SubscriptionState {
  final Errors errors;

  const StripePaymentFormError(this.errors);

  @override
  List<Object> get props => [errors];
}