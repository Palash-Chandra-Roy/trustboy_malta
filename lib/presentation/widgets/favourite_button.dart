import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/service/other_model.dart';
import '../../logic/cubit/wishlist/wishlist_cubit.dart';
import '../../logic/cubit/wishlist/wishlist_state.dart';
import '../utils/constraints.dart';
import '../utils/utils.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({super.key, required this.id});

  final int id;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  late WishListCubit wishList;

  @override
  void initState() {
    wishList = context.read<WishListCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishListCubit, OtherModel>(
      listener: (context, state) {
        final wishState = state.wishState;
        if (wishState is WishListStateError) {
          debugPrint('wish-error ${wishState.statusCode} ${wishState.message}');
          wishList..resetState()..tapWithDuration(true);
          Utils.errorSnackBar(context, wishState.message, 1500);
        } else if (wishState is WishListAddedLoaded) {
          wishList..resetState()..tapWithDuration(true);
          Utils.showSnackBar(context, wishState.message, whiteColor, 1500);
        } else if (wishState is WishListRemoveLoaded) {
          wishList..resetState()..tapWithDuration(true);
          Utils.showSnackBar(context, wishState.message, whiteColor, 1500);
        }
      },
      builder: (context, state) {
        return CircleAvatar(
          backgroundColor:  whiteColor,
            maxRadius: 16.0,
            child: GestureDetector(
              onTap: ()async{
                if(Utils.isLoggedIn(context)){
                  if(state.isTap == true){
                    wishList..toggleTap(false)..addWishIds(widget.id);
                    debugPrint('isTap toggled ${state.isTap}');
                    if (state.tempWishId.contains(widget.id)) {
                      await wishList.addToWishList(widget.id.toString(), false);
                    } else {
                      await wishList.addToWishList(widget.id.toString());
                    }
                  }else{
                    debugPrint('one operation is running ${state.isTap}');
                  }
                }else{
                  Utils.showSnackBarWithLogin(context);
                }
            },
              child: Icon(
                state.tempWishId.contains(widget.id)? Icons.favorite_outlined: Icons.favorite_border,
                size: 24.0,
                color: state.tempWishId.contains(widget.id) ? primaryColor : gray5B,
              ),
            ),
        );
      },
    );
  }
}
