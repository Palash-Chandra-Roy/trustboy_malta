import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../data/models/service/other_model.dart';
import '../../../../../../data/models/service/service_item.dart';
import '../../../../../utils/k_images.dart';
import '../../../../../widgets/empty_widget.dart';
import '../../../../home/component/single_service.dart';
import '/logic/cubit/wishlist/wishlist_cubit.dart';
import '/presentation/widgets/custom_app_bar.dart';

import '../../../../../../logic/cubit/wishlist/wishlist_state.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/fetch_error_text.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/page_refresh.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishListCubit serviceCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<WishListCubit>();
    Future.microtask(() => serviceCubit.getWishList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Wishlist')),
      body: PageRefresh(
        onRefresh: () async {
          serviceCubit.getWishList();
        },
        child: Utils.logout(
          child: BlocConsumer<WishListCubit, OtherModel>(
            listener: (context, service) {
              final state = service.wishState;

              if (state is WishListStateError) {
                if (state.statusCode == 503) {
                  serviceCubit.getWishList();
                }
                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }

              if (state is WishListRemoveLoaded) {
                debugPrint('removed-wish');
                serviceCubit.getWishList();
              }
            },
            builder: (context, service) {
              final state = service.wishState;
              if (state is WishListStateLoading) {
                return const LoadingWidget();
              } else if (state is WishListStateError) {
                if (state.statusCode == 503) {
                  return WishlistLoadedView(wishlist: serviceCubit.wishlist);
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is WishListStateLoaded) {
                return WishlistLoadedView(wishlist: state.wishlistModel);
              }
              if (serviceCubit.wishlist.isNotEmpty) {
                return WishlistLoadedView(wishlist: serviceCubit.wishlist);
              } else {
                return FetchErrorText(
                    text:
                        Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class WishlistLoadedView extends StatelessWidget {
  const WishlistLoadedView({super.key, required this.wishlist});

  final List<ServiceItem> wishlist;

  @override
  Widget build(BuildContext context) {
    if (wishlist.isNotEmpty) {
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Utils.mediaQuery(context).width,
              margin: Utils.only(top: 14.0,bottom: Utils.mediaQuery(context).height * 0.1),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  ...List.generate(wishlist.length, (index) {
                    final item = wishlist[index];
                    return SingleService(
                        item: item,
                        width: Utils.mediaQuery(context).width * 0.46);
                  }),
                  if (wishlist.length % 2 == 1) ...[
                    SizedBox(width: Utils.mediaQuery(context).width * 0.46),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return EmptyWidget(
          image: KImages.emptyImage,
          isSliver: false,
          height: Utils.mediaQuery(context).height * 0.8);
    }
  }

  /*GestureDetector buildGestureDetector(BuildContext context, ServiceItem item) {
    return GestureDetector(
      onTap: () {
        context.read<ServiceDetailCubit>()
          ..addType('service')
          ..addSlug(item.slug);
        Navigator.pushNamed(context, RouteNames.serviceDetailsScreen);
      },
      child: Container(
        width: Utils.hSize(Utils.mediaQuery(context).width * 0.4),
        padding: Utils.symmetric(v: 10.0, h: 0.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: Utils.borderRadius(r: 8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Utils.vSize(Utils.mediaQuery(context).height * 0.15),
              width: Utils.hSize(Utils.mediaQuery(context).width * 0.6),
              padding: Utils.symmetric(h: 6.0, v: 10.0).copyWith(top: 0.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleImage(
                      image: RemoteUrls.imageUrl(item.thumbImage.isNotEmpty
                          ? item.thumbImage
                          : Utils.defaultImg(context, false)),
                      type: ImageType.rectangle,
                      radius: 6.0,
                      size:
                          Utils.vSize(Utils.mediaQuery(context).height * 0.15)),
                  Positioned(
                    top: Utils.vSize(10.0),
                    right: Utils.hSize(10.0),
                    child: FavouriteButton(id: item.id),
                  ),
                ],
              ),
            ),
            Padding(
              padding: Utils.symmetric(h: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: CustomText(
                        text: Utils.formatAmount(context, item.regularPrice, 2),
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        maxLine: 1,
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: Utils.only(top: 2.0, right: 2.0),
                            child: const Icon(
                              Icons.star,
                              color: primaryColor,
                              size: 16.0,
                            ),
                          ),
                          CustomText(
                              text:
                                  '${item.seller?.avgRating} (${item.seller?.totalRating})',
                              color: gray5B),
                        ],
                      ),
                    ],
                  ),
                  Utils.verticalSpace(4.0),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomText(
                      text: item.title,
                      color: gray5B,
                      fontWeight: FontWeight.w600,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    height: 0.8,
                    margin: Utils.symmetric(h: 0.0, v: 8.0),
                    color: gray5B.withOpacity(0.5),
                  ),
                  Row(
                    children: [
                      const CircleImage(size: 36.0),
                      Utils.horizontalSpace(10.0),
                      Flexible(
                        child: CustomText(
                          text: item.seller?.name ?? '',
                          color: blackColor,
                          fontSize: 14.0,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
