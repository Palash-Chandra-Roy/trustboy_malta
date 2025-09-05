
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path/path.dart' as path;

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/order/order_detail_model.dart';
import '../../../data/models/order/order_model.dart';
import '../../../data/models/refund/refund_item.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/order_repository.dart';

part 'buyer_order_state.dart';

class BuyerOrderCubit extends Cubit<RefundItem> {

  final OrderRepository _repository;
  final LoginBloc _loginBloc;

  BuyerOrderCubit({
    required OrderRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super( RefundItem.init());

  OrderModel? orders;
  OrderDetail? detail;

  bool isNavigating = false;

  void isListen(bool val)=>emit(state.copyWith(isListen: val));

  void addId(int id)=>emit(state.copyWith(id: id));

  void addTabIndex(int id)=>emit(state.copyWith(buyerId: id));

  void addFile(String id)=>emit(state.copyWith(createdAt: id));
  void isPayment(String id){
    emit(state.copyWith(isPayment: id));
    //debugPrint('payment-string ${state.isPayment}');
  }

  void addFileExtension(String id)=>emit(state.copyWith(updatedAt: id));

  void addRefundNote(String id)=>emit(state.copyWith(note: id));

  Future<void> getBuyerOrder() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.orderList(_loginBloc.userInformation?.user?.isSeller == 1),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      //debugPrint('all-orders-url $uri');
      emit(state.copyWith(orderState: BuyerOrderLoading()));
      final result = await _repository.getBuyerOrder(uri);
      result.fold(
            (failure) {
          final errors = BuyerOrderError(failure.message, failure.statusCode);
          emit(state.copyWith(orderState: errors));
        }, (success) {
        orders = success;
        final loaded = BuyerOrderLoaded(success);
        emit(state.copyWith(orderState: loaded));
       },
      );
    }else{
      orders =  null;
      const errors = BuyerOrderError('', 401);
      emit(state.copyWith(orderState: errors));
    }
  }

  Future<void> getBuyerOrderDetail() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
          RemoteUrls.buyerOrderDetail(_loginBloc.userInformation?.user?.isSeller == 1,state.id.toString()),
          _loginBloc.userInformation?.accessToken ?? '',
          _loginBloc.state.langCode);
      //debugPrint('url $uri');
      emit(state.copyWith(orderState: BuyerOrderDetailsLoading()));
      final result = await _repository.getBuyerOrderDetail(uri);
      result.fold((failure) {
        //debugPrint('error-occured ${failure.statusCode} - ${failure.message}');
          final errors = BuyerOrderDetailError(failure.message, failure.statusCode);
          emit(state.copyWith(orderState: errors));
        }, (success) {
        detail = success;
        final loaded = BuyerOrderDetailsLoaded(success);
        emit(state.copyWith(orderState: loaded));
      },
      );
    }else{
      const errors = BuyerOrderDetailError('', 401);
      emit(state.copyWith(orderState: errors));
    }
  }

  Future<void> orderAction(OrderType type) async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){

      Uri uri;

      if(type == OrderType.accept){
         uri = Utils.tokenWithCode(RemoteUrls.orderApproved(_loginBloc.userInformation?.user?.isSeller == 1, state.id.toString()),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }else if(type == OrderType.cancel){
        uri = Utils.tokenWithCode(RemoteUrls.orderCancel(_loginBloc.userInformation?.user?.isSeller == 1, state.id.toString()),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }else if(type == OrderType.refund){
        uri = Utils.tokenWithCode(RemoteUrls.refundReq,
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode,extraParams: {
          'order_id': state.id.toString(),'note': state.note,'_method':'POST'
            });
      }else {
        uri = Utils.tokenWithCode(RemoteUrls.sellerOrderReject(state.id.toString()),
            _loginBloc.userInformation?.accessToken ?? '',
            _loginBloc.state.langCode);
      }

      debugPrint('delete-info-type $type $uri');
      emit(state.copyWith(orderState: BuyerOrderDeleteLoading()));
      final result = await _repository.buyerOrderCancelOrComplete(uri);
      result.fold((failure) {
          final errors = BuyerOrderDeleteError(failure.message, failure.statusCode);
          emit(state.copyWith(orderState: errors));
        }, (success) {
        final loaded = BuyerOrderDeleteLoaded(success);
        emit(state.copyWith(orderState: loaded));
        },
      );
    }
  }

  Future<void> fileSubmission() async {
    if(_loginBloc.userInformation?.accessToken.isNotEmpty??false){
      final uri = Utils.tokenWithCode(
        RemoteUrls.fileSubmission(state.id.toString()),
        _loginBloc.userInformation?.accessToken??'',
        _loginBloc.state.langCode,
      );
      //debugPrint('file-submission-url $uri');
      emit(state.copyWith(orderState: BuyerFileSubmitting()));
      final result = await _repository.fileSubmission(uri, state);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = BuyerFileFormError(failure.errors);
          emit(state.copyWith(orderState: errors));
        } else {
          final errors =
          BuyerFileSubmissionError(failure.message, failure.statusCode);
          emit(state.copyWith(orderState: errors));
        }
      }, (data) {
        final loaded = BuyerFileSubmitted(data);
        emit(state.copyWith(orderState: loaded));
        },
      );
    }
  }

  void initPage() {
    emit(state.copyWith(orderState: const BuyerOrderInitial()));
  }

  void kycFileClear() {
    emit(state.copyWith(createdAt: '', orderState: const BuyerOrderInitial()));
  }

  Future<Either<Failure, bool>> chatFileDownload(String remoteFile,String extension) async {
    final uri = Utils.tokenWithCode(
        RemoteUrls.chatFileDownload(remoteFile), _loginBloc.userInformation?.accessToken ?? '', _loginBloc.state.langCode);
    //debugPrint('file-download-url $uri');
    // Allow the user to choose a directory
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      //debugPrint("No directory selected.");
      return const Right(false);
    }
    final fileExtension = path.extension(remoteFile);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    // String fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension.$extension';
    // final filePath = path.join(directoryPath, fileName);
    final filePath = path.join(selectedDirectory, fileName);
    final file = File(filePath);
    HttpClient httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(uri);
      var response = await request.close();

      if (response.statusCode == 200) {
        var bytes = <int>[];
        response.listen(
          bytes.addAll,
          onDone: ()  async{
            file.writeAsBytes(bytes);
            //debugPrint("File downloaded to $filePath");
            await open_file.OpenFile.open(filePath);
          },
          onError: (e) {
            //debugPrint("Download failed: $e");
          },
          cancelOnError: true,
        );
        return const Right(true);
      } else {
        //debugPrint('Error code: ${response.statusCode}');
        return const Right(false);
      }
    } catch (e) {
      //debugPrint("Download failed: $e");
      return const Right(false);
    }
  }

}

enum OrderType {accept,cancel,other,refund,reject}
