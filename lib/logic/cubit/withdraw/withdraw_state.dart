part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

class WithdrawInitial extends WithdrawState {
  const WithdrawInitial();
}

class CreateWithdrawLoading extends WithdrawState {
  const CreateWithdrawLoading();
}

class CreateWithdrawLoaded extends WithdrawState {
  final String message;

  const CreateWithdrawLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class CreateWithdrawError extends WithdrawState {
  final String message;
  final int statusCode;

  const CreateWithdrawError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class CreateWithdrawFormError extends WithdrawState {
  final Errors errors;

  const CreateWithdrawFormError(this.errors);

  @override
  List<Object> get props => [errors];
}



/// all method list
class MethodInitial extends WithdrawState {
  const MethodInitial();
}

class MethodLoading extends WithdrawState {}

class MethodError extends WithdrawState {
  final String message;
  final int statusCode;

  const MethodError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class MethodLoaded extends WithdrawState {
  final List<MethodModel> methods;

  const MethodLoaded(this.methods);

  @override
  List<Object> get props => [methods];
}


///single account info

class SingleAccountInfoInitial extends WithdrawState {}
class SingleAccountInfoLoading extends WithdrawState {}

class SingleAccountInfoError extends WithdrawState {
  final String message;
  final int statusCode;

  const SingleAccountInfoError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class SingleAccountInfoLoaded extends WithdrawState {
  final AccountInfoModel accountInfo;

  const SingleAccountInfoLoaded(this.accountInfo);

  @override
  List<Object> get props => [accountInfo];
}


///account info
class AccountInfoInitial extends WithdrawState {}

class AccountInfoLoading extends WithdrawState {}

class AllWithdrawListLoaded extends WithdrawState {
  final DashboardModel withdrawList;
  // final WithdrawListModel withdrawList;

  const AllWithdrawListLoaded(this.withdrawList);

  @override
  List<Object> get props => [withdrawList];
}

class AccountInfoError extends WithdrawState {
  final String message;
  final int statusCode;

  const AccountInfoError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}