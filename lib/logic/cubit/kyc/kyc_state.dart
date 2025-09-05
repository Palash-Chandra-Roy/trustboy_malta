part of 'kyc_cubit.dart';

sealed class KycState extends Equatable {
  const KycState();

  @override
  List<Object> get props => [];
}

final class KycInitial extends KycState {
  const KycInitial();
}

final class KycInfoLoading extends KycState {}

final class KycInfoError extends KycState {
  final String message;
  final int statusCode;

  const KycInfoError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class KycInfoLoaded extends KycState {
  final KycModel kycModel;

  const KycInfoLoaded(this.kycModel);

  @override
  List<Object> get props => [kycModel];
}

final class KycSubmitLoading extends KycState {}

final class KycSubmitError extends KycState {
  final String message;
  final int statusCode;

  const KycSubmitError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class KycSubmitFormError extends KycState {
  final Errors errors;

  const KycSubmitFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class KycSubmitLoaded extends KycState {
  final String message;

  const KycSubmitLoaded(this.message);

  @override
  List<Object> get props => [message];
}
