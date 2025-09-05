part of 'wallet_cubit.dart';

sealed class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletModel? wallets;

  const WalletLoaded({required this.wallets});

  @override
  List<Object?> get props => [wallets];
}

class WalletError extends WalletState {
  final String message;
  final int status;

  const WalletError({required this.message, required this.status});

  @override
  List<Object> get props => [message, status];
}

/// stripe payment
class StripePaymentLoading extends WalletState {
  const StripePaymentLoading();
}

class StripePaymentLoaded extends WalletState {
  final String? message;

  const StripePaymentLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class StripePaymentError extends WalletState {
  final String message;
  final int statusCode;

  const StripePaymentError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class StripePaymentFormError extends WalletState {
  final Errors errors;

  const StripePaymentFormError(this.errors);

  @override
  List<Object> get props => [errors];
}