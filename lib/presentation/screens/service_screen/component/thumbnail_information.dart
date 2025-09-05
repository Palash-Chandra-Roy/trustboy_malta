import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/models/service/service_item.dart';

import '../../../../data/data_provider/remote_url.dart';
import '../../../../data/models/service/gallery_model.dart';
import '../../../../logic/cubit/service/service_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import '../../../widgets/common_container.dart';
import '../../../widgets/custom_form.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/horizontal_line.dart';

/*class ThumbnailInformation extends StatelessWidget {
  const ThumbnailInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final sCubit = context.read<ServiceCubit>();
    return CommonContainer(
      child: BlocBuilder<ServiceCubit, ServiceItem>(
          builder: (context, state) {

            final existImage = state.createdAt.isNotEmpty && state.createdAt != 'default.png'
                ?  RemoteUrls.imageUrl(state.createdAt):
            Utils.defaultImg(context,false);
            // debugPrint('existing-image $existImage');

            final pickImage = state.thumbImage.isNotEmpty ? state.thumbImage : existImage;
            // debugPrint('pick-image $pickImage');
            // debugPrint('state-image ${state.image}');
            // debugPrint('pick-image $pickImage');
            // final post = state.profileState;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: Utils.translatedText(context, 'Thumbnail Upload'),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  const HorizontalLine(),
                  CustomFormWidget(
                    label: Utils.translatedText(context, 'Thumbnail Image'),
                    bottomSpace: 0.0,
                    isRequired: true,
                    child: GestureDetector(
                      onTap: ()async{
                        final image = await Utils.pickSingleImage();
                        if (image?.isNotEmpty??false) {
                          sCubit.imagePick(image??'');
                        }
                      },
                      child: Container(
                          padding: Utils.symmetric(v: 6.0,h: state.thumbImage.isNotEmpty? 6.0:16.0),
                          decoration: BoxDecoration(
                            borderRadius: Utils.borderRadius(r:4.0),
                            border: Border.all(color: stockColor),
                          ),
                          child: state.thumbImage.isNotEmpty || (state.createdAt.isNotEmpty && state.createdAt != 'default.png') ? CustomImage(path: pickImage,isFile: state.thumbImage.isNotEmpty,fit: BoxFit.cover) :Column(
                            children: [
                              const CustomImage(path: KImages.chooseFile),
                              Utils.verticalSpace(10.0),
                              CustomText(text: Utils.translatedText(context, 'Choose File'),color: blueColor,fontWeight: FontWeight.w500,),
                            ],
                          )
                      ),
                    ),
                  ),


                  if (state.galleries.isNotEmpty) ...[
                    Padding(
                      padding: Utils.symmetric(h: 0.0),
                      child: Wrap(
                        // alignment: WrapAlignment.start,
                        // runAlignment: WrapAlignment.start,
                        spacing: 10.0,
                        children: List.generate(
                          state.galleries.length,
                              (index) {
                            return _buildGalleryImages(sCubit, index);
                          },
                        ),
                      ),
                    ),
                    if(state.galleries.length < 3)...[
                      GestureDetector(
                          onTap: () async {
                            final image = await Utils.pickMultipleImage();
                            if (image.isNotEmpty) {
                              for (int i = 0; i < image.length; i++) {
                                if (image[i]?.isNotEmpty??false) {
                                  final slider = GalleryModel(id: 0,listingId: 0,image: image[i]??'');
                                  sCubit.addGalleries(slider);
                                }
                              }
                            }
                          },
                          child:  CustomText(text: Utils.translatedText(context, 'Add More Image'))),
                    ],
                  ]else ...[
                    GestureDetector(
                      onTap: () async {
                        final image = await Utils.pickMultipleImage();
                        if (image.isNotEmpty) {
                          for (int i = 0; i < image.length; i++) {
                            if (image[i]?.isNotEmpty??false) {
                              final slider = GalleryModel(id: 0,listingId: 0,image: image[i]??'');
                              sCubit.addGalleries(slider);
                            }
                          }
                        }
                      },
                      child: Container(
                        height: Utils.hSize(70.0),
                        margin: Utils.symmetric(v: 16.0),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          borderRadius: Utils.borderRadius(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Utils.horizontalSpace(5.0),
                            const Icon(
                              Icons.image_outlined,
                              color: primaryColor,
                            ),
                            Utils.horizontalSpace(5.0),
                            Flexible(
                              child: CustomText(
                                text: Utils.translatedText(context, 'Gallery Images'),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                maxLine: 2,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
          },
        ),
    );
  }

  Widget _buildGalleryImages(ServiceCubit addProperty, int index) {
    final item = addProperty.state.galleries[index].image;
    String sliderImage = item.isEmpty ? KImages.chooseFile : item;
    bool isSliderFile = item.isNotEmpty
        ? item.contains('https://')
        ? false
        : true
        : false;
    return Stack(
      children: [
        Container(
          height: 80.0,
          margin: Utils.symmetric(v: 6.0, h: 0.0),
          width: 106.0,
          child: ClipRRect(
            borderRadius: Utils.borderRadius(r: 2.0),
            child: CustomImage(
              path: sliderImage,
              isFile: isSliderFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if(addProperty.state.galleries[index].id == 0)...[
          Positioned(
            left: 4,
            top: 10,
            child: InkWell(
              onTap: () async {
                final image = await Utils.pickSingleImage();
                if (image != null && image.isNotEmpty) {
                  final slider = addProperty.state.galleries[index].copyWith(image: image);
                  addProperty.updateGalleries(slider,index);
                }
              },
              child: const CircleAvatar(
                maxRadius: 10.0,
                backgroundColor: Color(0xff18587A),
                child: Icon(Icons.edit, color: Colors.white, size: 12.0),
              ),
            ),
          ),
        ],
        Positioned(
          right: 4,
          top: 10,
          child: InkWell(
            onTap: () {
              final itemId = addProperty.state.galleries[index].id;
              if (itemId > 0) {
                debugPrint('idd $itemId');
                addProperty.deleteGalleryImg(itemId);
                Future.delayed(const Duration(milliseconds: 500),(){
                  addProperty.deleteGalleries(index);
                });
              }else{
              addProperty.deleteGalleries(index);
              }
            },
            child: const CircleAvatar(
              maxRadius: 10.0,
              backgroundColor: Color(0xff18587A),
              child: Icon(Icons.delete, color: Colors.red, size: 12.0),
            ),
          ),
        )
      ],
    );
  }
}*/

