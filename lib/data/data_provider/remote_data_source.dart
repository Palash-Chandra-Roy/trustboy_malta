import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../logic/bloc/signup/sign_up_state_model.dart';
import '../../logic/cubit/change_password/change_password_cubit.dart';
import '../../logic/cubit/forgot_password/forgot_password_state_model.dart';
import '../../logic/cubit/withdraw/withdraw_state_model.dart';
import '../models/auth/login_state_model.dart';
import '../models/chat/message_model.dart';
import '../models/contact/contact_us_model.dart';
import '../models/home/job_post.dart';
import '../models/home/seller_model.dart';
import '../models/kyc/kyc_model.dart';
import '../models/refund/refund_item.dart';
import '../models/service/service_item.dart';
import '../models/setting/currencies_model.dart';
import '../models/wallet/wallet_transaction_model.dart';
import 'network_parser.dart';
import 'remote_url.dart';

abstract class RemoteDataSources {
  Future login(LoginStateModel body);

  Future<String> userRegistration(SignUpStateModel body);

  Future<String> newUserVerification(SignUpStateModel body);

  Future<String> resendVerificationCode(Map<String, dynamic> body);

  Future<String> logout(Uri uri);

  Future<String> forgotPassword(Uri uri,Map<String, dynamic> body);

  Future<String> updatePassword(Uri uri,PasswordStateModel body);

  Future<String> deleteAccount(Uri uri, PasswordStateModel body);

  Future getSetting(Uri uri);

  Future getContactUs(Uri uri,ContactUsModel ? body);

  Future getHomeData(Uri uri);

  //service related functions
  Future serviceDetail(Uri uri);
  Future getAllServices(Uri uri);
  Future getAllSellers(Uri uri);
  Future getAllJobs(Uri uri);
  Future jobPostDetail(Uri uri);
  Future getFilterData(Uri uri);

  Future createEditInfo(Uri uri);
  Future addUpdate(Uri uri,ServiceItem body);
  Future addPackage(Uri uri,ServiceItem body);
  Future addSeoInfo(Uri uri,ServiceItem body);
  Future deleteImage(Uri uri);
  Future addImages(Uri uri,ServiceItem body);
  Future reqToPublish(Uri uri);

  Future getJobPostList(Uri uri);
  Future getJobReqList(Uri uri);
  Future applyJobPost(Uri uri,JobPostItem body);

  Future getMyJobPostList(Uri uri);
  Future jobPostCreateInfo(Uri uri);
  Future editJobPost(Uri uri);
  Future addJobPost(Uri uri,JobPostItem body);
  Future updateJobPost(Uri uri,JobPostItem body);
  Future deleteJobPost(Uri uri);
  Future hiredApplicant(Uri uri);


  // Future getMyJobPostDetail(Uri uri);
  //
  // Future getJobDetails(Uri uri);
  //
  // Future applyJob(Uri uri, JobPosts body);

  Future termsConditions(Uri url);

  Future privacyPolicy(Uri url);


  Future getWishList(Uri uri);

  Future addToWishList(Uri uri);

  Future removeWishList(Uri uri);

  Future getProfileData(Uri url);

  Future getRefunds(Uri url);


  Future updateProfile(Uri uri,SellerModel body);

  Future updateProfileAvatar(Uri uri,SellerModel body);

  Future passwordChange(Uri uri,ChangePasswordStateModel body);

  Future getProviderDashboard(Uri uri);



  Future getBuyerOrder(Uri uri);
  Future getBuyerOrderDetail(Uri uri);
  Future buyerOrderCancelOrComplete(Uri uri);
  Future<String> fileSubmission(Uri uri, RefundItem body);
  // Future buyerOrderComplete(Uri uri);

  Future getPaymentInfo(Uri uri);
  Future stripePayment(Uri uri,CurrenciesModel body);

  Future createNewWithdrawRequest(WithdrawStateModel body, Uri uri);

  Future getAccountInformation(Uri uri);

  Future getAllWithdrawList(Uri uri);

  Future getAllMethodList(Uri uri);

  Future getBuyerWallet(Uri uri);

  Future getKycInfo(Uri uri);

  Future<String> submitKyc(Uri uri, KycItem data);


