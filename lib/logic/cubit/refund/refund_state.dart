part of 'refund_cubit.dart';

sealed class RefundState extends Equatable {
  const RefundState();
  @override
  List<Object?> get props => [];
}

final class RefundInitial extends RefundState {
  const RefundInitial();
}

class RefundLoading extends RefundState {}

class RefundLoaded extends RefundState {
  final List<RefundItem> refunds;

  const RefundLoaded(this.refunds);

  @override
  List<Object> get props => [refunds];
}

class RefundStateError extends RefundState {
  final String message;
  final int statusCode;

  const RefundStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}