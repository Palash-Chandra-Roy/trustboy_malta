import 'package:equatable/equatable.dart';

import '../../../data/models/service/service_item.dart';


abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishListInitial extends WishlistState {
  const WishListInitial();
}

class WishListStateLoading extends WishlistState {}

class WishListAddedLoaded extends WishlistState {
  final String message;

  const WishListAddedLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class WishListRemoveLoaded extends WishlistState {
  final String message;

  // final WishListModel wishlistModel;

  const WishListRemoveLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class WishListStateLoaded extends WishlistState {
  final List<ServiceItem> wishlistModel;

  const WishListStateLoaded(this.wishlistModel);

  @override
  List<Object> get props => [wishlistModel];
}

class WishListStateError extends WishlistState {
  final String message;
  final int statusCode;

  const WishListStateError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

class WishListDeleteSuccess extends WishlistState {
  const WishListDeleteSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class WishListStateSuccess extends WishlistState {
  final String message;

  const WishListStateSuccess(this.message);

  @override
  List<Object> get props => [message];
}
