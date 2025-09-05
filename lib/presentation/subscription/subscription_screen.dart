import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../data/data_provider/remote_url.dart';
import '../../data/models/subscription/sub_detail_model.dart';
import '../../data/models/subscription/subscription_model.dart';
import '../../logic/cubit/subscription/subscription_cubit.dart';
import '../routes/route_names.dart';
import '../utils/constraints.dart';
import '../utils/k_images.dart';
import '../utils/utils.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text.dart';
import '../widgets/empty_widget.dart';
import '../widgets/fetch_error_text.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_refresh.dart';
import '../widgets/primary_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late SubscriptionCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<SubscriptionCubit>();
    termCubit.addSelectedSub(null);
    Future.microtask(()=>termCubit.getSubscriptionList());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Subscription')),
      body: PageRefresh(
        onRefresh: () async {
          termCubit.getSubscriptionList();
        },
        child: Utils.logout(
          child: BlocConsumer<SubscriptionCubit, SubDetailModel>(
            listener: (context, service) {
              final state = service.subState;
              if (state is SubscriptionStateError) {
                if (state.statusCode == 503) {
                  termCubit.getSubscriptionList();
                }

                if(state.statusCode == 401 && state.message.isNotEmpty){
                  Utils.logoutFunction(context);
                }
              }
              if (termCubit.isNavigating) {
                return;
              } else {
                if (state is StripePaymentLoading) {
                  Utils.loadingDialog(context);
                } else {
                  Utils.closeDialog(context);
                  if (state is StripePaymentError) {
                    termCubit.initState();
                    Utils.errorSnackBar(context, state.message);
                  } else if (state is StripePaymentLoaded) {
                    termCubit.initState();
                    Utils.showSnackBar(context, state.message ?? 'Successfully enrolled');
                    //Navigator.pushNamed(context,RouteNames.subsHistoryScreen);
                    Future.delayed(Duration(milliseconds: 1000),(){
                      Navigator.of(context).pop();
                    });
                  }
                }
              }
            },
            builder: (context, service) {
              final state = service.subState;
              if (state is SubscriptionListStateLoading) {
                return const LoadingWidget();
              } else if (state is SubscriptionStateError) {
                if (state.statusCode == 503) {
                  return LoadedSubView(plans: termCubit.plans);
                } else{
                  return FetchErrorText(text: state.message);
                }
              } else if (state is SubscriptionStateLoaded) {
                return LoadedSubView(plans: state.subscriptionListModel);
              }
              if (termCubit.plans?.isNotEmpty??false) {
                return LoadedSubView(plans: termCubit.plans);
              } else {
                return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }
  Widget _bottomButton() {
    return BlocBuilder<SubscriptionCubit, SubDetailModel>(
      builder: (context, state) {
        final post = state.subState;
        if (post is SubscriptionListStateLoading) {
          return const SizedBox.shrink();
        } else if (post is SubscriptionStateLoaded) {
          return _submitButton();
        }
        if (termCubit.plans?.isNotEmpty??false) {
          return _submitButton();
        } else {
            return const SizedBox.shrink();
        }
      },
    );
  }

  _submitButton(){
    return Container(
      color: whiteColor,
      padding: Utils.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      margin: Utils.symmetric(h: 0.0, v: 0.0).copyWith(bottom: 24.0),
      child: PrimaryButton(
        text: Utils.translatedText(context, termCubit.state.subModel?.planPrice == 0.0? 'Trail Now':'Enroll Now'),
        onPressed: () {
          Utils.closeKeyBoard(context);
          // termCubit.initState();
          if(termCubit.state.subModel?.id != 0){
            debugPrint('id-store ${termCubit.state.subModel?.id}');
            if(termCubit.state.subModel?.planPrice == 0.0){
              termCubit.localSubsPayment(SubsType.freePlan);
            }else{
              termCubit..initState()..isNavigating = true;
              Navigator.pushNamed(context,RouteNames.subsPaymentInfoScreen).then((_){termCubit.isNavigating = false;
              });
            }
          }
        },
      ),
    );
  }

  goToNext(){
    Navigator.pushNamed(context,RouteNames.subsHistoryScreen);
  }
}

class LoadedSubView extends StatefulWidget {
  const LoadedSubView({super.key, required this.plans});
  final List<SubscriptionModel>?  plans;

  @override
  State<LoadedSubView> createState() => _LoadedSubViewState();
}

class _LoadedSubViewState extends State<LoadedSubView> {

  late SubscriptionCubit termCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    termCubit = context.read<SubscriptionCubit>();
    if(termCubit.plans?.isNotEmpty??false){
      termCubit..changeSubIndex(0)..addSelectedSub(termCubit.plans?.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.plans?.isNotEmpty??false){
      return BlocBuilder<SubscriptionCubit, SubDetailModel>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: Utils.symmetric(),
            child: Column(
              children: [
                if(state.subModel != null)...[
                  SelectedSubs(subModel: state.subModel),
                ],
                Utils.verticalSpace(28.0),
                CustomText(
                  text: Utils.translatedText(context, 'Select Your Subscription Plan'),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                Utils.verticalSpace(10.0),
                ...List.generate(widget.plans?.length??0, (index) {
                  final sub = widget.plans?[index];
                  final active = state.userId == index;
                  return GestureDetector(
                    onTap: (){
                      termCubit..changeSubIndex(index)..addSelectedSub(sub)..initState();
                    },
                    child: Container(
                      padding: Utils.symmetric(h: 20.0, v: 10.0),
                      margin: Utils.symmetric(h: 0.0,v: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: Utils.borderRadius(r: 4.0),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: active
                                      ? primaryColor
                                      : Colors.transparent,
                                  border: Border.all(color: primaryColor),
                                ),
                                child: active
                                    ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 14.0,
                                )
                                    : null,
                              ),
                              Utils.horizontalSpace(16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: sub?.planName??'',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: blackColor,
                                  ),
                                  CustomText(
                                    text: sub?.expirationDate??'',
                                    fontSize: 10.0,
                                    color: gray5B,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CustomText(
                            text: Utils.formatAmount(context, sub?.planPrice),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      );
    }else{
      return EmptyWidget2(image: KImages.emptySubs,text: 'Sorry!! There no Subscription',subText: 'Opps...this information is not available for a moment',isSliver: false);
    }

  }
}

class SelectedSubs extends StatelessWidget {
  const SelectedSubs({super.key, required this.subModel});
 final SubscriptionModel? subModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Utils.all(value: 20.0),
      margin: Utils.only(top: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: Utils.borderRadius(r: 4.0)
      ),
      child: Column(
        children: [
          _feature('${subModel?.maxListing} ${Utils.translatedText(context, 'Service')}'),
          _feature(Utils.translatedText(context, 'Featured Service'),subModel?.featuredListing != 0),
          _feature('${subModel?.featuredListing} ${Utils.translatedText(context, 'Featured Service')}'),
          _feature(Utils.translatedText(context, 'Recommended Seller'),subModel?.recommendedSeller == 'active'),
          _feature(Utils.translatedText(context, 'Unlimited Job Apply')),
          _feature(Utils.translatedText(context, '24/7 Hour Support')),
        ],
      ),
    );
  }

  Widget _feature(String feature,[bool isActive = true]) {
    return Padding(
      padding: Utils.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive? primaryColor:redColor,
              border: Border.all(color: isActive? primaryColor:redColor),
            ),
            child: Icon(
              isActive ? Icons.done: Icons.clear,
              color: whiteColor,
              size: 14.0,
            ),
          ),
          Utils.horizontalSpace(8.0),
          Flexible(child: CustomText(text: feature,fontSize: 16.0,color: gray5B)),
          // CustomText(text: '${subModel?.maxListing} ${Utils.translatedText(context, 'Service')}')
        ],
      ),
    );
  }
}