class ThumbnailInformation extends StatelessWidget {
  const ThumbnailInformation({super.key});

  @override
  Widget build(BuildContext context) {
    // debugPrint('height ${Utils.mediaQuery(context).height * 0.177}');
    // debugPrint('height ${Utils.mediaQuery(context).width * 0.332}');
    final sCubit = context.read<ServiceCubit>();
    return CommonContainer(
      child: BlocBuilder<ServiceCubit, ServiceItem>(
        builder: (context, state) {
          final existImage =
          state.createdAt.isNotEmpty && state.createdAt != 'default.png'
              ? RemoteUrls.imageUrl(state.createdAt)
              : Utils.defaultImg(context, false);


          final pickImage =
          state.thumbImage.isNotEmpty ? state.thumbImage : existImage;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: Utils.translatedText(context, 'Thumbnail Upload'),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
              const HorizontalLine(),
              CustomFormWidget(
                label: Utils.translatedText(context, 'Thumbnail Image'),
                bottomSpace: 0.0,
                isRequired: true,
                child: GestureDetector(
                  onTap: () async {
                    final image = await Utils.pickSingleImage();
                    if (image?.isNotEmpty ?? false) {
                      sCubit.imagePick(image ?? '');
                    }
                  },
                  child: state.thumbImage.isNotEmpty ||
                      (state.createdAt.isNotEmpty && state.createdAt != 'default.png')
                      ? pickedImg(
                      context,Stack(
                    children: [
                      ClipRRect(
                        borderRadius: Utils.borderRadius(r: 4.0),
                        child: CustomImage(
                          path: pickImage,
                          isFile: state.thumbImage.isNotEmpty,
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
                            if (image?.isNotEmpty ?? false) {
                              sCubit.imagePick(image ?? '');
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
                  )
                      ,
                  )
                      : imagePickerView(context),

                ),
              ),

              if (state.galleries.isNotEmpty) ...[
                Utils.verticalSpace(10.0),
                Wrap(
                  runSpacing: 8.0,
                  spacing: 6.0,
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.center,
                  children: [
                    ...List.generate(state.galleries.length, (index) {
                      // final item = items[index];
                      // return SingleService(item: item,width: Utils.mediaQuery(context).width * 0.46);
                      return SingleChildScrollView(
                        child: _buildGalleryImages(context, sCubit, index),
                      );
                    }),
                    if (state.galleries.length % 2 == 1) ...[
                      SizedBox(width: Utils.mediaQuery(context).width * 0.38),
                    ],
                  ],
                ),
                if(state.galleries.length < 3)...[
                  Utils.verticalSpace(10.0),
                  GestureDetector(
                    onTap: () async {
                      final image = await Utils.pickMultipleImage();
                      if (image.isNotEmpty) {
                        for (int i = 0; i < image.length; i++) {
                          if (image[i]?.isNotEmpty??false) {
                            final slider = GalleryModel(id: 0,listingId: 0,image: image[i]??'');
                            sCubit.addGalleries(slider);
                          }
                        }
                      }
                    },
                    child: imagePickerView(context,'Add More'),
                  ),
                ]
              ] else...[
                Utils.verticalSpace(10.0),
                GestureDetector(
                  onTap: () async {
                    final image = await Utils.pickMultipleImage();
                    if (image.isNotEmpty) {
                      for (int i = 0; i < image.length; i++) {
                        if (image[i]?.isNotEmpty??false) {
                          final slider = GalleryModel(id: 0,listingId: 0,image: image[i]??'');
                          sCubit.addGalleries(slider);
                        }
                      }
                    }
                  },
                  child: imagePickerView(context,'Add Gallery'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }


  Widget _buildGalleryImages(BuildContext context,ServiceCubit addProperty, int index) {
    final item = addProperty.state.galleries[index].image;
    String sliderImage = item.isEmpty ? KImages.chooseFile : item;
    bool isSliderFile = item.isNotEmpty
        ? item.contains('https://')
        ? false
        : true
        : false;
    return Stack(
      children: [
        Container(
          width: Utils.mediaQuery(context).width * 0.38,
          height: Utils.mediaQuery(context).height * 0.177,
          margin: Utils.symmetric(v: 6.0, h: 0.0),
          child: ClipRRect(
            borderRadius: Utils.borderRadius(r: 4.0),
            child: CustomImage(
              path: sliderImage,
              isFile: isSliderFile,
              fit: BoxFit.fill,
            ),
          ),
        ),


       /* if (addProperty.state.galleries[index].id == 0) ...[
          Positioned(
            left: 4,
            top: 10,
            child: InkWell(
              onTap: () async {
                final image = await Utils.pickSingleImage();
                if (image != null && image.isNotEmpty) {
                  final slider =
                  addProperty.state.galleries[index].copyWith(image: image);
                  addProperty.updateGalleries(slider, index);
                }
              },
              child: const CircleAvatar(
                maxRadius: 10.0,
                backgroundColor: Color(0xff18587A),
                child: Icon(Icons.edit, color: Colors.white, size: 12.0),
              ),
            ),
          ),
        ],*/
        Positioned(
          right: 4,
          top: 10,
          child: InkWell(
            onTap: () {
              final itemId = addProperty.state.galleries[index].id;
              if (itemId > 0) {
                debugPrint('idd $itemId');
                addProperty.deleteGalleryImg(itemId);
                Future.delayed(const Duration(milliseconds: 500), () {
                  addProperty.deleteGalleries(index);
                });
              } else {
                addProperty.deleteGalleries(index);
              }
            },
            child: const CircleAvatar(
              maxRadius: 12.0,
              backgroundColor: redColor,
              child: Icon(Icons.delete, color: whiteColor, size: 14.0),
            ),
          ),
        )
      ],
    );
  }
}

Widget imagePickerView(BuildContext context,[String title = 'Choose File']) {
  return Container(
    alignment: Alignment.center,
    padding: Utils.symmetric(v: 0.0,h: 0.0),
    width: Utils.mediaQuery(context).width * 0.38,
    height: Utils.mediaQuery(context).height * 0.177,
    child: DottedBorder(
      padding: Utils.symmetric(v: 35.0,h: 30.0),
      borderType: BorderType.RRect,
      radius: Radius.circular(Utils.radius(4.0)),
      color: const Color(0xFFCECECE),
      dashPattern: const [6, 3],
      strokeCap: StrokeCap.square,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_outlined,
            color: grayColor,
          ),
          Utils.verticalSpace(8.0),
          CustomText(
            text: Utils.translatedText(context, title),
            color: blueColor,
            fontWeight: FontWeight.w500,
            maxLine: 1,
          )
        ],
      ),
    ),
  );
}

Widget pickedImg(BuildContext context, Widget child) {
  return Container(
    margin: Utils.symmetric(v: 0.0, h: 0.0),
    // padding: Utils.symmetric(h: 0.0,v: 30.0),
    alignment: Alignment.center,
    width: Utils.mediaQuery(context).width * 0.38,
    height: Utils.mediaQuery(context).height * 0.177,
    child: child,
  );
}




