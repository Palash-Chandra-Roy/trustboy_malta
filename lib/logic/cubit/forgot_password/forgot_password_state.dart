part of 'forgot_password_cubit.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordStateInitial extends ForgotPasswordState {
  const ForgotPasswordStateInitial();
  @override
  List<Object> get props => [];
}

class ForgotPasswordStateLoading extends ForgotPasswordState {
  const ForgotPasswordStateLoading();
  @override
  List<Object> get props => [];
}

class ForgotPasswordStateError extends ForgotPasswordState {
  const ForgotPasswordStateError(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class ForgotPasswordFormValidateError extends ForgotPasswordState {
  const ForgotPasswordFormValidateError(this.errors);

  final Errors errors;

  @override
  List<Object> get props => [errors];
}

class ForgotPasswordStateLoaded extends ForgotPasswordState {
  const ForgotPasswordStateLoaded(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class PasswordStateUpdated extends ForgotPasswordState {
  const PasswordStateUpdated(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class VerifyingForgotPasswordCodeLoaded extends ForgotPasswordState {
  const VerifyingForgotPasswordCodeLoaded();

  @override
  List<Object> get props => [];
}

class VerifyingForgotPasswordLoading extends ForgotPasswordState {
  const VerifyingForgotPasswordLoading();

  @override
  List<Object> get props => [];
}

// class ForgotShowConfirmPassword extends ForgotPasswordState {
//   final bool isVisible;
//   const ForgotShowConfirmPassword(this.isVisible);
//
//   @override
//   List<Object> get props => [isVisible];
// }
