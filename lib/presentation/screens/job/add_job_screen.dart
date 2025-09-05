import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';
import 'package:work_zone/presentation/utils/utils.dart';
import 'package:work_zone/presentation/widgets/custom_app_bar.dart';
import 'package:work_zone/presentation/widgets/custom_form.dart';
import 'package:work_zone/presentation/widgets/custom_image.dart';
import 'package:work_zone/presentation/widgets/custom_text.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/home/category_model.dart';
import '../../../data/models/home/job_post.dart';
import '../../../logic/cubit/job_post/job_post_cubit.dart';
import '../../widgets/common_container.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/primary_button.dart';
import '../service_screen/component/thumbnail_information.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {

  late JobPostCubit jobCubit;

  @override
  void initState() {
    jobCubit = context.read<JobPostCubit>();
    jobCubit.thumbImageChange('');
    if(jobCubit.state.id != 0){
    Future.microtask(() => jobCubit.editJobPost());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Utils.translatedText(context, jobCubit.state.id != 0?'Update Job': 'Post a Job')),
      body: PageRefresh(
        onRefresh: () async {
          if(jobCubit.state.id != 0){
            Future.microtask(() => jobCubit.editJobPost());
          }
        },
        child: Utils.logout(
          child: BlocConsumer<JobPostCubit, JobPostItem>(
            listener: (context, states) {
              final state = states.postState;
              if (state is JobPostEditError) {
                if (state.statusCode == 503 || jobCubit.editedJobPost == null) {
                  jobCubit.editJobPost();
                }
              }
              if(state is JobPostDeleteError){
                debugPrint('delete-err ${state.message}');
                Utils.errorSnackBar(context, state.message);
              }else if(state is JobPostDeleteError){
                debugPrint('success-err ${state.message}');

                Utils.showSnackBar(context, state.message);
              }
            },
            builder: (context, states) {
              final state = states.postState;
              if (state is JobPostEditLoading) {
                return const LoadingWidget();
              } else if (state is JobPostEditError) {
                if (state.statusCode == 503 || jobCubit.editedJobPost != null) {
                  return const LoadedEditJobView();
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is JobPostEditLoaded) {
                return const LoadedEditJobView();
              }
              if (jobCubit.editedJobPost != null) {
                return const LoadedEditJobView();
              } else {
                if(states.id == 0){
                  return const LoadedEditJobView();
                }else{
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
  Widget _bottomButton() {
    return BlocConsumer<JobPostCubit, JobPostItem>(
      listener: (context, state) {
        final post = state.postState;
        if (post is JobPostAddingLoading) {
          Utils.loadingDialog(context);
        } else {
          Utils.closeDialog(context);
          if (post is JobPostAddError) {
            if(post.statusCode == 401){
              Utils.logoutFunction(context);
            }

            Utils.errorSnackBar(context, post.message);
          } else if (post is JobPostAddedLoaded) {
            if(state.id != 0){
              Utils.showSnackBar(context, post.message);

              jobCubit.getJobPostList();

              Future.delayed(const Duration(milliseconds: 1000),(){
                Navigator.of(context).pop(true);

              });

            }else{
              Navigator.of(context).pop(true);
              Utils.showSnackBar(context, post.jobPost?.message??'');
            }


            // jobCubit.getJobPostList();
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
        final post = state.postState;
        // if (post is JobPostApplyLoading) {
        //   return const LoadingWidget();
        // }
        if(post is JobPostEditLoading){
          return const SizedBox.shrink();
        }else if(post is JobPostEditLoaded){
          return _submitButton(context, state);
        }
        if (jobCubit.editedJobPost != null){
          return _submitButton(context, state);
        }else{
          if(state.id == 0){
            return _submitButton(context, state);
          }else{
          return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _submitButton(BuildContext context, JobPostItem state) {
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
                text: Utils.translatedText(context, state.id != 0? 'Update Now':'Submit Now'),
                onPressed: () {
                  //jobCubit.clear();
                  Utils.closeKeyBoard(context);
                  if (state.id != 0) {
                    jobCubit.updateJobPost();
                  } else {
                    jobCubit.addJobPost();
                  }
                },
              ),
            ),
          ],
        ),
      );
  }
}

class LoadedEditJobView extends StatefulWidget {
  const LoadedEditJobView({super.key});

  @override
  State<LoadedEditJobView> createState() => _LoadedEditJobViewState();
}

class _LoadedEditJobViewState extends State<LoadedEditJobView> {
  late JobPostCubit jobCubit;
  late CategoryModel? _citiesModel;
  late CategoryModel? _categoryModel;
  late String? _type;

  // late QuillEditorController controller;


  @override
  void initState() {
    _initState();
    //_quillInit();
    super.initState();
  }

  _initState() {
    jobCubit = context.read<JobPostCubit>();
    if ((jobCubit.createInfo?.cities?.isNotEmpty??false)  && jobCubit.state.cityId == 0) {
      _citiesModel = jobCubit.createInfo?.cities?.first;
      jobCubit.cityIdChange(_citiesModel?.id??0);
    } else {
      _citiesModel = null;
    }

    if ((jobCubit.createInfo?.categories?.isNotEmpty??false)  && jobCubit.state.categoryId == 0) {
      _categoryModel = jobCubit.createInfo?.categories?.first;
      jobCubit.categoryIdChange(_categoryModel?.id??0);
    } else {
      _categoryModel = null;
    }

    if ((jobCubit.createInfo?.types?.isNotEmpty??false)  && jobCubit.state.jobType.isEmpty) {
      _type = jobCubit.createInfo?.types?.first;
      jobCubit.jobTypeChange(_type??'');
    }

  }

 /* _quillInit(){
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CommonContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: Utils.translatedText(context, 'Job Info'),fontWeight: FontWeight.w600,color: blackColor),
              const Divider(color: stockColor),
              CustomFormWidget(
                label: Utils.translatedText(context, 'Job Title'),
                bottomSpace: 20.0,
                child: BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    final post = state.postState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.title,
                          onChanged: jobCubit.titleChange,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Job Title',true),
                              border:  outlineBorder(),
                              enabledBorder: outlineBorder(),
                              focusedBorder: outlineBorder()
                          ),
                          keyboardType: TextInputType.text,

                        ),
                        if (post is JobPostApplyFormError) ...[
                          if (post.errors.title.isNotEmpty)
                            ErrorText(text: post.errors.title.first),
                        ],
                        if (post is JobPostApplyFormError) ...[
                          if (state.title.isNotEmpty)
                            if (post.errors.slug.isNotEmpty)
                              ErrorText(text: post.errors.slug.first),
                        ]
                      ],
                    );
                  },
                ),
              ),

              CustomFormWidget(
                label: Utils.translatedText(context, 'Start From'),
                bottomSpace: 20.0,
                child:  BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    final post = state.postState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.isUrgent,
                          onChanged: jobCubit.priceChange,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Price',true),
                              border:  outlineBorder(),
                              enabledBorder: outlineBorder(),
                              focusedBorder: outlineBorder()
                          ),
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: Utils.inputFormatter,
                        ),
                        if (post is JobPostApplyFormError) ...[
                          if (state.slug.isNotEmpty)
                            if (post.errors.regularPrice.isNotEmpty)
                              ErrorText(text: post.errors.regularPrice.first),
                        ]
                      ],
                    );
                  },
                ),
              ),

              CustomFormWidget(
                label: Utils.translatedText(context, 'Category'),
                bottomSpace: 20.0,
                child: BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    if (state.categoryId != 0 && (jobCubit.createInfo?.categories?.isNotEmpty??false)) {
                      _categoryModel = jobCubit.createInfo?.categories?.where((type) => type.id == state.categoryId)
                          .first;
                    } else {
                      debugPrint('job-status-null ${state.status}');
                    }
                    if(jobCubit.createInfo?.categories?.isNotEmpty??false){
                      return DropdownButtonFormField<CategoryModel>(
                        hint:  CustomText(text: Utils.translatedText(context, 'Select Category')),
                        isDense: true,
                        isExpanded: true,
                        value: _categoryModel,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        borderRadius: Utils.borderRadius(r: 5.0),
                        dropdownColor: whiteColor,

                        decoration: InputDecoration(
                          isDense: true,
                          border:  outlineBorder(),
                          enabledBorder: outlineBorder(),
                          focusedBorder: outlineBorder(),
                        ),
                        onChanged: (value) {
                          if (value == null) return;
                          jobCubit.categoryIdChange(value.id);
                        },

                        items: (jobCubit.createInfo?.categories?.isNotEmpty??false)?
                        jobCubit.createInfo?.categories?.map<DropdownMenuItem<CategoryModel>>(
                              (CategoryModel value) => DropdownMenuItem<CategoryModel>(
                            value: value,
                            child: CustomText(text: value.name),
                          ),
                        )
                            .toList():[],
                      );
                    }else{
                      return const SizedBox.shrink();
                    }

                  },
                ),
              ),

              CustomFormWidget(
                label: Utils.translatedText(context, 'City'),
                bottomSpace: 20.0,
                child: BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    if (state.cityId != 0 && (jobCubit.createInfo?.cities?.isNotEmpty??false)) {
                      // _jobStatus = jobStatus
                      //     .where((type) => type.name.toLowerCase() == state.status)
                      //     .first;
                      _citiesModel = jobCubit.createInfo?.cities?.where((type) => type.id == state.cityId)
                          .first;
                    } else {
                      debugPrint('job-status-null ${state.status}');
                    }
                    if(jobCubit.createInfo?.cities?.isNotEmpty??false){
                      return DropdownButtonFormField<CategoryModel>(
                        //padding: Utils.symmetric(v: 10.0, h: 0.0).copyWith(top: 0.0, right: 10.0),
                        hint:  CustomText(text: Utils.translatedText(context, 'Select City')),
                        isDense: true,
                        isExpanded: true,
                        value: _citiesModel,
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
                          jobCubit.cityIdChange(value.id);
                        },
                        items: (jobCubit.createInfo?.cities?.isNotEmpty??false)?
                        jobCubit.createInfo?.cities?.map<DropdownMenuItem<CategoryModel>>(
                              (CategoryModel value) => DropdownMenuItem<CategoryModel>(
                            value: value,
                            child: CustomText(text: value.name),
                          ),
                        )
                            .toList():[],
                      );
                    }else{
                      return const SizedBox.shrink();
                    }

                  },
                ),
              ),

              CustomFormWidget(
                label: Utils.translatedText(context, 'Job Type'),
                bottomSpace: 20.0,
                child:   BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    if (state.jobType.isNotEmpty && (jobCubit.createInfo?.types?.isNotEmpty??false)) {
                      _type = jobCubit.createInfo?.types?.where((type) => type == state.jobType)
                          .first;
                    } else {
                      debugPrint('job-status-null ${state.status}');
                    }
                    if(jobCubit.createInfo?.types?.isNotEmpty??false){
                      return DropdownButtonFormField<String>(
                        //padding: Utils.symmetric(v: 10.0, h: 0.0).copyWith(top: 0.0, right: 10.0),
                        hint:  CustomText(text:Utils.translatedText(context, 'Job Type')),
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
                          jobCubit.jobTypeChange(value);
                        },
                        items: (jobCubit.createInfo?.types?.isNotEmpty??false)?
                        jobCubit.createInfo?.types?.map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: CustomText(text: value),
                          ),
                        )
                            .toList():[],
                      );
                    }else{
                      return const SizedBox.shrink();
                    }

                  },
                ),
              ),
              /*CustomFormWidget(
                label: Utils.translatedText(context, 'Description'),
                bottomSpace: 20.0,
                child:    BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    final post = state.postState;
                    debugPrint('description-text ${state.description}');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Container(
                           decoration: BoxDecoration(
                             borderRadius: Utils.borderRadius(),
                             border: Border.all(color: stockColor),
                           ) ,
                           child: Column(
                             children: [
                               ToolBar(
                                 toolBarColor: primaryColor.withOpacity(0.1),
                                 iconSize: 16.0,
                                 activeIconColor: greenColor,
                                 controller: controller,
                                 crossAxisAlignment: WrapCrossAlignment.start,
                                 direction: Axis.horizontal,
                                 customButtons: [
                                   // Container(
                                   //   width: 25,
                                   //   height: 25,
                                   //   decoration: BoxDecoration(
                                   //       color: _hasFocus ? Colors.green : Colors.grey,
                                   //       borderRadius: BorderRadius.circular(15)),
                                   // ),
                                   // InkWell(
                                   //     onTap: () => unFocusEditor(),
                                   //     child: const Icon(
                                   //       Icons.favorite,
                                   //       color: Colors.black,
                                   //     )),
                                   // InkWell(
                                   //     onTap: () async {
                                   //       var selectedText = await controller.getSelectedText();
                                   //       debugPrint('selectedText $selectedText');
                                   //       var selectedHtmlText =
                                   //       await controller.getSelectedHtmlText();
                                   //       debugPrint('selectedHtmlText $selectedHtmlText');
                                   //     },
                                   //     child: const Icon(
                                   //       Icons.add_circle,
                                   //       color: Colors.black,
                                   //     )),
                                 ],
                               ),
                               QuillHtmlEditor(
                                 controller: controller,
                                 hintText: Utils.translatedText(context, 'Description',false),
                                 minHeight: 200.0,
                                 text: 'Hello bangldesh',
                                 // text: state.description,
                                 onTextChanged: jobCubit.descriptionChange,
                                 onEditorCreated: () => debugPrint('Editor has been loaded'),
                                 onEditorResized: (height) => debugPrint('Editor resized $height'),
                                 onSelectionChanged: (sel) => debugPrint('index ${sel.index}, range ${sel.length}'),
                               ),
                             ],
                           ),
                         ),
                          if (post is JobPostApplyFormError) ...[
                            if (state.isUrgent.isNotEmpty)
                              if (post.errors.description.isNotEmpty)
                                ErrorText(text: post.errors.description.first),
                          ]
                      ],
                    );
                  },
                ),
              ),*/
              CustomFormWidget(
                label: Utils.translatedText(context, 'Description'),
                bottomSpace: 20.0,
                child:    BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context, state) {
                    final post = state.postState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: state.description,
                          onChanged: jobCubit.descriptionChange,
                          decoration:  InputDecoration(
                              hintText: Utils.translatedText(context, 'Description',true),
                              border:  outlineBorder(10.0),
                              enabledBorder: outlineBorder(10.0),
                              focusedBorder: outlineBorder(10.0)
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                        ),
                        if (post is JobPostApplyFormError) ...[
                          if (state.isUrgent.isNotEmpty)
                            if (post.errors.description.isNotEmpty)
                              ErrorText(text: post.errors.description.first),
                        ]
                      ],
                    );
                  },
                ),
              ),
              // CustomText(text: Utils.translatedText(context, 'Upload Image'),fontWeight: FontWeight.w600,color: blackColor),
              // const Divider(color: stockColor),
              CustomFormWidget(
                label: Utils.translatedText(context, 'Upload Image'),
                bottomSpace: 0.0,
                isRequired: false,
                child: BlocBuilder<JobPostCubit, JobPostItem>(
                  builder: (context,state){
                    final existImage = state.createdAt.isNotEmpty
                        ?  RemoteUrls.imageUrl(state.createdAt):
                          Utils.defaultImg(context,false);
                    // debugPrint('existing-image $existImage');

                    final pickImage = state.thumbImage.isNotEmpty ? state.thumbImage : existImage;
                    // debugPrint('pick-image $pickImage');
                    // debugPrint('state-image ${state.thumbImage}');
                    // debugPrint('pick-image $pickImage');
                    final post = state.postState;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final image = await Utils.pickSingleImage();
                            if (image?.isNotEmpty??false) {
                              jobCubit.thumbImageChange(image??'');
                            }
                          },
                          child: state.thumbImage.isNotEmpty ||
                              (state.createdAt.isNotEmpty && state.createdAt != 'default.png')
                              ? pickedImg(
                              context,
                              ClipRRect(
                                borderRadius: Utils.borderRadius(r: 4.0),
                                child: CustomImage(
                                  path: pickImage,
                                  isFile: state.thumbImage.isNotEmpty,
                                  fit: BoxFit.fill,
                                  width: Utils.mediaQuery(context).width * 0.38,
                                  height: Utils.mediaQuery(context).height * 0.177,
                                ),
                              ))
                              : imagePickerView(context),

                        ),

                        if (post is JobPostApplyFormError) ...[
                          if (state.description.isNotEmpty)
                            if (post.errors.thumbImage.isNotEmpty)
                              ErrorText(text: post.errors.thumbImage.first),
                        ]
                      ],
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}




