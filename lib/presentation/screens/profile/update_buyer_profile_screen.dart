import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/screens/main_screen/component/main_controller.dart';
import '../service_screen/component/thumbnail_information.dart';
import '/presentation/widgets/card_top_part.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/dummy_data/dummy_data.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../logic/cubit/profile/profile_cubit.dart';
import '../../../logic/cubit/profile/profile_state.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/add_new_button.dart';
import '../../widgets/common_container.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_form.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/error_text.dart';
import '../../widgets/primary_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  late ProfileCubit profileCubit;
  late DummyPackage? _type;


  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    profileCubit = context.read<ProfileCubit>();

    if(profileCubit.state.image.isNotEmpty){
      profileCubit.imageChange('');
    }


    if(Utils.isSeller(context)){
      profileCubit.isSellerPade(true);
    }else{
      profileCubit.isSellerPade(false);
    }

    if (profileCubit.state.gender.isEmpty) {
      _type = genders(context).first;
      profileCubit.genderChange(_type?.value??'');
    }

    if(profileCubit.state.languageList.isEmpty){
      profileCubit.addLanguage('');
    }
    if(profileCubit.state.skillList.isEmpty){
      profileCubit.addSkill('');
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, 'Edit Profile')),
      body: Utils.logout(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            // CustomText(text: Utils.translatedText(context, 'Edit Profile'),fontWeight: FontWeight.w600,color: blackColor),
            // const Divider(color: stockColor),
            CardTopPart(title: 'Basic Information',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0),),
            CommonContainer(
              child: Column(
                children: [
                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Name'),
                    bottomSpace: 20.0,
                    child: BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.name,
                              onChanged: profileCubit.nameChange,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Name',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: TextInputType.text,

                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (post.errors.name.isNotEmpty)
                                ErrorText(text: post.errors.name.first),
                            ],

                          ],
                        );
                      },
                    ),
                  ),

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Designation'),
                    bottomSpace: 20.0,
                    isRequired: false,
                    child:  BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.designation,
                              onChanged: profileCubit.designationChange,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Designation',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: TextInputType.text,
                              // inputFormatters: Utils.inputFormatter,
                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (state.name.isNotEmpty)
                                if (post.errors.designation.isNotEmpty)
                                  ErrorText(text: post.errors.designation.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Gender'),
                    bottomSpace: 20.0,
                    child:   BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        if (state.gender.isNotEmpty) {
                          _type = genders(context).where((type) => type.value == state.gender)
                              .first;
                        } else {
                          _type = null;
                          //debugPrint('gender-status-null ${state.gender}');
                        }
                        return DropdownButtonFormField<DummyPackage>(
                          hint:  CustomText(text:Utils.translatedText(context, 'Gender')),
                          isDense: true,
                          isExpanded: true,
                          value: _type,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          decoration: InputDecoration(
                              isDense: true,
                              border:  outlineBorder(),
                              enabledBorder: outlineBorder(),
                              focusedBorder: outlineBorder()
                          ),
                          borderRadius: Utils.borderRadius(r: 5.0),
                          dropdownColor: whiteColor,

                          onChanged: (value) {
                            if (value == null) return;
                            profileCubit.genderChange(value.value);
                          },
                          items: genders(context).map<DropdownMenuItem<DummyPackage>>(
                                (DummyPackage value) => DropdownMenuItem<DummyPackage>(
                              value: value,
                              child: CustomText(text: value.title),
                            ),
                          ).toList(),
                        );
                      },
                    ),
                  ),

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Email'),
                    bottomSpace: 20.0,
                    child:    BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.email,
                              onChanged: profileCubit.emailChange,
                              enabled: false,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Email',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (state.designation.isNotEmpty)
                                if (post.errors.email.isNotEmpty)
                                  ErrorText(text: post.errors.email.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),
                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Phone'),
                    bottomSpace: 20.0,
                    isRequired: false,
                    child:    BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.phone,
                              onChanged: profileCubit.phoneChange,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Phone',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (state.email.isNotEmpty)
                                if (post.errors.phone.isNotEmpty)
                                  ErrorText(text: post.errors.phone.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),

                  if(Utils.isSeller(context))...[
                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Hourly Rate'),
                      bottomSpace: 20.0,
                      isRequired: false,
                      child:    BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.verificationOtp,
                                onChanged: profileCubit.hourlyRateChange,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Hourly Rate',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: Utils.inputFormatter,
                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (state.email.isNotEmpty)
                              //     if (post.errors.phone.isNotEmpty)
                              //       ErrorText(text: post.errors.phone.first),
                              // ]
                            ],
                          );
                        },
                      ),
                    ),
                  ],

                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Language'),
                    bottomSpace: 20.0,
                    isRequired: false,
                    child: BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        // final post = state.profileState;
                        return Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(
                            (state.languageList.length / 2).ceil(),
                                (rowIndex) {
                              final int firstIndex = rowIndex * 2;
                              final int secondIndex = firstIndex + 1;
                              final bool isLastRow = rowIndex == (state.languageList.length / 2).ceil() - 1;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      initialValue: state.languageList[firstIndex],
                                      onChanged: (String text){
                                        profileCubit.updateLanguage(firstIndex, text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: Utils.translatedText(context, 'New Language', true),
                                        border: outlineBorder(),
                                        enabledBorder: outlineBorder(),
                                        focusedBorder: outlineBorder(),
                                        suffixIcon: GestureDetector(
                                          onTap: ()=>profileCubit.removeLanguage(firstIndex),
                                          child: const Icon(Icons.clear, color: redColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (secondIndex < state.languageList.length)...[Utils.horizontalSpace(10.0)],

                                  if (secondIndex < state.languageList.length)...[
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                        initialValue: state.languageList[secondIndex],
                                        onChanged: (String text){
                                          profileCubit.updateLanguage(secondIndex, text);
                                        },
                                        decoration: InputDecoration(
                                          hintText: Utils.translatedText(context, 'New Language', true),
                                          border: outlineBorder(),
                                          enabledBorder: outlineBorder(),
                                          focusedBorder: outlineBorder(),
                                          suffixIcon: GestureDetector(
                                            onTap: ()=>profileCubit.removeLanguage(secondIndex),
                                            child: const Icon(Icons.clear, color: redColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  if (isLastRow)...[Utils.horizontalSpace(10.0)],// Spacer before the button
                                  if (isLastRow)...[
                                    AddNewButton(onPressed: (){
                                      profileCubit.addLanguage('');
                                    }),
                                  ],
                                ],
                              );
                            },
                          ),
                        );

                      },
                    ),
                  ),
                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Address'),
                    isRequired: false,
                    bottomSpace: 20.0,
                    child:    BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.address,
                              onChanged: profileCubit.addressChange,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'Address',true),
                                  border:  outlineBorder(),
                                  enabledBorder: outlineBorder(),
                                  focusedBorder: outlineBorder()
                              ),
                              keyboardType: TextInputType.streetAddress,
                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (state.phone.isNotEmpty)
                                if (post.errors.phone.isNotEmpty)
                                  ErrorText(text: post.errors.phone.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),
                  CustomFormWidget(
                    label: Utils.translatedText(context, 'About Me'),
                    bottomSpace: 20.0,
                    isRequired: false,
                    child:    BlocBuilder<ProfileCubit, SellerModel>(
                      builder: (context, state) {
                        final post = state.profileState;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: state.aboutMe,
                              onChanged: profileCubit.aboutMeChange,
                              decoration:  InputDecoration(
                                  hintText: Utils.translatedText(context, 'About Me',true),
                                  border:  outlineBorder(10.0),
                                  enabledBorder: outlineBorder(10.0),
                                  focusedBorder: outlineBorder(10.0)
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                            ),
                            if (post is ProfileStateFormValidate) ...[
                              if (state.phone.isNotEmpty)
                                if (post.errors.phone.isNotEmpty)
                                  ErrorText(text: post.errors.phone.first),
                            ]
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            CardTopPart(title: 'Upload Profile Image',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0).copyWith(top: 20.0)),
            CommonContainer(
              child: CustomFormWidget(
                label: Utils.translatedText(context, 'Profile Image'),
                bottomSpace: 0.0,
                isRequired: false,
                child: BlocBuilder<ProfileCubit, SellerModel>(
                  builder: (context,state){
                    final existImage = state.createdAt.isNotEmpty
                        ?  RemoteUrls.imageUrl(state.createdAt):
                    Utils.defaultImg(context,false);
                    // debugPrint('existing-image $existImage');

                    final pickImage = state.image.isNotEmpty ? state.image : existImage;
                    // debugPrint('pick-image $pickImage');
                    // debugPrint('state-image ${state.image}');
                    // debugPrint('pick-image $pickImage');
                    // final post = state.profileState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*GestureDetector(
                          onTap: ()async{
                            final image = await Utils.pickSingleImage();
                            if (image?.isNotEmpty??false) {
                              profileCubit.imageChange(image??'');
                              Future.delayed(const Duration(seconds: 1),()async{
                                await profileCubit.updateProfileAvatar();
                              });
                            }
                          },
                          child: Container(
                              padding: Utils.symmetric(v: 6.0,h: state.image.isNotEmpty? 6.0:16.0),
                              decoration: BoxDecoration(
                                borderRadius: Utils.borderRadius(r:4.0),
                                border: Border.all(color: stockColor),
                              ),
                              child: state.image.isNotEmpty || state.createdAt.isNotEmpty ? CustomImage(path: pickImage,isFile: state.image.isNotEmpty,fit: BoxFit.cover) :Column(
                                children: [
                                  const CustomImage(path: KImages.chooseFile),
                                  Utils.verticalSpace(10.0),
                                  CustomText(text: Utils.translatedText(context, 'Choose File'),color: blueColor,fontWeight: FontWeight.w500,),
                                ],
                              )
                          ),
                        ),*/
                        GestureDetector(
                          onTap: () async {
                            final image = await Utils.pickSingleImage();
                            if (image?.isNotEmpty??false) {
                              profileCubit.imageChange(image??'');
                              Future.delayed(const Duration(seconds: 1),()async{
                                await profileCubit.updateProfileAvatar();
                              });
                            }
                          },
                          child: state.image.isNotEmpty ||
                              (state.createdAt.isNotEmpty && state.createdAt != 'default.png')
                              ? pickedImg(
                              context,Stack(
                            children: [
                              ClipRRect(
                                borderRadius: Utils.borderRadius(r: 4.0),
                                child: CustomImage(
                                  path: pickImage,
                                  isFile: state.image.isNotEmpty,
                                  fit: BoxFit.fill,
                                  width: Utils.mediaQuery(context).width * 0.38,
                                  height: Utils.mediaQuery(context).height * 0.177,
                                ),
                              ),
                              Positioned(
                                right: 10.0,
                                top: 5.0,
                                child: InkWell(
                                  onTap: () async {
                                    final image = await Utils.pickSingleImage();
                                    if (image?.isNotEmpty??false) {
                                      profileCubit.imageChange(image??'');
                                      Future.delayed(const Duration(seconds: 1),()async{
                                        await profileCubit.updateProfileAvatar();
                                      });
                                    }
                                  },
                                  child: const CircleAvatar(
                                    maxRadius: 14.0,
                                    backgroundColor: secondaryColor,
                                    child: Icon(Icons.edit, color: whiteColor, size: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ): imagePickerView(context),

                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            if(Utils.isSeller(context))...[
              CardTopPart(title: 'University Information',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0).copyWith(top: 20.0)),
              CommonContainer(
                child: Column(
                  children: [
                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Institute'),
                      bottomSpace: 20.0,
                      child: BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.universityName,
                                onChanged: profileCubit.varsityName,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Institute',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.name,

                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (post.errors.name.isNotEmpty)
                              //     ErrorText(text: post.errors.name.first),
                              // ],

                            ],
                          );
                        },
                      ),
                    ),

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Location'),
                      bottomSpace: 20.0,
                      isRequired: false,
                      child:  BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.universityLocation,
                                onChanged: profileCubit.varsityLocation,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Location',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.text,
                                // inputFormatters: Utils.inputFormatter,
                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (state.name.isNotEmpty)
                              //     if (post.errors.designation.isNotEmpty)
                              //       ErrorText(text: post.errors.designation.first),
                              // ]
                            ],
                          );
                        },
                      ),
                    ),

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Time Period'),
                      bottomSpace: 20.0,
                      isRequired: false,
                      child:  BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.universityTimePeriod,
                                onChanged: profileCubit.varsityTimePeriod,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Time Period',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.text,
                                // inputFormatters: Utils.inputFormatter,
                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (state.name.isNotEmpty)
                              //     if (post.errors.designation.isNotEmpty)
                              //       ErrorText(text: post.errors.designation.first),
                              // ]
                            ],
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),

              CardTopPart(title: 'High School Information',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0).copyWith(top: 20.0)),
              CommonContainer(
                child: Column(
                  children: [
                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Institute'),
                      bottomSpace: 20.0,
                      child: BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.schoolName,
                                onChanged: profileCubit.schoolName,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Institute',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.name,

                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (post.errors.name.isNotEmpty)
                              //     ErrorText(text: post.errors.name.first),
                              // ],

                            ],
                          );
                        },
                      ),
                    ),

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Location'),
                      bottomSpace: 20.0,
                      isRequired: false,
                      child:  BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.schoolLocation,
                                onChanged: profileCubit.schoolLocation,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Location',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.text,
                                // inputFormatters: Utils.inputFormatter,
                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (state.name.isNotEmpty)
                              //     if (post.errors.designation.isNotEmpty)
                              //       ErrorText(text: post.errors.designation.first),
                              // ]
                            ],
                          );
                        },
                      ),
                    ),

                    CustomFormWidget(
                      label: Utils.translatedText(context, 'Time Period'),
                      bottomSpace: 20.0,
                      isRequired: false,
                      child:  BlocBuilder<ProfileCubit, SellerModel>(
                        builder: (context, state) {
                          // final post = state.profileState;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: state.schoolTimePeriod,
                                onChanged: profileCubit.schoolTimePeriod,
                                decoration:  InputDecoration(
                                    hintText: Utils.translatedText(context, 'Time Period',true),
                                    border:  outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder()
                                ),
                                keyboardType: TextInputType.text,
                                // inputFormatters: Utils.inputFormatter,
                              ),
                              // if (post is ProfileStateFormValidate) ...[
                              //   if (state.name.isNotEmpty)
                              //     if (post.errors.designation.isNotEmpty)
                              //       ErrorText(text: post.errors.designation.first),
                              // ]
                            ],
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),

              CardTopPart(title: 'Skills',bgColor: cardTopColor,margin: Utils.symmetric(h: 16.0).copyWith(top: 20.0)),
              CommonContainer(
                child: BlocBuilder<ProfileCubit, SellerModel>(
                  builder: (context, state) {
                    // final post = state.profileState;
                    return Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(
                        (state.skillList.length / 2).ceil(),
                            (rowIndex) {
                          final int firstIndex = rowIndex * 2;
                          final int secondIndex = firstIndex + 1;
                          final bool isLastRow = rowIndex == (state.skillList.length / 2).ceil() - 1;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: state.skillList[firstIndex],
                                  onChanged: (String text){
                                    profileCubit.updateSkill(firstIndex, text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: Utils.translatedText(context, 'New Skill', true),
                                    border: outlineBorder(),
                                    enabledBorder: outlineBorder(),
                                    focusedBorder: outlineBorder(),
                                    suffixIcon: GestureDetector(
                                      onTap: ()=>profileCubit.removeSkill(firstIndex),
                                      child: const Icon(Icons.clear, color: redColor),
                                    ),
                                  ),
                                ),
                              ),
                              if (secondIndex < state.skillList.length)...[Utils.horizontalSpace(10.0)],

                              if (secondIndex < state.skillList.length)...[
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: state.skillList[secondIndex],
                                    onChanged: (String text){
                                      profileCubit.updateSkill(secondIndex, text);
                                    },
                                    decoration: InputDecoration(
                                      hintText: Utils.translatedText(context, 'New Skill', true),
                                      border: outlineBorder(),
                                      enabledBorder: outlineBorder(),
                                      focusedBorder: outlineBorder(),
                                      suffixIcon: GestureDetector(
                                        onTap: ()=>profileCubit.removeSkill(secondIndex),
                                        child: const Icon(Icons.clear, color: redColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              if (isLastRow)...[Utils.horizontalSpace(10.0)],// Spacer before the button
                              if (isLastRow)...[
                                AddNewButton(onPressed: (){
                                  profileCubit.addSkill('');
                                }),
                              ],
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],

            Utils.verticalSpace(30.0),
          ],
        ),
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }
  Widget _bottomButton() {
    return BlocConsumer<ProfileCubit, SellerModel>(
      listener: (context, state) {
        final post = state.profileState;
        if (post is ProfileStateUpdating || post is ProfileProfileImageStateUpdating) {
          Utils.loadingDialog(context);
        } else {
          Utils.closeDialog(context);
          if (post is ProfileStateUpdateError || post is ProfileStateUpdateError) {
            if(post.statusCode == 401){
              Utils.logoutFunction(context);
            }

            Utils.errorSnackBar(context, post.message);
          } else if (post is ProfileStateUpdated || post is ProfileStateUpdated) {

            Utils.showSnackBar(context, post.message);

            profileCubit..resetState()..getProfileData();

            WidgetsBinding.instance.addPostFrameCallback((debug) {
              // debugPrint('success $debug');
              Navigator.pop(context);
            });

          }
        }

        // if (post is JobPostApplyError) {
        //   Utils.errorSnackBar(context, post.message);
        // } else if (post is JobPostApplyLoaded) {
        //   Navigator.pop(context);
        //   Utils.showSnackBar(context, post.message);
        //   // if (widget.id.isNotEmpty) {
        //   //   jobCubit.getEditJobPost(widget.id);
        //   // }
        //   // jobCubit
        //   //   ..initPage()
        //   //   ..getJobPostList();
        // }
      },
      builder: (context, state) {
        // final post = state.profileState;
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
              // const Spacer(),
              Expanded(
                child: PrimaryButton(
                  text: Utils.translatedText(context, 'Save Now'),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    profileCubit.updateUserInfo();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
