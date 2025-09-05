import 'package:equatable/equatable.dart';

import '../../utils/k_images.dart';

class OnBoardingModel extends Equatable {
  final String image;
  final String title;


  const OnBoardingModel({
    required this.image,
    required this.title,
  });

  @override
  List<Object?> get props => [image, title];
}

final List<OnBoardingModel> onBoardingData = [
    const OnBoardingModel(
    image: KImages.frame1,
    title: 'We provide high-quality services tailored just for you.',

  ),
  const OnBoardingModel(
    image: KImages.frame2,
    title: 'Your satisfaction is our number one priority',

  ),
  const OnBoardingModel(
    image: KImages.frame3,
    title: 'Let Work zone fulfill your needs and requirements today',

  ),
];
