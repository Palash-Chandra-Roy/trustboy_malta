import 'package:equatable/equatable.dart';

import '../../../data/models/home/home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object> get props => [];
}

class HomeStateLoading extends HomeState {}

class HomeStateLoaded extends HomeState {
  final HomeModel homeModel;

  const HomeStateLoaded(this.homeModel);

  @override
  List<Object> get props => [homeModel];
}

// class HomeStateBestSellingLoaded extends HomeState {
//   final List<ProductItemModel> bestProduct;
//
//   // final List<BestProductModel> bestProduct;
//
//   const HomeStateBestSellingLoaded(this.bestProduct);
//
//   @override
//   List<Object> get props => [bestProduct];
// }

class HomeStateError extends HomeState {
  final String message;
  final int statusCode;

  const HomeStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}
