import 'package:equatable/equatable.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../presentation/errors/errors_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}

class ProfileStateLoading extends ProfileState {
  const ProfileStateLoading();

  @override
  List<Object> get props => [];
}

class ProfileStateUpdating extends ProfileState {
  const ProfileStateUpdating();

  @override
  List<Object> get props => [];
}

class ProfileProfileImageStateUpdating extends ProfileState {
  const ProfileProfileImageStateUpdating();

  @override
  List<Object> get props => [];
}

class ProfileStateLoaded extends ProfileState {
  final SellerModel profileStateModel;

  const ProfileStateLoaded(this.profileStateModel);

  @override
  List<Object> get props => [profileStateModel];
}

class ProfileStateError extends ProfileState {
  final String message;
  final int statusCode;

  const ProfileStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ProfileStateUpdateError extends ProfileState {
  final String message;
  final int statusCode;

  const ProfileStateUpdateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ProfileStateFormValidate extends ProfileState {
  final Errors errors;

  const ProfileStateFormValidate(this.errors);

  @override
  List<Object> get props => [errors];
}

class ProfileStateUpdated extends ProfileState {
  final String message;

  const ProfileStateUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileOnlineStatusUpdated extends ProfileState {
  final String message;

  const ProfileOnlineStatusUpdated(this.message);

  @override
  List<Object> get props => [message];
}

class GetProfileInitial extends ProfileState {
  const GetProfileInitial();

  @override
  List<Object> get props => [];
}

class GetProfileLoading extends ProfileState {}

class GetProfileLoaded extends ProfileState {
  final SellerModel profileStateModel;

  const GetProfileLoaded(this.profileStateModel);

  @override
  List<Object> get props => [profileStateModel];
}

class GetProfileStateError extends ProfileState {
  final String message;
  final int statusCode;

  const GetProfileStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}
