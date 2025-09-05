part of 'service_list_cubit.dart';

sealed class ServiceListState extends Equatable {
  const ServiceListState();

  @override
  List<Object> get props => [];
}

final class ServiceListInitial extends ServiceListState {
  const ServiceListInitial();
}

class ServiceLoadingState extends ServiceListState {}

class ServiceErrorState extends ServiceListState {
  final String message;
  final int statusCode;

  const ServiceErrorState(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ServiceList extends ServiceListState {
  final List<ServiceItem> booking;

  const ServiceList(this.booking);

  @override
  List<Object> get props => [booking];
}

class ServiceListMore extends ServiceListState {
  final List<ServiceItem> booking;

  const ServiceListMore(this.booking);

  @override
  List<Object> get props => [booking];
}

class SellerList extends ServiceListState {
  final List<SellerModel> booking;

  const SellerList(this.booking);

  @override
  List<Object> get props => [booking];
}

class SellerListMore extends ServiceListState {
  final List<SellerModel> booking;

  const SellerListMore(this.booking);

  @override
  List<Object> get props => [booking];
}

class JobPostList extends ServiceListState {
  final List<JobPostItem> booking;

  const JobPostList(this.booking);

  @override
  List<Object> get props => [booking];
}

class JobPostListMore extends ServiceListState {
  final List<JobPostItem> booking;

  const JobPostListMore(this.booking);

  @override
  List<Object> get props => [booking];
}


//filter states

class ServiceFilterLoading extends ServiceListState {}

class ServiceFilterError extends ServiceListState {
  final String message;
  final int statusCode;

  const ServiceFilterError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class ServiceFilterLoaded extends ServiceListState {
  final FilterModel filter;

  const ServiceFilterLoaded(this.filter);

  @override
  List<Object> get props => [filter];
}