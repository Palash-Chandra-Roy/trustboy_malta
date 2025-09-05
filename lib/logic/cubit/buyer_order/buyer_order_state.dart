part of 'buyer_order_cubit.dart';

sealed class BuyerOrderState extends Equatable {
  const BuyerOrderState();

  @override
  List<Object?> get props => [];
}

final class BuyerOrderInitial extends BuyerOrderState {
  const BuyerOrderInitial();
}
//all order
final class BuyerOrderLoading extends BuyerOrderState {}

final class BuyerOrderError extends BuyerOrderState {
  final String message;
  final int statusCode;

  const BuyerOrderError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class BuyerOrderLoaded extends BuyerOrderState {
  final OrderModel orders;

  const BuyerOrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

//order detail
final class BuyerOrderDetailError extends BuyerOrderState {
  final String message;
  final int statusCode;

  const BuyerOrderDetailError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class BuyerOrderDetailsLoading extends BuyerOrderState {}

final class BuyerOrderDetailsLoaded extends BuyerOrderState {
  final OrderDetail detail;

  const BuyerOrderDetailsLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}


//cancel/accept job post
final class BuyerOrderDeleteError extends BuyerOrderState {
  final String message;
  final int statusCode;

  const BuyerOrderDeleteError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class BuyerOrderDeleteLoading extends BuyerOrderState {}

final class BuyerOrderDeleteLoaded extends BuyerOrderState {
  final String message;

  const BuyerOrderDeleteLoaded(this.message);

  @override
  List<Object> get props => [message];
}

//file submission
final class BuyerFileFormError extends BuyerOrderState {
  final Errors errors;

  const BuyerFileFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class BuyerFileSubmitting extends BuyerOrderState {}

final class BuyerFileSubmissionError extends BuyerOrderState {
  final String message;
  final int statusCode;

  const BuyerFileSubmissionError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class BuyerFileSubmitted extends BuyerOrderState {
  final String message;

  const BuyerFileSubmitted(this.message);

  @override
  List<Object> get props => [message];
}