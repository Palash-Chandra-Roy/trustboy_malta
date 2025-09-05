import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/bloc/login/login_bloc.dart';

import '../../../data/data_provider/remote_url.dart';

import '../../../data/models/service/other_model.dart';
import '../../../data/models/service/service_item.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../repository/profile_repository.dart';
import 'wishlist_state.dart';

class WishListCubit extends Cubit<OtherModel> {
  final ProfileRepository _repository;
  final LoginBloc _loginBloc;

  WishListCubit({
    required ProfileRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(const OtherModel());

  List<ServiceItem> wishlist = [];

  Future<void> addToWishList(String id, [bool isAdd = true]) async {
   if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
     Uri uri;
     Either<Failure, String> result;
     if (isAdd) {
       uri = Utils.tokenWithCode(
           RemoteUrls.addToWishList,
           _loginBloc.userInformation?.accessToken??'',
           _loginBloc.state.langCode,extraParams: {'item_id':id});
       //debugPrint('added-wishlist $uri');
       result = await _repository.addToWishList(uri);
     } else {
       uri = Utils.tokenWithCode(
           RemoteUrls.removeWishList(id),
           _loginBloc.userInformation?.accessToken??'',
           _loginBloc.state.langCode);
       //debugPrint('removed-wishlist $uri');
       result = await _repository.removeWishList(uri);
     }


      result.fold((failure) {
       final errors = WishListStateError(failure.message, failure.statusCode);
       emit(state.copyWith(wishState: errors));
     }, (success) {
       if (isAdd) {
         final successState = WishListAddedLoaded(success);
         emit(state.copyWith(wishState: successState));
         // return true;
       } else {
         // addWishIds(int.parse(id));
         wishlist.removeWhere((w)=>w.id.toString() == id);
         final successState = WishListRemoveLoaded(success);
         emit(state.copyWith(wishState: successState));
         // getWishList();
       }
     });
   }
  }

  Future<void> getWishList() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
    emit(state.copyWith(wishState: WishListStateLoading()));
    final uri = Utils.tokenWithCode(RemoteUrls.getWishList,
        _loginBloc.userInformation?.accessToken??'', _loginBloc.state.langCode);
    //debugPrint('called-wishlist $uri');
      final result = await _repository.getWishList(uri);
    result.fold((failure) {
      final errorState =
      WishListStateError(failure.message, failure.statusCode);
      emit(state.copyWith(wishState: errorState));
    }, (success) {
      wishlist = success;
      final successState = WishListStateLoaded(wishlist);
      emit(state.copyWith(wishState: successState));
      getWishIds();
    });
  }
  }

  void getWishIds() {
    //if (services.isNotEmpty) {
    if (wishlist.isNotEmpty) {
      final updatedList = List.of(state.tempWishId);
      // state.tempWishId.clear();
      for (int i = 0; i < wishlist.length; i++) {
        //debugPrint('wish-ids ${wishlist[i].id}');
        updatedList.add(wishlist[i].id);
      }
      emit(state.copyWith(tempWishId: updatedList));
    }
  }

  void addWishIds(int id) {
    final updatedList = List.of(state.tempWishId);
    if (!updatedList.contains(id)) {
      updatedList.add(id);
    } else {
      updatedList.remove(id);
    }
    emit(state.copyWith(tempWishId: updatedList));
  }

  void toggleTap(bool val){
      emit(state.copyWith(isTap: val));
      debugPrint('isTap changed to ${state.isTap} from toggleTap');
  }

  void tapWithDuration(bool val){
    Future.delayed(const Duration(milliseconds: 1600),(){
      emit(state.copyWith(isTap: val));
      debugPrint('isTap changed to ${state.isTap} after 1600 seconds');
    });
  }

  void resetState(){
    emit(state.copyWith(wishState: const WishListInitial()));
  }

 /* void loadedWish(){
    emit(state.copyWith(wishState: WishListStateLoaded(wishlist)));
  }*/
}
