part of 'delete_cubit.dart';

sealed class DeleteState extends Equatable {
  const DeleteState();

  @override
  List<Object> get props => [];
}

final class DeleteInitial extends DeleteState {
  const DeleteInitial();
}

final class DeleteLoading extends DeleteState {
  const DeleteLoading();
}

final class DeleteError extends DeleteState {
  final String message;
  final int statusCode;

  const DeleteError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class DeleteFormError extends DeleteState {
  final Errors errors;

  const DeleteFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class DeleteLoaded extends DeleteState {
  final String message;

  const DeleteLoaded(this.message);

  @override
  List<Object> get props => [message];
}
