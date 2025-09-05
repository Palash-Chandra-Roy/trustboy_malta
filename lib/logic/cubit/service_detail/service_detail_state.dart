part of 'service_detail_cubit.dart';

sealed class ServiceDetailState extends Equatable {
  const ServiceDetailState();
  @override
  List<Object> get props => [];
}

final class ServiceDetailInitial extends ServiceDetailState {
const ServiceDetailInitial();
}

class ServiceDetailStateLoading extends ServiceDetailState {}

class ServiceDetailStateLoaded extends ServiceDetailState {
  final ServiceModel detailModel;

  const ServiceDetailStateLoaded(this.detailModel);

  @override
  List<Object> get props => [detailModel];
}

class ServiceDetailStateError extends ServiceDetailState {
  final String message;
  final int statusCode;

  const ServiceDetailStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class JobsDetailStateLoaded extends ServiceDetailState {
  final JobPostModel detailModel;

  const JobsDetailStateLoaded(this.detailModel);

  @override
  List<Object> get props => [detailModel];
}