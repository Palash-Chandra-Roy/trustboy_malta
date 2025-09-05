part of 'dashboard_cubit.dart';

abstract class DashBoardState extends Equatable {
  const DashBoardState();

  @override
  List<Object> get props => [];
}

class DashBoardInitial extends DashBoardState {
  const DashBoardInitial();
}

class DashBoardStateLoading extends DashBoardState {}

class DashBoardStateLoaded extends DashBoardState {
  final DashboardModel providerDashBoard;

  const DashBoardStateLoaded({required this.providerDashBoard});

  @override
  List<Object> get props => [providerDashBoard];
}

class DashBoardStateError extends DashBoardState {
  final String message;
  final int status;

  const DashBoardStateError({required this.message, required this.status});

  @override
  List<Object> get props => [message, status];
}