  Future getChatList(Uri uri,String chatType);
  Future getMessages(Uri uri);
  Future sendMessage(Uri uri,MessageModel body);

  Future localWalletPay(Uri uri,Map<String,dynamic> body);

  Future subscriptionPlanList(Uri url);
  Future getPurchaseHistories(Uri url);

  Future paymentInfo(Uri url);

  Future freePlanEnroll(String id, Uri url);
}

typedef CallClientMethod = Future<http.Response> Function();

class RemoteDataSourcesImpl extends RemoteDataSources {
  final http.Client client;

  RemoteDataSourcesImpl({required this.client});

  final headers = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  final postDeleteHeader = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  @override
  Future login(LoginStateModel body) async {
    final uri = Uri.parse(RemoteUrls.login);
    final clientMethod = client.post(uri, body: body.toMap(), headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future<String> userRegistration(SignUpStateModel body) async {
    final uri = Uri.parse(RemoteUrls.register(body.languageCode));
    final clientMethod = client.post(uri, headers: headers, body: body.toMap());
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> newUserVerification(SignUpStateModel body) async {
    final uri = Uri.parse(RemoteUrls.userVerification(body.langCode));
    final clientMethod = client.post(uri, headers: headers,body: body.toOtpMap());
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> resendVerificationCode(Map<String, dynamic> body) async {
    final uri = Uri.parse(RemoteUrls.resendVerificationCode);

    final clientMethod =
        client.post(uri, headers: postDeleteHeader, body: body);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> forgotPassword(Uri uri,Map<String, dynamic> body) async {
    // final uri = Uri.parse(RemoteUrls.forgotUserPassWord);

    final clientMethod = client.post(uri, headers: postDeleteHeader, body: body);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> updatePassword(Uri uri,PasswordStateModel body) async {
    // final uri = Uri.parse(RemoteUrls.changePassword(body.langCode,body.langCode));
    final clientMethod =
        client.post(uri, headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        }, body: jsonEncode(body.toMap()));
    //debugPrint('password $uri');
    final responseJsonBody = await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> deleteAccount(Uri uri, PasswordStateModel body) async {
    final clientMethod = client.post(uri,
        headers: postDeleteHeader, body: {'current_password': body.password});
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> logout(Uri uri) async {
    //final uri = Uri.parse(RemoteUrls.logout(uri));

    //debugPrint('logout-url $uri');
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future getSetting(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future getContactUs(Uri uri,ContactUsModel ? body) async {
    final clientMethod = client.post(uri, body: body?.toMap()??{}, headers: postDeleteHeader);
    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getHomeData(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future serviceDetail(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future getAllServices(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future getAllSellers(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getAllJobs(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future jobPostDetail(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getFilterData(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getWishList(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future addToWishList(Uri uri) async {
    final clientMethod = client.post(uri, headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future removeWishList(Uri uri) async {
    final clientMethod = client.delete(uri, headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future getProfileData(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getRefunds(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getProviderDashboard(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future passwordChange(Uri uri,ChangePasswordStateModel body) async {
    final clientMethod = client.post(uri, headers: postDeleteHeader, body: body.toMap());
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future updateProfile(Uri uri,SellerModel body) async {
    final clientMethod =
    client.post(uri, headers: postDeleteHeader, body: body.toMap());
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future updateProfileAvatar(Uri uri,SellerModel body) async {

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body.toMap());

    request.headers.addAll(postDeleteHeader);
    if (body.image.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('image', body.image);
      request.files.add(file);
    }
    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future termsConditions(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future privacyPolicy(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future getJobPostList(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future getJobReqList(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getMyJobPostList(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future jobPostCreateInfo(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future editJobPost(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future deleteJobPost(Uri uri) async {
    final clientMethod = client.delete(uri, headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future hiredApplicant(Uri uri) async {
    final clientMethod = client.put(uri, headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getBuyerOrder(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future getBuyerOrderDetail(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }
  @override
  Future buyerOrderCancelOrComplete(Uri uri) async {
    final clientMethod = client.post(uri, headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future<String> fileSubmission(Uri uri, RefundItem body) async {

    final request = http.MultipartRequest('POST', uri);

    // request.fields.addAll(body.toMap());

    request.headers.addAll(postDeleteHeader);
    if (body.createdAt.isNotEmpty) {
      // debugPrint('pick-file ${body.createdAt}');
      final file = await http.MultipartFile.fromPath('submit_file', body.createdAt);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }


  @override
  Future addJobPost(Uri uri,JobPostItem body) async {

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body.toMap());

    request.headers.addAll(postDeleteHeader);

    if (body.thumbImage.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('thumb_image', body  .thumbImage);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
        await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future updateJobPost(Uri uri,JobPostItem body) async {

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body.toMap());

    request.headers.addAll(postDeleteHeader);

    if (body.thumbImage.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('thumb_image', body  .thumbImage);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future applyJobPost(Uri uri,JobPostItem body) async {
    final clientMethod = client.post(uri, headers: headers,body: body.toApplyMap());
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future getPaymentInfo(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future stripePayment(Uri uri,CurrenciesModel body) async {
    final clientMethod = client.post(uri, body: body.toMap(),headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future createNewWithdrawRequest(WithdrawStateModel body, Uri uri) async {
    final clientMethod = client.post(uri, headers: postDeleteHeader, body: body.toMap());
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseBody;
  }

  @override
  Future getAccountInformation(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseBody;
  }

  @override
  Future getAllWithdrawList(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseBody;
  }

  @override
  Future getAllMethodList(Uri uri) async {
    //final url = Uri.parse(RemoteUrls.getAllMethodList(token));
    final clientMethod = client.get(uri, headers: headers);
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseBody;

  }

  @override
  Future getBuyerWallet(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseBody;

  }

  @override
  Future addImages(Uri uri, ServiceItem body) async{
    final request = http.MultipartRequest('POST', uri);

    // request.fields.addAll(body.toMap());

    // final h = {
    //   'Accept': 'application/json',
    //   'Content-Type': 'application/json',
    //   'X-Requested-With': 'XMLHttpRequest',
    // };

    request.headers.addAll(postDeleteHeader);

    if (body.thumbImage.isNotEmpty && !body.thumbImage.contains('https://')) {
      final file = await http.MultipartFile.fromPath('thumb_image', body.thumbImage);
      request.files.add(file);
    }

    if (body.galleries.isNotEmpty) {
      for (int i = 0; i<body.galleries.length; i++) {
        final image = body.galleries[i];
        if(image.image.isNotEmpty && !image.image.contains('https://')){
          final file = await http.MultipartFile.fromPath('file[$i]', image.image);
          request.files.add(file);
        }
      }
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future addPackage(Uri uri, ServiceItem body) async{
    final clientMethod = client.post(uri, headers: headers,body: body.toMap());
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future addSeoInfo(Uri uri, ServiceItem body) async{
    final clientMethod = client.post(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },body: jsonEncode(body.toMap()));

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future addUpdate(Uri uri, ServiceItem body) async{
    final clientMethod = client.post(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },body: jsonEncode(body.toMap()));
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future createEditInfo(Uri uri) async{
    final clientMethod = client.get(uri, headers: headers);
    final responseBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseBody;
  }

  @override
  Future deleteImage(Uri uri) async{
    final clientMethod = client.delete(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future reqToPublish(Uri uri) async{
    final clientMethod = client.post(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getKycInfo(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody;
  }


  @override
  Future getChatList(Uri uri,String chatType) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody;
  }

  @override
  Future getMessages(Uri uri) async {
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);

    return responseJsonBody;
  }

  @override
  Future sendMessage(Uri uri,MessageModel body) async {
    final clientMethod = client.post(uri, body: body.toMap(),headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }


  @override
  Future localWalletPay(Uri uri,Map<String,dynamic> body) async {
    final clientMethod = client.post(uri, body: body,headers: postDeleteHeader);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future<String> submitKyc(Uri uri, KycItem data) async {
    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(data.toMap());

    request.headers.addAll(postDeleteHeader);
    if (data.file.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('file', data.file);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }


  @override
  Future subscriptionPlanList(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future getPurchaseHistories(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future paymentInfo(Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody;
  }

  @override
  Future freePlanEnroll(String id, Uri url) async {
    final clientMethod = client.get(url, headers: headers);
    final responseJsonBody =
    await NetworkParser.callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }
}
