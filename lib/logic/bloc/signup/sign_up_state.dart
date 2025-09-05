import 'package:equatable/equatable.dart';

import '../../../presentation/errors/errors_model.dart';


abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpStateInitial extends SignUpState {
  const SignUpStateInitial();
}

class SignUpStateLoading extends SignUpState {
  const SignUpStateLoading();
}

class SignUpStateLoaded extends SignUpState {
  const SignUpStateLoaded(this.msg);

  final String msg;

  @override
  List<Object> get props => [msg];
}

class SignUpStateNewUserVerificationLoaded extends SignUpState {
  const SignUpStateNewUserVerificationLoaded(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SignUpStateFormValidate extends SignUpState {
  final Errors errors;

  const SignUpStateFormValidate(this.errors);

  @override
  List<Object> get props => [errors];
}

class SignUpStateError extends SignUpState {
  final String errorMsg;
  final int statusCode;

  const SignUpStateError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class SignUpStateResendCodeLoading extends SignUpState {
  const SignUpStateResendCodeLoading();

  @override
  List<Object> get props => [];
}

class SignUpStateResendCodeLoaded extends SignUpState {
  final String message;

  const SignUpStateResendCodeLoaded(this.message);

  @override
  List<Object> get props => [message];
}
