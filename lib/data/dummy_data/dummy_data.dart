import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../presentation/utils/utils.dart';

class DummyPackage extends Equatable {
  final String title;
  final String value;
  final int id;

  const DummyPackage({required this.id, required this.title,required this.value});

  @override
  List<Object?> get props => [id, title,value];
}
// final List<CreateServiceDummy> deliveryTime = [
//   const CreateServiceDummy(id: '1', title: '1'),
//   const CreateServiceDummy(id: '2', title: '2'),
//   const CreateServiceDummy(id: '3', title: '3'),
//   const CreateServiceDummy(id: '4', title: '4'),
//   const CreateServiceDummy(id: '5', title: '5'),
// ];
//
// final List<CreateServiceDummy> revision = [
//   const CreateServiceDummy(id: '1', title: '1'),
//   const CreateServiceDummy(id: '2', title: '2'),
//   const CreateServiceDummy(id: '3', title: '3'),
//   const CreateServiceDummy(id: '4', title: '4'),
//   const CreateServiceDummy(id: '5', title: '5'),
// ];
//
// final List<CreateServiceDummy> functionalWeb = [
//   const CreateServiceDummy(id: '1', title: 'Yes'),
//   const CreateServiceDummy(id: '2', title: 'No'),
// ];
//
// final List<CreateServiceDummy> responsive = [
//   const CreateServiceDummy(id: '1', title: 'Yes'),
//   const CreateServiceDummy(id: '2', title: 'No'),
// ];
//
// final List<CreateServiceDummy> numberOfPage = [
//   const CreateServiceDummy(id: '1', title: '1'),
//   const CreateServiceDummy(id: '2', title: '2'),
//   const CreateServiceDummy(id: '3', title: '3'),
//   const CreateServiceDummy(id: '4', title: '4'),
//   const CreateServiceDummy(id: '5', title: '5'),
// ];
//
// final List<CreateServiceDummy> sourceCode = [
//   const CreateServiceDummy(id: '1', title: 'Yes'),
//   const CreateServiceDummy(id: '2', title: 'No'),
// ];
//
// final List<CreateServiceDummy> contentUpload = [
//   const CreateServiceDummy(id: '1', title: 'Yes'),
//   const CreateServiceDummy(id: '2', title: 'No'),
// ];
//
// final List<CreateServiceDummy> speedOptimized = [
//   const CreateServiceDummy(id: '1', title: 'Yes'),
//   const CreateServiceDummy(id: '2', title: 'No'),
// ];

 List<DummyPackage> genders(BuildContext context) => [
   DummyPackage(id: 1,value: 'male', title: Utils.translatedText(context, 'Male')),
   DummyPackage(id: 2,value: 'female', title: Utils.translatedText(context, 'Female')),
   DummyPackage(id: 3,value: 'others', title: Utils.translatedText(context, 'Others')),
];


List<DummyPackage> gateways(BuildContext context) => [
  DummyPackage(id: 1,value: 'stripe', title: Utils.translatedText(context, 'Stripe')),
  DummyPackage(id: 2,value: 'bank', title: Utils.translatedText(context, 'Bank')),
  DummyPackage(id: 3,value: 'paypal', title: Utils.translatedText(context, 'Paypal')),
  DummyPackage(id: 4,value: 'mollie', title: Utils.translatedText(context, 'Mollie')),
  DummyPackage(id: 5,value: 'razorpay', title: Utils.translatedText(context, 'Razorpay')),
  DummyPackage(id: 6,value: 'futterwave', title: Utils.translatedText(context, 'Flutterwave')),
  DummyPackage(id: 7,value: 'paysrack', title: Utils.translatedText(context, 'Paystack')),
];


List<DummyPackage>  deliveryTime = [
  const DummyPackage(id: 1, title: '1',value: ''),
  const DummyPackage(id: 2, title: '2',value: ''),
  const DummyPackage(id: 3, title: '3',value: ''),
  const DummyPackage(id: 4, title: '4',value: ''),
  const DummyPackage(id: 5, title: '5',value: ''),
];
List<DummyPackage>  revisions = [
  const DummyPackage(id: 1, title: '1',value: ''),
  const DummyPackage(id: 2, title: '2',value: ''),
  const DummyPackage(id: 3, title: '3',value: ''),
  const DummyPackage(id: 4, title: '4',value: ''),
  const DummyPackage(id: 5, title: '5',value: ''),
];
List<DummyPackage>  functionalWeb(BuildContext context) => [
  DummyPackage(id: 1, title: Utils.translatedText(context, 'Yes'),value: 'yes'),
  DummyPackage(id: 2, title: Utils.translatedText(context, 'No'),value: 'no'),
];
List<DummyPackage>  numberOfPages = [
  const DummyPackage(id: 1, title: '1',value: ''),
  const DummyPackage(id: 2, title: '2',value: ''),
  const DummyPackage(id: 3, title: '3',value: ''),
  const DummyPackage(id: 4, title: '4',value: ''),
  const DummyPackage(id: 5, title: '5',value: ''),
  const DummyPackage(id: 6, title: '6',value: ''),
  const DummyPackage(id: 7, title: '7',value: ''),
  const DummyPackage(id: 8, title: '8',value: ''),
  const DummyPackage(id: 9, title: '9',value: ''),
  const DummyPackage(id: 10, title: '10',value: ''),
];
List<DummyPackage>  responsive(BuildContext context) => [
  DummyPackage(id: 1, title: Utils.translatedText(context, 'Yes'),value: 'yes'),
  DummyPackage(id: 2, title: Utils.translatedText(context, 'No'),value: 'no'),
];
List<DummyPackage>  sourceCode(BuildContext context) => [
  DummyPackage(id: 1, title: Utils.translatedText(context, 'Yes'),value: 'yes'),
  DummyPackage(id: 2, title: Utils.translatedText(context, 'No'),value: 'no'),
];
List<DummyPackage>  contents(BuildContext context) => [
  DummyPackage(id: 1, title: Utils.translatedText(context, 'Yes'),value: 'yes'),
  DummyPackage(id: 2, title: Utils.translatedText(context, 'No'),value: 'no'),
];
List<DummyPackage>  optimize(BuildContext context) => [
  DummyPackage(id: 1, title: Utils.translatedText(context, 'Yes'),value: 'yes'),
  DummyPackage(id: 2, title: Utils.translatedText(context, 'No'),value: 'no'),
];