part of 'service_cubit.dart';

sealed class ServiceState extends Equatable {
  const ServiceState();
  @override
  List<Object?> get props => [];
}

final class ServiceInitial extends ServiceState {
const ServiceInitial();
}

///all service list 
class ServiceListLoading extends ServiceState {}

class ServiceListLoaded extends ServiceState {
  final ServiceModel detailModel;

  const ServiceListLoaded(this.detailModel);

  @override
  List<Object> get props => [detailModel];
}

class ServiceListError extends ServiceState {
  final String message;
  final int statusCode;

  const ServiceListError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}


///service add/update
final class ServiceAddLoading extends ServiceState {}

final class ServiceAddFormError extends ServiceState {
  final Errors errors;

  const ServiceAddFormError(this.errors);

  @override
  List<Object> get props => [errors];
}

final class ServiceAddLoaded extends ServiceState {
  final ServiceEditInfo? addUpdateInfo;

  const ServiceAddLoaded(this.addUpdateInfo);

  @override
  List<Object?> get props => [addUpdateInfo];
}

final class ServiceAddError extends ServiceState {
  final String message;
  final int statusCode;

  const ServiceAddError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

///service edit/create info
final class ServiceInfoLoading extends ServiceState {}

final class ServiceInfoLoaded extends ServiceState {
  final ServiceEditInfo? editInfo;

  const ServiceInfoLoaded(this.editInfo);

  @override
  List<Object?> get props => [editInfo];
}

final class ServiceInfoError extends ServiceState {
  final String message;
  final int statusCode;

  const ServiceInfoError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

///rest of the state
final class ServiceSubmitted extends ServiceState {
  final String message;

  const ServiceSubmitted(this.message);

  @override
  List<Object> get props => [message];
}