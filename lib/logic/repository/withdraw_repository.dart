import 'package:dartz/dartz.dart';
import 'package:work_zone/data/models/wallet/wallet_transaction_model.dart';


import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/dashboard/dashboard_model.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/subscription/sub_detail_model.dart';
import '../../data/models/subscription/subscription_model.dart';
import '../../data/models/wallet/wallet_model.dart';
import '../../data/models/withdraw/account_info_model.dart';
import '../../data/models/withdraw/method_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';
import '../cubit/withdraw/withdraw_state_model.dart';

abstract class WithdrawRepository {
  Future<Either<Failure, AccountInfoModel>> getAccountInformation(Uri uri);

  // Future<Either<Failure, WithdrawListModel>> getAllWithdrawList(Uri uri);
  Future<Either<Failure, DashboardModel>> getAllWithdrawList(Uri uri);

  Future<Either<Failure, String>> createNewWithdrawRequest(WithdrawStateModel body, Uri uri);

  Future<Either<Failure, List<MethodModel>>> getAllMethodList(Uri uri);

  Future<Either<Failure, WalletModel>> getBuyerWallet(Uri uri);

  Future<Either<Failure, String?>> localWalletPay(Uri uri,Map<String,dynamic> body);


  Future<Either<Failure, List<SubscriptionModel>>> subscriptionPlanList(Uri url);

  Future<Either<Failure, List<SubDetailModel?>?>> getPurchaseHistories(Uri url);

  Future<Either<Failure, PaymentModel>> paymentInfo(Uri url);

  Future<Either<Failure, String>> freePlanEnroll(String id, Uri url);

}

class WithdrawRepositoryImpl implements WithdrawRepository {
  final RemoteDataSources remoteDataSources;

  const WithdrawRepositoryImpl({required this.remoteDataSources});

  @override
  Future<Either<Failure, AccountInfoModel>> getAccountInformation(Uri uri) async {
    try {
      final result = await remoteDataSources.getAccountInformation(uri);
      final info = AccountInfoModel.fromMap(result);
      return Right(info);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> createNewWithdrawRequest(WithdrawStateModel body, Uri uri) async {
    try {
      final result = await remoteDataSources.createNewWithdrawRequest(body, uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String?>> localWalletPay(Uri uri ,Map<String,dynamic> body) async {
    try {
      final result = await remoteDataSources.localWalletPay(uri,body);

      final message = result['message'];

      if (message is String) {
        return Right(message);
      } else if (message is Map && message['message'] != null) {
        return Right(message['message'].toString());
      } else {
        return Right(null);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, DashboardModel>> getAllWithdrawList(Uri uri) async {
    try {
      final result = await remoteDataSources.getAllWithdrawList(uri);
      final info = DashboardModel.fromMap(result);
      return Right(info);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<MethodModel>>> getAllMethodList(Uri uri) async {
    try {
      final result = await remoteDataSources.getAllMethodList(uri);
      final list = result['methods'] as List;
      final method = List<MethodModel>.from(list.map((e)=>MethodModel.fromMap(e))).toList();
      return Right(method);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, WalletModel>> getBuyerWallet(Uri uri) async{
    try {
      final result = await remoteDataSources.getBuyerWallet(uri);
      final info = WalletModel.fromMap(result);
      return Right(info);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionModel>>> subscriptionPlanList(Uri url) async {
    try {
      final result = await remoteDataSources.subscriptionPlanList(url);
      final plan = result['plans'] as List;
      final data = List<SubscriptionModel>.from(plan.map((e) => SubscriptionModel.fromMap(e))).toList();
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<SubDetailModel?>?>> getPurchaseHistories(Uri url) async {
    try {
      final result = await remoteDataSources.getPurchaseHistories(url);
      final plan = result['histories']['data'] as List;
      final data = List<SubDetailModel>.from(plan.map((e) => SubDetailModel.fromMap(e))).toList();
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, PaymentModel>> paymentInfo(Uri url) async {
    try {
      final result = await remoteDataSources.paymentInfo(url);
      final data = PaymentModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, String>> freePlanEnroll(String id, Uri url) async {
    try {
      final result = await remoteDataSources.freePlanEnroll(id, url);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
