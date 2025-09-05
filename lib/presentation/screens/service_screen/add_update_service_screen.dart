import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/route_names.dart';
import '/presentation/routes/route_packages_name.dart';
import '/presentation/widgets/custom_text.dart';
import '../../../data/models/service/service_item.dart';
import '../../../logic/cubit/service/service_cubit.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/primary_button.dart';
import 'component/basic_information.dart';
import 'component/package_information.dart';
import 'component/seo_information.dart';
import 'component/service_stepper.dart';
import 'component/thumbnail_information.dart';

class AddUpdateServiceScreen extends StatefulWidget {
  const AddUpdateServiceScreen({super.key});

  @override
  State<AddUpdateServiceScreen> createState() => _AddUpdateServiceScreenState();
}

class _AddUpdateServiceScreenState extends State<AddUpdateServiceScreen> {

  late ServiceCubit serviceCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ServiceCubit>();

   Future.microtask(()=>serviceCubit.createEditInfo());
  }

  @override
  void dispose() {
    if(serviceCubit.editInfo != null){
      serviceCubit..stepperIndex(0)..categoryId(0)..subCategoryId(0)..clearSubCat()..havePlan(false)..editInfo = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, serviceCubit.state.id != 0? 'Edit Service':'Create Service')),
      body: PageRefresh(
        onRefresh: () async {
          serviceCubit.createEditInfo();
        },
        child: Utils.logout(
          child: BlocConsumer<ServiceCubit, ServiceItem>(
            listener: (context, states) {
              final state = states.serviceState;
              if (state is ServiceInfoError) {
                if (state.statusCode == 503 || serviceCubit.editInfo == null && state.statusCode != 403) {
                  serviceCubit.createEditInfo();
                }
                if (state.statusCode == 401) {
                  Utils.logoutFunction(context);
                }

              }
            },
            builder: (context, states) {
              final state = states.serviceState;
              if (state is ServiceInfoLoading && states.id != 0) {
                return const LoadingWidget();
              } else if (state is ServiceInfoError) {

                if (state.statusCode == 503 || serviceCubit.editInfo != null) {
                  return const LoadedAddEditView();
                } else if(state.statusCode == 403){
                  return _purchasePlan(state.message);
                }else{
                  return FetchErrorText(text: state.message);
                }


              } else if (state is ServiceInfoLoaded) {
                return const LoadedAddEditView();
              }

              if (serviceCubit.editInfo != null) {
                return const LoadedAddEditView();
              } else {
                // if(states.id == 0 && states.havePlan == false){return const LoadedAddEditView();
                // }else{
                //   if(states.havePlan == true && state is ServiceInfoError){
                //     final m = state;
                //       return _purchasePlan(m.message);
                //   }else{
                //   return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
                //   }
                // }
                if(states.id == 0){return const LoadedAddEditView();}else{
                  return  FetchErrorText(text: Utils.translatedText(context, 'Something went wrong'));
                }
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

 Widget _purchasePlan(String message){
    return Container(
      padding: Utils.all(value: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: message,color: redColor,fontWeight: FontWeight.w500,textAlign: TextAlign.center,height: 1.6),
          Utils.verticalSpace(14.0),
          PrimaryButton(
            text: Utils.translatedText(context, 'Buy Subscription'),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.subsScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return BlocConsumer<ServiceCubit, ServiceItem>(
      listener: (context, state) {
        final post = state.serviceState;

          if (post is ServiceAddError) {
            if(post.statusCode == 401){
              Utils.logoutFunction(context);
            }

            serviceCubit.initState();
            Utils.errorSnackBar(context, post.message);
          } else if (post is ServiceAddLoaded) {

            serviceCubit.initState();

            Utils.showSnackBar(context, post.addUpdateInfo?.message??'');

            if(state.id != 0){
              if(state.totalView == 0){
                serviceCubit.stepperIndex(1);
              }else if(state.totalView == 1){
                serviceCubit.stepperIndex(2);
              }else if(state.totalView == 2){
                serviceCubit.stepperIndex(3);
              }else if(state.totalView == 3){
                Navigator.of(context).pop(true);
              }
            }

            if(state.id != 0){
              Future.delayed(const Duration(milliseconds: 1000),(){
                serviceCubit.sellerAllServices();
              });
            }

        }else if(post is ServiceSubmitted){
            serviceCubit.initState();

            Utils.showSnackBar(context, post.message);

            if(state.id != 0){
              if(state.totalView == 0){
                serviceCubit.stepperIndex(1);
              }else if(state.totalView == 1){
                serviceCubit.stepperIndex(2);
              }else if(state.totalView == 2){
                serviceCubit.stepperIndex(3);
              }else if(state.totalView == 3){
                Navigator.of(context).pop(true);
              }
            }

            if(state.id != 0){
              Future.delayed(const Duration(milliseconds: 1000),(){
                serviceCubit.sellerAllServices();
              });
            }
          }
      },
      builder: (context, state) {
        final post = state.serviceState;
        if (post is ServiceInfoLoading && state.id != 0) {
          return const SizedBox.shrink();
        } else if(post is ServiceInfoError){
          return const SizedBox.shrink();
        }else if (post is ServiceInfoLoaded) {
          return _submitButton(context, post, state);
        }
        if (serviceCubit.editInfo != null) {
          return _submitButton(context, post, state);
        } else {
          if (state.id == 0) {
            return _submitButton(context, post, state);
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  String _getText(int index,int packageTab){
    if(index == 1){
      if(packageTab <= 1){
        return Utils.translatedText(context, 'Next');
      }else{
        // return Utils.translatedText(context, 'Package');
        return Utils.translatedText(context, 'Add Package');
      }

    }else if(index == 2){
      return Utils.translatedText(context, 'Thumbnail');
    }else if(index == 3){
      return Utils.translatedText(context, 'SEO');
    }else{
      return Utils.translatedText(context, 'Next');
    }
  }

  Widget _submitButton(BuildContext context, ServiceState? post, ServiceItem state) {
    return Container(
        color: scaffoldBgColor,
        padding: Utils.only(
          left: 20.0,
          right: 20.0,
          top: 10.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        margin: Utils.symmetric(h: 0.0, v: 0.0).copyWith(bottom: 24.0),
        child: Row(
          children: [

            if(post is ServiceAddLoading)...[
              const Spacer(),
              _loading(),
              const Spacer(),
            ]else...[
              if(state.totalView == 3 && state.isDraft == 'draft')...[
                Expanded(
                  child:  PrimaryButton(
                    text: Utils.translatedText(context, 'Publish Now'),
                    onPressed: () {
                      Utils.closeKeyBoard(context);
                      serviceCubit.addSeo(true);
                    },
                  ),
                ),
                Utils.horizontalSpace(10.0),
              ],
              // else...[
              //   const Spacer(),
              // ],
              Flexible(
                 child: PrimaryButton(
                  text:  _getText(state.totalView,state.packageTab) ,//Utils.translatedText(context, 'Next'),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    if(state.totalView <= 1){
                      // debugPrint('true-current-stepper ${state.totalView}');

                      if(state.totalView == 1){
                          if(state.packageTab == 0){
                            serviceCubit.changePacTab(1);
                          }else if(state.packageTab == 1){
                            serviceCubit.changePacTab(2);
                          }else{
                            if(!PackageItem.isValid(state.basic)){
                              // debugPrint('basic-all-or-some-empty ${PackageItem.isValid(state.basic)}');
                              serviceCubit.changePacTab(0);
                            }else if(!PackageItem.isValid(state.standard)){
                              // debugPrint('standard-all-or-some-empty ${PackageItem.isValid(state.standard)}');
                              serviceCubit.changePacTab(1);
                            }else if(!PackageItem.isValid(state.premium)){
                              // debugPrint('premium-all-or-some-empty ${PackageItem.isValid(state.premium)}');
                              serviceCubit.changePacTab(2);
                            }else{
                            serviceCubit.addUpdatePackage();
                            }
                          }

                        // debugPrint('current-index ${state.totalView}');
                    }else{
                        serviceCubit.addUpdatePackage();
                      }
                    }else if(state.totalView == 3){
                      //debugPrint('false-current-stepper ${state.totalView}');
                      serviceCubit.addSeo();
                    }else{
                      serviceCubit.submitOther();
                    }
                    // profileCubit.updateUserInfo();
                  },
                ),
              ),
            ]
          ],
        ),
      );
  }

  _loading(){
    return const CircularProgressIndicator(color: primaryColor);
  }
}

class LoadedAddEditView extends StatefulWidget {
  const LoadedAddEditView({super.key});

  @override
  State<LoadedAddEditView> createState() => _LoadedAddEditViewState();
}

class _LoadedAddEditViewState extends State<LoadedAddEditView> {
  late ServiceCubit serviceCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ServiceCubit>();
  }

  @override
  void dispose() {
    // serviceCubit.tabChange(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steppers = [
      Utils.translatedText(context, 'Information'),
      Utils.translatedText(context, 'Package'),
      Utils.translatedText(context, 'Thumbnail'),
      Utils.translatedText(context, 'SEO'),
    ];
    return ListView(
      children: [
       BlocBuilder<ServiceCubit,ServiceItem>(
         builder: (context,state){
           return Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: List.generate(steppers.length, (index){
               final active = state.totalView == index;
               return Flexible(
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     GestureDetector(
                       // onTap:  () =>serviceCubit.stepperIndex(index),
                       onTap: state.id != 0? () =>serviceCubit.stepperIndex(index):null,
                       child: AnimatedContainer(
                         duration: kDuration,
                         height: 55.0,
                         width: 46.0,
                         margin: Utils.only(bottom: 8.0),
                         child: CustomPaint(
                           painter:  ServiceStepper(color: active? primaryColor:whiteColor),
                           child: Align(
                             alignment: Alignment.center,
                             child: CustomText(text: '${index + 1}',textAlign: TextAlign.center,fontSize: 18.0,fontWeight: FontWeight.w600,color: active?whiteColor:gray5B,),
                           ),
                         ),
                       ),
                     ),
                     Flexible(child: CustomText(text: steppers[index],fontSize:  16.0,maxLine: 1,color: active?blackColor:gray5B)),
                   ],
                 ),
               );
             },
             ),
           );
         },
       ),
        Utils.verticalSpace(20.0),
        BlocBuilder<ServiceCubit,ServiceItem>(
          builder: (context,state){
            if(state.totalView == 0){
              return const BasicInformation();
            }else if(state.totalView == 1){
              return const PackageInformation();
            }else if(state.totalView == 2){
              return const ThumbnailInformation();
            }else{
              return const SeoInformation();
            }
          },
        ),
      ],
    );
  }
}

